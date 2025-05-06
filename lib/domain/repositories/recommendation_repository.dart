import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/archived_recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';

abstract class RecommendationRepository {
  Future<Either<DatabaseFailure, Unit>> saveRecommendation(
      RecommendationItem recommendation, String userID);
  Future<Either<DatabaseFailure, List<RecommendationItem>>> getRecommendations(
      String userID);
  Future<Either<DatabaseFailure, Unit>> deleteRecommendation(
      String recoID, String userID);
  Future<Either<DatabaseFailure, RecommendationItem>> setAppointmentState(
      RecommendationItem recommendation);
  Future<Either<DatabaseFailure, RecommendationItem>> finishRecommendation(
      RecommendationItem recommendation, bool completed);
  Future<Either<DatabaseFailure, List<ArchivedRecommendationItem>>>
      getArchivedRecommendations(String userID);
}
