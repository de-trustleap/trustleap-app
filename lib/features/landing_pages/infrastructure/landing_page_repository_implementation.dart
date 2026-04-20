// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/cloud_functions_service.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/failures/storage_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/features/legals/domain/archived_landing_page_legals.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page_image_data.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page_template.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_ai_generation.dart';
import 'package:finanzbegleiter/features/promoter/domain/promoter.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page_repository.dart';
import 'package:finanzbegleiter/features/legals/infrastructure/archived_landing_page_legals_model.dart';
import 'package:finanzbegleiter/features/landing_pages/infrastructure/landing_page_model.dart';
import 'package:finanzbegleiter/features/landing_pages/infrastructure/landing_page_template_model.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_ai_generation_model.dart';
import 'package:finanzbegleiter/features/promoter/infrastructure/unregistered_promoter_model.dart';
import 'package:finanzbegleiter/features/profile/infrastructure/user_model.dart';
import 'package:finanzbegleiter/features/landing_pages/infrastructure/landing_page_repository_sorting_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class LandingPageRepositoryImplementation implements LandingPageRepository {
  final FirebaseFirestore firestore;
  final CloudFunctionsService cloudFunctions;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  LandingPageRepositoryImplementation(
      {required this.firestore,
      required this.cloudFunctions,
      required this.firebaseAuth,
      required this.firebaseStorage});

  @override
  Stream<Either<DatabaseFailure, List<LandingPage>>> observeLandingPagesByIds(
      List<String> ids) async* {
    if (ids.isEmpty) {
      yield right([]);
      return;
    }

    final landingPagesCollection = firestore.collection("landingPages");

    try {
      // Handle chunks of max 10 IDs due to Firestore whereIn limitation
      final chunks = ids.slices(10);

      if (chunks.length == 1) {
        // Single chunk - simple stream
        yield* landingPagesCollection
            .where(FieldPath.documentId, whereIn: chunks.first)
            .snapshots()
            .map((snapshot) {
          final List<LandingPage> landingPages = [];
          for (var doc in snapshot.docs) {
            var model =
                LandingPageModel.fromFirestore(doc.data(), doc.id).toDomain();
            landingPages.add(model);
          }
          final sortedPages = LandingPageRepositorySortingHelper()
              .sortLandingPages(landingPages);
          return right<DatabaseFailure, List<LandingPage>>(sortedPages);
        }).handleError((e) {
          if (e is FirebaseException) {
            return left(
                FirebaseExceptionParser.getDatabaseException(code: e.code));
          } else {
            return left(BackendFailure());
          }
        });
      } else {
        // Multiple chunks - combine all streams using rxdart
        final chunkStreams = chunks
            .map((chunk) => landingPagesCollection
                .where(FieldPath.documentId, whereIn: chunk)
                .orderBy("name", descending: true)
                .snapshots()
                .map((snapshot) => snapshot.docs))
            .toList();

        // Combine all chunk streams into one stream that emits when any chunk changes
        yield* Rx.combineLatestList(chunkStreams).map((listOfDocLists) {
          final List<LandingPage> landingPages = [];
          // Flatten all document lists into one list
          for (var docList in listOfDocLists) {
            for (var doc in docList) {
              var model =
                  LandingPageModel.fromFirestore(doc.data(), doc.id).toDomain();
              landingPages.add(model);
            }
          }
          final sortedPages = LandingPageRepositorySortingHelper()
              .sortLandingPages(landingPages);
          return right<DatabaseFailure, List<LandingPage>>(sortedPages);
        }).handleError((e) {
          if (e is FirebaseException) {
            return left(
                FirebaseExceptionParser.getDatabaseException(code: e.code));
          } else {
            return left(BackendFailure());
          }
        });
      }
    } on FirebaseException catch (e) {
      yield left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, List<LandingPage>>> getAllLandingPages(
      List<String> ids) async {
    final landingPagesCollection = firestore.collection("landingPages");
    // The ids needs to be sliced into chunks of 10 elements because the whereIn function can only process 10 elements at once.
    final chunks = ids.slices(10);
    final List<QuerySnapshot<Map<String, dynamic>>> querySnapshots = [];
    final List<LandingPage> landingPages = [];
    try {
      await Future.forEach(chunks, (element) async {
        final document = await landingPagesCollection
            .orderBy("name", descending: true)
            .where(FieldPath.documentId, whereIn: element)
            .get();
        querySnapshots.add(document);
      });
      for (var document in querySnapshots) {
        for (var snapshot in document.docs) {
          var doc = snapshot.data();
          var model =
              LandingPageModel.fromFirestore(doc, snapshot.id).toDomain();
          landingPages.add(model);
        }
      }
      final sortedPages =
          LandingPageRepositorySortingHelper().sortLandingPages(landingPages);
      return right(sortedPages);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, Unit>> createLandingPage(
      LandingPage landingPage,
      LandingPageImageData imageData,
      String templateID,
      PagebuilderAiGeneration? aiGeneration) async {
    final landingPageModel = LandingPageModel.fromDomain(landingPage);
    var companyData = landingPageModel.companyData;
    var aiGenerationMap = {};
    if (aiGeneration != null) {
      aiGenerationMap =
          PagebuilderAiGenerationModel.fromDomain(aiGeneration).toMap();
    }
    companyData = {
      'id': companyData?['id'],
      'name': companyData?['name'],
      'industry': companyData?['industry'],
      'address': companyData?['address'],
      'postCode': companyData?['postCode'],
      'place': companyData?['place'],
      'phoneNumber': companyData?['phoneNumber'],
      'websiteURL': companyData?['websiteURL'],
    };
    return cloudFunctions.call(
      'createLandingPage',
      {
        'id': landingPageModel.id,
        'name': landingPageModel.name,
        'description': landingPageModel.description,
        'promotionTemplate': landingPageModel.promotionTemplate,
        'impressum': landingPage.impressum,
        'privacyPolicy': landingPage.privacyPolicy,
        'initialInformation': landingPage.initialInformation,
        'termsAndConditions': landingPage.termsAndConditions,
        'scripts': landingPage.scriptTags,
        'ownerID': landingPageModel.ownerID,
        'imageData': imageData.mainImage != null
            ? base64Encode(imageData.mainImage!)
            : null,
        'imageHasChanged': imageData.mainImageHasChanged,
        'faviconData': imageData.faviconImage != null
            ? base64Encode(imageData.faviconImage!)
            : null,
        'faviconHasChanged': imageData.faviconImageHasChanged,
        'shareImageData': imageData.shareImage != null
            ? base64Encode(imageData.shareImage!)
            : null,
        'shareImageHasChanged': imageData.shareImageHasChanged,
        'isDefaultPage': landingPageModel.isDefaultPage,
        'isActive': landingPageModel.isActive,
        'templateID': templateID,
        'contactEmailAddress': landingPageModel.contactEmailAddress,
        'businessModel': landingPageModel.businessModel,
        'contactOption': landingPageModel.contactOption,
        'calendlyEventURL': landingPageModel.calendlyEventURL,
        'companyData': landingPageModel.companyData != null ? companyData : null,
        'aiGeneration': aiGeneration != null ? aiGenerationMap : null,
      },
      (_) => unit,
      options: HttpsCallableOptions(timeout: const Duration(minutes: 6)),
    );
  }

  @override
  Future<Either<DatabaseFailure, Unit>> deleteLandingPage(
      String id, String ownerID) async {
    return cloudFunctions.call(
      'deleteLandingPage',
      {'id': id, 'ownerID': ownerID},
      (_) => unit,
    );
  }

  @override
  Future<Either<DatabaseFailure, Unit>> editLandingPage(
      LandingPage landingPage, LandingPageImageData imageData) async {
    final landingPageModel = LandingPageModel.fromDomain(landingPage);
    return cloudFunctions.call(
      'editLandingPage',
      {
        'id': landingPageModel.id,
        'title': landingPageModel.name,
        'description': landingPageModel.description,
        'promotionTemplate': landingPageModel.promotionTemplate,
        'impressum': landingPageModel.impressum,
        'privacyPolicy': landingPageModel.privacyPolicy,
        'initialInformation': landingPageModel.initialInformation,
        'termsAndConditions': landingPageModel.termsAndConditions,
        'scripts': landingPageModel.scriptTags,
        'ownerID': landingPageModel.ownerID,
        'imageData': imageData.mainImageHasChanged && imageData.mainImage != null
            ? base64Encode(imageData.mainImage!)
            : null,
        'imageHasChanged': imageData.mainImageHasChanged,
        'faviconData': imageData.faviconImage != null
            ? base64Encode(imageData.faviconImage!)
            : null,
        'faviconHasChanged': imageData.faviconImageHasChanged,
        'shareImageData': imageData.shareImage != null
            ? base64Encode(imageData.shareImage!)
            : null,
        'shareImageHasChanged': imageData.shareImageHasChanged,
        'isDefaultPage': landingPageModel.isDefaultPage,
        'isActive': landingPageModel.isActive,
        'businessModel': landingPageModel.businessModel,
        'contactEmailAddress': landingPageModel.contactEmailAddress,
        'contactOption': landingPageModel.contactOption,
        'calendlyEventURL': landingPageModel.calendlyEventURL,
      },
      (_) => unit,
    );
  }

  @override
  Future<Either<DatabaseFailure, Unit>> duplicateLandingPage(String id) async {
    return cloudFunctions.call(
      'duplicateLandingPage',
      {'id': id},
      (_) => unit,
    );
  }

  @override
  Future<Either<DatabaseFailure, Unit>> toggleLandingPageActivity(
      String id, bool isActive, String userId) async {
    return cloudFunctions.call(
      'toggleLandingPageActivity',
      {'id': id, 'isActive': isActive, 'userId': userId},
      (_) => unit,
    );
  }

  @override
  Future<Either<DatabaseFailure, LandingPage>> getLandingPage(String id) async {
    final landingPagesCollection = firestore.collection("landingPages");
    try {
      final document = await landingPagesCollection.doc(id).get();
      if (!document.exists && document.data() != null) {
        return left(NotFoundFailure());
      }
      var model =
          LandingPageModel.fromFirestore(document.data()!, id).toDomain();
      return right(model);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, List<LandingPageTemplate>>>
      getAllLandingPageTemplates() async {
    try {
      final QuerySnapshot querySnapshot =
          await firestore.collection("landingPagesTemplates").get();
      List<LandingPageTemplate> templates = [];
      for (final doc in querySnapshot.docs) {
        final map = doc.data() as Map<String, dynamic>;
        templates.add(
            LandingPageTemplateModel.fromFirestore(map, doc.id).toDomain());
      }
      return right(templates);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, List<Promoter>>> getUnregisteredPromoters(
      List<String> associatedUsersIDs) async {
    final unregisteredCollection =
        firestore.collection("unregisteredPromoters");
    // The ids needs to be sliced into chunks of 10 elements because the whereIn function can only process 10 elements at once.
    final chunks = associatedUsersIDs.slices(10);
    final List<QuerySnapshot<Map<String, dynamic>>> querySnapshots = [];
    final List<Promoter> promoters = [];
    try {
      await Future.forEach(chunks, (element) async {
        final document = await unregisteredCollection
            .where(FieldPath.documentId, whereIn: element)
            .get();
        querySnapshots.add(document);
      });
      for (var document in querySnapshots) {
        for (var snapshot in document.docs) {
          var doc = snapshot.data();
          var model = UnregisteredPromoterModel.fromFirestore(doc, snapshot.id)
              .toDomain();
          var promoter = Promoter.fromUnregisteredPromoter(model);
          promoters.add(promoter);
        }
      }
      return right(promoters);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, List<Promoter>>> getRegisteredPromoters(
      List<String> associatedUsersIDs) async {
    final registeredCollection = firestore.collection("users");
    // The ids needs to be sliced into chunks of 10 elements because the whereIn function can only process 10 elements at once.
    final chunks = associatedUsersIDs.slices(10);
    final List<QuerySnapshot<Map<String, dynamic>>> querySnapshots = [];
    final List<Promoter> promoters = [];
    try {
      await Future.forEach(chunks, (element) async {
        final document = await registeredCollection
            .where(FieldPath.documentId, whereIn: element)
            .get();
        querySnapshots.add(document);
      });
      for (var document in querySnapshots) {
        for (var snapshot in document.docs) {
          var doc = snapshot.data();
          var model = UserModel.fromFirestore(doc, snapshot.id).toDomain();
          var promoter = Promoter.fromUser(model);
          promoters.add(promoter);
        }
      }
      return right(promoters);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, List<LandingPage>>>
      getLandingPagesForPromoters(List<Promoter> promoters) async {
    final landingPageCollection = firestore.collection("landingPages");
    try {
      final Set<String> allLandingPageIDs = promoters
          .expand((promoter) => promoter.landingPageIDs ?? [])
          .toSet()
          .cast<String>();

      if (allLandingPageIDs.isEmpty) {
        return right([]);
      }
      final List<QuerySnapshot<Map<String, dynamic>>> querySnapshots = [];
      final List<LandingPage> landingPages = [];

      final chunks = allLandingPageIDs.toList().slices(10);
      await Future.forEach(chunks, (chunk) async {
        final querySnapshot = await landingPageCollection
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        querySnapshots.add(querySnapshot);
      });
      for (var snapshot in querySnapshots) {
        for (var doc in snapshot.docs) {
          var data = doc.data();
          var landingPage =
              LandingPageModel.fromFirestore(data, doc.id).toDomain();
          landingPages.add(landingPage);
        }
      }

      return right(landingPages);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, ArchivedLandingPageLegals>>
      getArchivedLandingPageLegals(String landingPageId) async {
    final archivedLegalsCollection =
        firestore.collection("archivedLandingPageLegals");
    try {
      final document = await archivedLegalsCollection.doc(landingPageId).get();

      if (!document.exists || document.data() == null) {
        return right(ArchivedLandingPageLegals(id: landingPageId));
      }

      final data = document.data()!;
      data['id'] = landingPageId;
      return right(ArchivedLandingPageLegalsModel.fromMap(data).toDomain());
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<StorageFailure, List<String>>>
      getShareImageTemplateUrls() async {
    try {
      final listResult = await firebaseStorage
          .ref("landingPageShareImageTemplates")
          .listAll();
      final urls = await Future.wait(
          listResult.items.map((ref) => ref.getDownloadURL()));
      return right(urls);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getStorageException(code: e.code));
    }
  }
}
