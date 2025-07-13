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

final class DashboardRecommendationsGetRecosSuccessState
    extends DashboardRecommendationsState with EquatableMixin {
  final List<UserRecommendation> recommendation;
  DashboardRecommendationsGetRecosSuccessState({required this.recommendation});
  @override
  List<Object> get props => [recommendation];
}
