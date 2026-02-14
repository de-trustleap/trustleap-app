import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/recommendations/domain/archived_recommendation_item.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/last_viewed.dart';
import 'package:finanzbegleiter/features/recommendations/domain/promoter_recommendations.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';

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
  Future<Either<DatabaseFailure, UserRecommendation>> setFavorite(
      UserRecommendation recommendation, String userID);
  Future<Either<DatabaseFailure, UserRecommendation>> setPriority(
      UserRecommendation recommendation, String currentUserID);
  Future<Either<DatabaseFailure, UserRecommendation>> setNotes(
      UserRecommendation recommendation, String currentUserID);
  void markAsViewed(String recommendationID, LastViewed lastViewed);
  Future<Either<DatabaseFailure, List<PromoterRecommendations>>> getRecommendationsCompany(
      String userID);
  Future<Either<DatabaseFailure, List<PromoterRecommendations>>> getRecommendationsCompanyWithArchived(
      String userID);
  Future<Either<DatabaseFailure, List<UserRecommendation>>> getRecommendationsWithArchived(
      String userID);
}
