part of 'dashboard_recommendations_cubit.dart';

sealed class DashboardRecommendationsState {}

final class DashboardRecommendationsInitial
    extends DashboardRecommendationsState with EquatableMixin {
  @override
  List<Object> get props => [];
}

final class DashboardRecommendationsGetRecosLoadingState
    extends DashboardRecommendationsState with EquatableMixin {
  @override
  List<Object> get props => [];
}

final class DashboardRecommendationsGetRecosFailureState
    extends DashboardRecommendationsState with EquatableMixin {
  final DatabaseFailure failure;
  DashboardRecommendationsGetRecosFailureState({required this.failure});
  @override
  List<Object> get props => [failure];
}

final class DashboardRecommendationsGetRecosNotFoundFailureState
    extends DashboardRecommendationsState with EquatableMixin {
  @override
  List<Object> get props => [];
}

final class DashboardRecommendationsGetRecosSuccessState
    extends DashboardRecommendationsState with EquatableMixin {
  final List<UserRecommendation> recommendation;
  final List<PromoterRecommendations>?
      promoterRecommendations; // For company users

  DashboardRecommendationsGetRecosSuccessState({
    required this.recommendation,
    this.promoterRecommendations,
  });

  @override
  List<Object?> get props => [recommendation, promoterRecommendations];
}
