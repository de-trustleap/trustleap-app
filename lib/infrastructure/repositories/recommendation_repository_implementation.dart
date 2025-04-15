import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/domain/repositories/recommendation_repository.dart';
import 'package:finanzbegleiter/infrastructure/models/recommendation_item_model.dart';

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
      return left(FirebaseExceptionParser.getDatabaseException(
          code: e.code)); // TODO: TESTEN!
    }
  }
}
