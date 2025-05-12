import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/archived_recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';

abstract class RecommendationRepository {
  Future<Either<DatabaseFailure, Unit>> saveRecommendation(
      RecommendationItem recommendation, String userID);
  Future<Either<DatabaseFailure, List<UserRecommendation>>> getRecommendations(
      String userID);
  Future<Either<DatabaseFailure, Unit>> deleteRecommendation(
      String recoID, String userID, String userRecoID);
  Future<Either<DatabaseFailure, UserRecommendation>> setAppointmentState(
      UserRecommendation recommendation);
  Future<Either<DatabaseFailure, UserRecommendation>> finishRecommendation(
      UserRecommendation recommendation, bool completed);
  Future<Either<DatabaseFailure, List<ArchivedRecommendationItem>>>
      getArchivedRecommendations(String userID);
}
