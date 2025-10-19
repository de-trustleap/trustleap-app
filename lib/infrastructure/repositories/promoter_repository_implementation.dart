// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/domain/entities/unregistered_promoter.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/promoter_repository.dart';
import 'package:finanzbegleiter/infrastructure/models/landing_page_model.dart';
import 'package:finanzbegleiter/infrastructure/models/unregistered_promoter_model.dart';
import 'package:finanzbegleiter/infrastructure/models/user_model.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:rxdart/rxdart.dart';

class PromoterRepositoryImplementation implements PromoterRepository {
  final FirebaseFirestore firestore;
  final FirebaseFunctions firebaseFunctions;
  final FirebaseAppCheck appCheck;

  PromoterRepositoryImplementation(
      {required this.firestore,
      required this.firebaseFunctions,
      required this.appCheck});

  @override
  Future<Either<DatabaseFailure, Unit>> registerPromoter(
      {required UnregisteredPromoter promoter}) async {
    final appCheckToken = await appCheck.getToken();
    HttpsCallable callable = firebaseFunctions.httpsCallable("createPromoter");
    final promoterMap = UnregisteredPromoterModel.fromDomain(promoter).toMap();
    promoterMap.remove("createdAt");
    promoterMap.remove("expiresAt");
    promoterMap["appCheckToken"] = appCheckToken;
    try {
      await callable.call(promoterMap);
      return right(unit);
    } on FirebaseFunctionsException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, bool>> checkIfPromoterAlreadyExists(
      {required String email}) async {
    final promoterCollection = firestore.collection("unregisteredPromoters");
    final usersCollection = firestore.collection("users");
    try {
      final promoter = await promoterCollection
          .where("email", isEqualTo: email)
          .limit(1)
          .get();
      final user =
          await usersCollection.where("email", isEqualTo: email).limit(1).get();
      if (promoter.docs.isEmpty && user.docs.isEmpty) {
        return right(false);
      } else {
        if (promoter.docs.isNotEmpty && promoter.docs.first.exists) {
          return right(true);
        } else if (user.docs.isNotEmpty && user.docs.first.exists) {
          return right(true);
        } else {
          return right(false);
        }
      }
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Stream<Either<DatabaseFailure, List<Promoter>>> observePromotersByIds({
    required List<String> registeredIds,
    required List<String> unregisteredIds,
  }) async* {
    if (registeredIds.isEmpty && unregisteredIds.isEmpty) {
      yield right([]);
      return;
    }

    try {
      // Create streams for both registered and unregistered promoters
      Stream<List<Promoter>> registeredStream = registeredIds.isEmpty
          ? Stream.value([])
          : _observeRegisteredPromotersById(registeredIds);

      Stream<List<Promoter>> unregisteredStream = unregisteredIds.isEmpty
          ? Stream.value([])
          : _observeUnregisteredPromotersById(unregisteredIds);

      // Combine both streams
      yield* Rx.combineLatest2(
        registeredStream,
        unregisteredStream,
        (List<Promoter> registered, List<Promoter> unregistered) async {
          // Combine both lists
          final allPromoters = [...registered, ...unregistered];

          // Fetch and assign landing pages
          final promotersWithLandingPages =
              await _fetchAndAssignLandingPagesForStream(allPromoters);

          // Sort promoters
          final sortedPromoters =
              _sortPromotersForStream(promotersWithLandingPages);

          return right<DatabaseFailure, List<Promoter>>(sortedPromoters);
        },
      ).asyncMap((future) => future).handleError((e) {
        if (e is FirebaseException) {
          return left(
              FirebaseExceptionParser.getDatabaseException(code: e.code));
        } else {
          return left(BackendFailure());
        }
      });
    } on FirebaseException catch (e) {
      yield left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  Stream<List<Promoter>> _observeRegisteredPromotersById(List<String> ids) {
    final usersCollection = firestore.collection("users");
    final chunks = ids.slices(10);

    if (chunks.length == 1) {
      return usersCollection
          .where(FieldPath.documentId, whereIn: chunks.first)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) {
              try {
                return UserModel.fromFirestore(doc.data(), doc.id).toDomain();
              } catch (e) {
                // TODO: Logging implementieren welches kaputte User loggt.
                return null;
              }
            })
            .whereType<CustomUser>()
            .where((user) => user.deletesAt == null)
            .map((user) => Promoter.fromUser(user))
            .toList();
      });
    } else {
      final chunkStreams = chunks
          .map((chunk) => usersCollection
              .where(FieldPath.documentId, whereIn: chunk)
              .snapshots()
              .map((snapshot) => snapshot.docs))
          .toList();

      return Rx.combineLatestList(chunkStreams).map((listOfDocLists) {
        final List<Promoter> promoters = [];
        for (var docList in listOfDocLists) {
          for (var doc in docList) {
            final user = UserModel.fromFirestore(doc.data(), doc.id).toDomain();
            if (user.deletesAt == null) {
              // Filter out deactivated users
              promoters.add(Promoter.fromUser(user));
            }
          }
        }
        return promoters;
      });
    }
  }

  Stream<List<Promoter>> _observeUnregisteredPromotersById(List<String> ids) {
    final unregisteredCollection =
        firestore.collection("unregisteredPromoters");
    final chunks = ids.slices(10);

    if (chunks.length == 1) {
      return unregisteredCollection
          .where(FieldPath.documentId, whereIn: chunks.first)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) {
              try {
                return UnregisteredPromoterModel.fromFirestore(
                        doc.data(), doc.id)
                    .toDomain();
              } catch (e) {
                // TODO: Logging implementieren welches kaputte unregistrierte Promoter loggt.
                return null;
              }
            })
            .whereType<UnregisteredPromoter>()
            .map((unregisteredPromoter) =>
                Promoter.fromUnregisteredPromoter(unregisteredPromoter))
            .toList();
      });
    } else {
      final chunkStreams = chunks
          .map((chunk) => unregisteredCollection
              .where(FieldPath.documentId, whereIn: chunk)
              .snapshots()
              .map((snapshot) => snapshot.docs))
          .toList();

      return Rx.combineLatestList(chunkStreams).map((listOfDocLists) {
        final List<Promoter> promoters = [];
        for (var docList in listOfDocLists) {
          for (var doc in docList) {
            final unregisteredPromoter =
                UnregisteredPromoterModel.fromFirestore(doc.data(), doc.id)
                    .toDomain();
            promoters
                .add(Promoter.fromUnregisteredPromoter(unregisteredPromoter));
          }
        }
        return promoters;
      });
    }
  }

  Future<List<Promoter>> _fetchAndAssignLandingPagesForStream(
      List<Promoter> promoters) async {
    final allLandingPageIDs = promoters
        .expand((p) => p.landingPageIDs ?? [])
        .whereType<String>()
        .toSet()
        .toList();

    if (allLandingPageIDs.isEmpty) {
      return promoters;
    }

    final failureOrLandingPages = await getLandingPages(allLandingPageIDs);
    return failureOrLandingPages.fold(
      (failure) =>
          promoters, // Return promoters without landing pages on failure
      (landingPages) {
        final landingPageMap = {
          for (var page in landingPages) page.id.value: page
        };

        return promoters.map((p) {
          final pages = p.landingPageIDs
              ?.map((id) => landingPageMap[id])
              .whereType<LandingPage>()
              .toList();
          return p.copyWith(landingPages: pages);
        }).toList();
      },
    );
  }

  List<Promoter> _sortPromotersForStream(List<Promoter> promoters) {
    final List<Promoter> sortedPromoters = promoters;
    sortedPromoters.sort((a, b) {
      DateTime aDate = a.expiresAt ?? a.createdAt ?? DateTime(1970);
      DateTime bDate = b.expiresAt ?? b.createdAt ?? DateTime(1970);
      return bDate.compareTo(aDate);
    });
    sortedPromoters.sort((a, b) {
      bool aWarning = _showLandingPageWarningForStream(a);
      bool bWarning = _showLandingPageWarningForStream(b);
      if (aWarning == bWarning) return 0;
      return aWarning ? -1 : 1;
    });
    sortedPromoters.sort((a, b) {
      bool aActive = a.registered ?? false;
      bool bActive = b.registered ?? false;
      if (aActive == bActive) return 0;
      return aActive ? -1 : 1;
    });
    return sortedPromoters;
  }

  bool _showLandingPageWarningForStream(Promoter promoter) {
    if (promoter.landingPages == null || promoter.landingPages!.isEmpty) {
      return true;
    } else {
      return promoter.landingPages!.every((landingPage) =>
          landingPage.isActive == null || landingPage.isActive == false);
    }
  }

  @override
  Future<Either<DatabaseFailure, List<CustomUser>>> getRegisteredPromoters(
      List<String> ids) async {
    final usersCollection = firestore.collection("users");
    // The ids needs to be sliced into chunks of 10 elements because the whereIn function can only process 10 elements at once.
    final chunks = ids.slices(10);
    final List<QuerySnapshot<Map<String, dynamic>>> querySnapshots = [];
    final List<CustomUser> users = [];
    try {
      await Future.forEach(chunks, (element) async {
        final document = await usersCollection
            .orderBy("firstName", descending: true)
            .where(FieldPath.documentId, whereIn: element)
            .get();
        querySnapshots.add(document);
      });
      for (var document in querySnapshots) {
        for (var snapshot in document.docs) {
          var doc = snapshot.data();
          var model = UserModel.fromFirestore(doc, snapshot.id).toDomain();
          // do not show deactivated users
          if (model.deletesAt == null) {
            users.add(model);
          }
        }
      }
      users.sort((a, b) {
        if (a.createdAt != null && b.createdAt != null) {
          return b.createdAt!.compareTo(a.createdAt!);
        } else {
          return a.id.value.compareTo(b.id.value);
        }
      });
      return right(users);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, List<UnregisteredPromoter>>>
      getUnregisteredPromoters(List<String> ids) async {
    final unregisteredPromotersCollection =
        firestore.collection("unregisteredPromoters");
    // The ids needs to be sliced into chunks of 10 elements because the whereIn function can only process 10 elements at once.
    final chunks = ids.slices(10);
    final List<QuerySnapshot<Map<String, dynamic>>> querySnapshots = [];
    final List<UnregisteredPromoter> unregisteredPromoters = [];
    try {
      await Future.forEach(chunks, (element) async {
        final document = await unregisteredPromotersCollection
            .orderBy("expiresAt", descending: true)
            .where(FieldPath.documentId, whereIn: element)
            .get();
        querySnapshots.add(document);
      });
      for (var document in querySnapshots) {
        for (var snapshot in document.docs) {
          var doc = snapshot.data();
          var model = UnregisteredPromoterModel.fromFirestore(doc, snapshot.id)
              .toDomain();
          unregisteredPromoters.add(model);
        }
      }
      unregisteredPromoters.sort((a, b) => b.expiresAt.compareTo(a.expiresAt));
      return right(unregisteredPromoters);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, Unit>> deletePromoter(
      {required String id, required bool isRegistered}) async {
    final appCheckToken = await appCheck.getToken();
    HttpsCallable callable = firebaseFunctions.httpsCallable("deletePromoter");
    try {
      await callable.call({
        "appCheckToken": appCheckToken,
        "isRegistered": isRegistered,
        "id": id,
      });
      return right(unit);
    } on FirebaseFunctionsException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, Unit>> editPromoter(
      {required bool isRegistered,
      required List<String> landingPageIDs,
      required String promoterID}) async {
    final appCheckToken = await appCheck.getToken();
    HttpsCallable callable = firebaseFunctions.httpsCallable("editPromoter");
    try {
      await callable.call({
        "appCheckToken": appCheckToken,
        "isRegistered": isRegistered,
        "ids": landingPageIDs,
        "promoterID": promoterID
      });
      return right(unit);
    } on FirebaseFunctionsException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, List<LandingPage>>> getLandingPages(
      List<String> ids) async {
    final landingPageCollection = firestore.collection("landingPages");
    // The ids needs to be sliced into chunks of 10 elements because the whereIn function can only process 10 elements at once.
    final chunks = ids.slices(10);
    final List<QuerySnapshot<Map<String, dynamic>>> querySnapshots = [];
    final List<LandingPage> landingPages = [];

    try {
      await Future.forEach(chunks, (element) async {
        final document = await landingPageCollection
            .where(FieldPath.documentId, whereIn: element)
            .get();
        querySnapshots.add(document);
      });
      for (var document in querySnapshots) {
        for (var snapshot in document.docs) {
          try {
            var doc = snapshot.data();
            var model =
                LandingPageModel.fromFirestore(doc, snapshot.id).toDomain();
            landingPages.add(model);
          } catch (e) {
            // TODO: Logging implementieren welches kaputte Landingpages loggt.
            continue;
          }
        }
      }
      return right(landingPages);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, Promoter>> getPromoter(String id) async {
    final registeredPromotersCollection = firestore.collection("users");
    final unregisteredPromotersCollection =
        firestore.collection("unregisteredPromoters");
    try {
      final unregisteredPromoter =
          await unregisteredPromotersCollection.doc(id).get();
      final registeredPromoter =
          await registeredPromotersCollection.doc(id).get();
      if (!unregisteredPromoter.exists && !registeredPromoter.exists) {
        return left(NotFoundFailure());
      }
      if (unregisteredPromoter.exists && unregisteredPromoter.data() != null) {
        return right(Promoter.fromUnregisteredPromoter(
            UnregisteredPromoterModel.fromMap(unregisteredPromoter.data()!)
                .toDomain()));
      } else if (registeredPromoter.exists &&
          registeredPromoter.data() != null) {
        return right(Promoter.fromUser(
            UserModel.fromMap(registeredPromoter.data()!).toDomain()));
      } else {
        return left(NotFoundFailure());
      }
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }
}
