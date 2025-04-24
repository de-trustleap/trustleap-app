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
  final RecommendationItem recommendation;

  RecommendationSetStatusLoadingState({required this.recommendation});

  @override
  List<Object?> get props => [recommendation];
}

class RecommendationSetStatusFailureState extends RecommendationManagerTileState
    with EquatableMixin {
  final DatabaseFailure failure;
  final RecommendationItem recommendation;

  RecommendationSetStatusFailureState(
      {required this.failure, required this.recommendation});

  @override
  List<Object?> get props => [failure, recommendation];
}

class RecommendationSetStatusSuccessState extends RecommendationManagerTileState
    with EquatableMixin {
  final RecommendationItem recommendation;

  RecommendationSetStatusSuccessState({required this.recommendation});

  @override
  List<Object?> get props => [recommendation];
}
