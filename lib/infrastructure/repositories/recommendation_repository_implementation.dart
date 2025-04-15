import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/recommendation_repository.dart';
import 'package:finanzbegleiter/infrastructure/models/recommendation_item_model.dart';
import 'package:finanzbegleiter/infrastructure/models/user_model.dart';

class RecommendationRepositoryImplementation
    implements RecommendationRepository {
  final FirebaseFirestore firestore;

  RecommendationRepositoryImplementation({required this.firestore});

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
      recoItems.sort((a, b) {
        return b.createdAt.compareTo(a.createdAt);
      });
      return right(recoItems);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }
}
