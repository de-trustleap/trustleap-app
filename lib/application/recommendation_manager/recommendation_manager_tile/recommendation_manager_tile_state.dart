part of 'recommendation_manager_tile_cubit.dart';

sealed class RecommendationManagerTileState {
  const RecommendationManagerTileState();
}

final class RecommendationManagerTileInitial
    extends RecommendationManagerTileState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class RecommendationSetStatusLoadingState extends RecommendationManagerTileState
    with EquatableMixin {
  final UserRecommendation recommendation;

  RecommendationSetStatusLoadingState({required this.recommendation});

  @override
  List<Object?> get props => [recommendation];
}

class RecommendationSetStatusFailureState extends RecommendationManagerTileState
    with EquatableMixin {
  final DatabaseFailure failure;
  final UserRecommendation recommendation;

  RecommendationSetStatusFailureState(
      {required this.failure, required this.recommendation});

  @override
  List<Object?> get props => [failure, recommendation];
}

class RecommendationSetStatusSuccessState extends RecommendationManagerTileState
    with EquatableMixin {
  final UserRecommendation recommendation;
  final bool? settedFavorite;
  final bool? settedPriority;

  RecommendationSetStatusSuccessState(
      {required this.recommendation, this.settedFavorite, this.settedPriority});

  @override
  List<Object?> get props => [recommendation, settedFavorite, settedPriority];
}

class RecommendationSetFinishedSuccessState
    extends RecommendationManagerTileState with EquatableMixin {
  final UserRecommendation recommendation;

  RecommendationSetFinishedSuccessState({required this.recommendation});

  @override
  List<Object?> get props => [];
}
