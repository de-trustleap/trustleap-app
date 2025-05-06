import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/domain/entities/archived_recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/recommendation_repository.dart';
import 'package:finanzbegleiter/infrastructure/models/archived_recommendation_item_model.dart';
import 'package:finanzbegleiter/infrastructure/models/recommendation_item_model.dart';
import 'package:finanzbegleiter/infrastructure/models/user_model.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

class RecommendationRepositoryImplementation
    implements RecommendationRepository {
  final FirebaseFirestore firestore;
  final FirebaseFunctions firebaseFunctions;
  final FirebaseAppCheck appCheck;

  RecommendationRepositoryImplementation(
      {required this.firestore,
      required this.firebaseFunctions,
      required this.appCheck});

  @override
  Future<Either<DatabaseFailure, Unit>> saveRecommendation(
      RecommendationItem recommendation, String userID) async {
    final recoCollection = firestore.collection("recommendations");
    final userCollection = firestore.collection("users");
    final map = RecommendationItemModel.fromDomain(recommendation).toMap();
    try {
      await recoCollection.doc(recommendation.id).set(map);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
    try {
      final userDoc = await userCollection.doc(userID).get();
      final userData = userDoc.data();
      List<String> recommendationIDs = [];

      if (userData != null && userData.containsKey('recommendationIDs')) {
        final rawList = userData['recommendationIDs'];
        if (rawList is List) {
          recommendationIDs = List<String>.from(rawList);
        }
      }
      recommendationIDs.add(recommendation.id);
      await userCollection.doc(userID).set(
          {"recommendationIDs": recommendationIDs}, SetOptions(merge: true));
      return right(unit);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, List<RecommendationItem>>> getRecommendations(
      String userID) async {
    final recoCollection = firestore.collection("recommendations");
    final userCollection = firestore.collection("users");

    final CustomUser? user;
    try {
      final userDoc = await userCollection.doc(userID).get();
      if (!userDoc.exists || userDoc.data() == null) {
        return left(NotFoundFailure());
      }
      user = UserModel.fromMap(userDoc.data()!).toDomain();
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
    try {
      if (user.recommendationIDs == null) {
        return left(NotFoundFailure());
      } else if (user.recommendationIDs != null &&
          user.recommendationIDs!.isEmpty) {
        return left(NotFoundFailure());
      }
      final recoIDs = user.recommendationIDs!;
      // The ids needs to be sliced into chunks of 10 elements because the whereIn function can only process 10 elements at once.
      final chunks = recoIDs.slices(10);
      final List<QuerySnapshot<Map<String, dynamic>>> querySnapshots = [];
      final List<RecommendationItem> recoItems = [];

      await Future.forEach(chunks, (element) async {
        final document = await recoCollection
            .orderBy("name", descending: true)
            .where(FieldPath.documentId, whereIn: element)
            .get();
        querySnapshots.add(document);
      });
      for (var document in querySnapshots) {
        for (var snapshot in document.docs) {
          var doc = snapshot.data();
          var model = RecommendationItemModel.fromFirestore(doc, snapshot.id)
              .toDomain();
          recoItems.add(model);
        }
      }

      final promoterRecommendations =
          await _getRecommendationsFromPromoters(user);
      if (promoterRecommendations.isLeft()) {
        return promoterRecommendations;
      }

      final promoterRecoList = promoterRecommendations.getOrElse(() => []);
      recoItems.addAll(promoterRecoList);

      recoItems.sort((a, b) {
        return b.createdAt.compareTo(a.createdAt);
      });
      return right(recoItems);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  Future<Either<DatabaseFailure, List<RecommendationItem>>>
      _getRecommendationsFromPromoters(CustomUser user) async {
    final recoCollection = firestore.collection("recommendations");
    final userCollection = firestore.collection("users");

    final promoterIDs = user.registeredPromoterIDs;
    if (promoterIDs == null || promoterIDs.isEmpty) {
      return right([]);
    }

    // Get all Promoters
    final chunks = promoterIDs.slices(10);
    final List<QuerySnapshot<Map<String, dynamic>>> querySnapshots = [];
    final List<CustomUser> promoters = [];

    try {
      await Future.forEach(chunks, (element) async {
        final document = await userCollection
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
            promoters.add(model);
          }
        }
      }

      // Get all recommendation IDs
      final allRecoIDs = promoters
          .expand((promoter) => promoter.recommendationIDs ?? [])
          .toSet()
          .toList();

      if (allRecoIDs.isEmpty) {
        return right([]);
      }

      // Get all recommendations
      final recoChunks = allRecoIDs.slices(10);
      final List<RecommendationItem> recommendations = [];

      await Future.forEach(recoChunks, (chunk) async {
        final snapshot = await recoCollection
            .orderBy("name", descending: true)
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        for (var doc in snapshot.docs) {
          final model =
              RecommendationItemModel.fromFirestore(doc.data(), doc.id)
                  .toDomain();
          recommendations.add(model);
        }
      });

      return right(recommendations);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, Unit>> deleteRecommendation(
      String recoID, String userID) async {
    final appCheckToken = await appCheck.getToken();
    HttpsCallable callable =
        firebaseFunctions.httpsCallable("deleteRecommendation");
    try {
      await callable.call({
        "appCheckToken": appCheckToken,
        "recommendationID": recoID,
        "userID": userID
      });
      return right(unit);
    } on FirebaseFunctionsException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, RecommendationItem>> setAppointmentState(
      RecommendationItem recommendation) async {
    final recoCollection = firestore.collection("recommendations");
    final newStatusTimeStamps = recommendation.statusTimestamps;
    final actualDate = DateTime.now();
    newStatusTimeStamps?[3] = actualDate;
    final newRecommendation =
        recommendation.copyWith(statusTimestamps: newStatusTimeStamps);
    final timeStamps = newRecommendation.statusTimestamps?.map(
        (key, value) => MapEntry(key.toString(), value?.toIso8601String()));
    try {
      await recoCollection.doc(recommendation.id).set(
          {"statusLevel": 3, "statusTimestamps": timeStamps},
          SetOptions(merge: true));
      return right(recommendation.copyWith(
          statusLevel: 3, statusTimestamps: newStatusTimeStamps));
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, RecommendationItem>> finishRecommendation(
      RecommendationItem recommendation, bool completed) async {
    final appCheckToken = await appCheck.getToken();
    HttpsCallable callable =
        firebaseFunctions.httpsCallable("finishRecommendationX");
    try {
      await callable.call({
        "appCheckToken": appCheckToken,
        "recommendationID": recommendation.id,
        "userID": recommendation.userID,
        "success": completed
      });
      return right(recommendation);
    } on FirebaseFunctionsException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, List<ArchivedRecommendationItem>>>
      getArchivedRecommendations(String userID) async {
    final archivedRecoCollection =
        firestore.collection("archivedRecommendations");
    final userCollection = firestore.collection("users");
    final CustomUser? user;
    try {
      final userDoc = await userCollection.doc(userID).get();
      if (!userDoc.exists || userDoc.data() == null) {
        return left(NotFoundFailure());
      }
      user = UserModel.fromMap(userDoc.data()!).toDomain();
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
    try {
      if (user.archivedRecommendationIDs == null) {
        return left(NotFoundFailure());
      } else if (user.archivedRecommendationIDs != null &&
          user.archivedRecommendationIDs!.isEmpty) {
        return left(NotFoundFailure());
      }
      final recoIDs = user.archivedRecommendationIDs!;
      // The ids needs to be sliced into chunks of 10 elements because the whereIn function can only process 10 elements at once.
      final chunks = recoIDs.slices(10);
      final List<QuerySnapshot<Map<String, dynamic>>> querySnapshots = [];
      final List<ArchivedRecommendationItem> recoItems = [];

      await Future.forEach(chunks, (element) async {
        final document = await archivedRecoCollection
            .orderBy("name", descending: true)
            .where(FieldPath.documentId, whereIn: element)
            .get();
        querySnapshots.add(document);
      });
      for (var document in querySnapshots) {
        for (var snapshot in document.docs) {
          var doc = snapshot.data();
          var model =
              ArchivedRecommendationItemModel.fromFirestore(doc, snapshot.id)
                  .toDomain();
          recoItems.add(model);
        }
      }

      final promoterRecommendations =
          await _getArchivedRecommendationsFromPromoters(user);
      if (promoterRecommendations.isLeft()) {
        return promoterRecommendations;
      }

      final promoterRecoList = promoterRecommendations.getOrElse(() => []);
      recoItems.addAll(promoterRecoList);

      recoItems.sort((a, b) {
        return b.finishedTimeStamp.compareTo(a.finishedTimeStamp);
      });
      return right(recoItems);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  Future<Either<DatabaseFailure, List<ArchivedRecommendationItem>>>
      _getArchivedRecommendationsFromPromoters(CustomUser user) async {
    final recoCollection = firestore.collection("archivedRecommendations");
    final userCollection = firestore.collection("users");

    final promoterIDs = user.registeredPromoterIDs;
    if (promoterIDs == null || promoterIDs.isEmpty) {
      return right([]);
    }

    // Get all Promoters
    final chunks = promoterIDs.slices(10);
    final List<QuerySnapshot<Map<String, dynamic>>> querySnapshots = [];
    final List<CustomUser> promoters = [];

    try {
      await Future.forEach(chunks, (element) async {
        final document = await userCollection
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
            promoters.add(model);
          }
        }
      }

      // Get all archived recommendation IDs
      final allRecoIDs = promoters
          .expand((promoter) => promoter.archivedRecommendationIDs ?? [])
          .toSet()
          .toList();

      if (allRecoIDs.isEmpty) {
        return right([]);
      }

      // Get all archived recommendations
      final recoChunks = allRecoIDs.slices(10);
      final List<ArchivedRecommendationItem> recommendations = [];

      await Future.forEach(recoChunks, (chunk) async {
        final snapshot = await recoCollection
            .orderBy("name", descending: true)
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        for (var doc in snapshot.docs) {
          final model =
              ArchivedRecommendationItemModel.fromFirestore(doc.data(), doc.id)
                  .toDomain();
          recommendations.add(model);
        }
      });

      return right(recommendations);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }
}
