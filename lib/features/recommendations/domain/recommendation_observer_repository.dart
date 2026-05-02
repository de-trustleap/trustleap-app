import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';

abstract class RecommendationObserverRepository {
  Stream<Either<DatabaseFailure, List<UserRecommendation>>>
      observeRecommendations(List<String> userRecoIDs);

  Future<Either<DatabaseFailure, List<String>>>
      aggregateCompanyUserRecoIDs(CustomUser companyUser);
}
