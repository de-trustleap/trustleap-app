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
  final List<LandingPage>? allLandingPages; // All landing pages loaded once
  final List<LandingPage>? filteredLandingPages; // Filtered landing pages for selected promoter

  DashboardRecommendationsGetRecosSuccessState({
    required this.recommendation,
    this.promoterRecommendations,
    this.allLandingPages,
    this.filteredLandingPages,
  });

  @override
  List<Object?> get props => [recommendation, promoterRecommendations, allLandingPages, filteredLandingPages];

  DashboardRecommendationsGetRecosSuccessState copyWith({
    List<UserRecommendation>? recommendation,
    List<PromoterRecommendations>? promoterRecommendations,
    List<LandingPage>? allLandingPages,
    List<LandingPage>? filteredLandingPages,
  }) {
    return DashboardRecommendationsGetRecosSuccessState(
      recommendation: recommendation ?? this.recommendation,
      promoterRecommendations: promoterRecommendations ?? this.promoterRecommendations,
      allLandingPages: allLandingPages ?? this.allLandingPages,
      filteredLandingPages: filteredLandingPages ?? this.filteredLandingPages,
    );
  }
}
