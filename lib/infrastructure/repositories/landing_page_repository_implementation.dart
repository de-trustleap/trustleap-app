// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/landing_page_template.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_ai_generation.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/domain/repositories/landing_page_repository.dart';
import 'package:finanzbegleiter/infrastructure/models/landing_page_model.dart';
import 'package:finanzbegleiter/infrastructure/models/landing_page_template_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_ai_generation_model.dart';
import 'package:finanzbegleiter/infrastructure/models/unregistered_promoter_model.dart';
import 'package:finanzbegleiter/infrastructure/models/user_model.dart';
import 'package:finanzbegleiter/infrastructure/repositories/landing_page_repository_sorting_helper.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class LandingPageRepositoryImplementation implements LandingPageRepository {
  final FirebaseFirestore firestore;
  final FirebaseFunctions firebaseFunctions;
  final FirebaseAuth firebaseAuth;
  final FirebaseAppCheck appCheck;

  LandingPageRepositoryImplementation(
      {required this.firestore,
      required this.firebaseFunctions,
      required this.firebaseAuth,
      required this.appCheck});

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
      Uint8List imageData,
      bool imageHasChanged,
      String templateID,
      PagebuilderAiGeneration? aiGeneration) async {
    final appCheckToken = await appCheck.getToken();
    HttpsCallable callable = firebaseFunctions.httpsCallable(
        "createLandingPage",
        options: HttpsCallableOptions(timeout: const Duration(minutes: 6)));
    final landingPageModel = LandingPageModel.fromDomain(landingPage);
    var companyData = landingPageModel.companyData;
    var aiGenerationMap = {};
    if (aiGeneration != null) {
      aiGenerationMap =
          PagebuilderAiGenerationModel.fromDomain(aiGeneration).toMap();
    }
    companyData = {
      "id": companyData?["id"],
      "name": companyData?["name"],
      "industry": companyData?["industry"],
      "address": companyData?["address"],
      "postCode": companyData?["postCode"],
      "place": companyData?["place"],
      "phoneNumber": companyData?["phoneNumber"],
      "websiteURL": companyData?["websiteURL"]
    };
    try {
      await callable.call({
        "appCheckToken": appCheckToken,
        "id": landingPageModel.id,
        "name": landingPageModel.name,
        "description": landingPageModel.description,
        "promotionTemplate": landingPageModel.promotionTemplate,
        "impressum": landingPage.impressum,
        "privacyPolicy": landingPage.privacyPolicy,
        "initialInformation": landingPage.initialInformation,
        "termsAndConditions": landingPage.termsAndConditions,
        "scripts": landingPage.scriptTags,
        "ownerID": landingPageModel.ownerID,
        "imageData": base64Encode(imageData),
        "imageHasChanged": imageHasChanged,
        "isDefaultPage": landingPageModel.isDefaultPage,
        "isActive": landingPageModel.isActive,
        "templateID": templateID,
        "contactEmailAddress": landingPageModel.contactEmailAddress,
        "companyData":
            landingPageModel.companyData != null ? companyData : null,
        "aiGeneration": aiGeneration != null ? aiGenerationMap : null
      });
      return right(unit);
    } on FirebaseFunctionsException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, Unit>> deleteLandingPage(
      String id, String ownerID) async {
    final appCheckToken = await appCheck.getToken();
    HttpsCallable callable =
        firebaseFunctions.httpsCallable("deleteLandingPage");
    try {
      await callable
          .call({"appCheckToken": appCheckToken, "id": id, "ownerID": ownerID});
      return right(unit);
    } on FirebaseFunctionsException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, Unit>> editLandingPage(LandingPage landingPage,
      Uint8List? imageData, bool imageHasChanged) async {
    final appCheckToken = await appCheck.getToken();
    HttpsCallable callable = firebaseFunctions.httpsCallable("editLandingPage");
    try {
      await callable.call({
        "appCheckToken": appCheckToken,
        "id": landingPage.id.value,
        "title": landingPage.name,
        "description": landingPage.description,
        "promotionTemplate": landingPage.promotionTemplate,
        "impressum": landingPage.impressum,
        "privacyPolicy": landingPage.privacyPolicy,
        "initialInformation": landingPage.initialInformation,
        "termsAndConditions": landingPage.termsAndConditions,
        "scripts": landingPage.scriptTags,
        "ownerID": landingPage.ownerID?.value,
        "imageData": imageData != null ? base64Encode(imageData) : null,
        "imageHasChanged": imageHasChanged,
        "isDefaultPage": landingPage.isDefaultPage,
        "isActive": landingPage.isActive,
        "contactEmailAddress": landingPage.contactEmailAddress
      });
      return right(unit);
    } on FirebaseFunctionsException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, Unit>> duplicateLandingPage(String id) async {
    final appCheckToken = await appCheck.getToken();
    HttpsCallable callable =
        firebaseFunctions.httpsCallable("duplicateLandingPage");
    try {
      await callable.call({"appCheckToken": appCheckToken, "id": id});
      return right(unit);
    } on FirebaseFunctionsException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, Unit>> toggleLandingPageActivity(
      String id, bool isActive, String userId) async {
    HttpsCallable callable =
        firebaseFunctions.httpsCallable("toggleLandingPageActivity");
    try {
      await callable.call({"id": id, "isActive": isActive, "userId": userId});
      return right(unit);
    } on FirebaseFunctionsException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
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
}
