part of 'recommendation_chart_cubit.dart';

sealed class RecommendationChartState {}

final class RecommendationChartInitial extends RecommendationChartState
    with EquatableMixin {
  @override
  List<Object> get props => [];
}

final class RecommendationChartLoadingState extends RecommendationChartState
    with EquatableMixin {
  @override
  List<Object> get props => [];
}

final class RecommendationChartFailureState extends RecommendationChartState
    with EquatableMixin {
  final DatabaseFailure failure;
  RecommendationChartFailureState({required this.failure});
  @override
  List<Object> get props => [failure];
}

final class RecommendationChartNotFoundState extends RecommendationChartState
    with EquatableMixin {
  @override
  List<Object> get props => [];
}

final class RecommendationChartSuccessState extends RecommendationChartState
    with EquatableMixin {
  final List<UserRecommendation> recommendation;
  final List<PromoterRecommendations>? promoterRecommendations;
  final List<LandingPage>? allLandingPages;
  final List<LandingPage>? filteredLandingPages;

  RecommendationChartSuccessState({
    required this.recommendation,
    this.promoterRecommendations,
    this.allLandingPages,
    this.filteredLandingPages,
  });

  @override
  List<Object?> get props =>
      [recommendation, promoterRecommendations, allLandingPages, filteredLandingPages];

  RecommendationChartSuccessState copyWith({
    List<UserRecommendation>? recommendation,
    List<PromoterRecommendations>? promoterRecommendations,
    List<LandingPage>? allLandingPages,
    List<LandingPage>? filteredLandingPages,
  }) {
    return RecommendationChartSuccessState(
      recommendation: recommendation ?? this.recommendation,
      promoterRecommendations:
          promoterRecommendations ?? this.promoterRecommendations,
      allLandingPages: allLandingPages ?? this.allLandingPages,
      filteredLandingPages: filteredLandingPages ?? this.filteredLandingPages,
    );
  }
}
