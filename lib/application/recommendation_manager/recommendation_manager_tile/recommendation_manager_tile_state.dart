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
  final bool? settedNotes;
  final DateTime timestamp;

  RecommendationSetStatusSuccessState(
      {required this.recommendation,
      this.settedFavorite,
      this.settedPriority,
      this.settedNotes})
      : timestamp = DateTime.now();

  @override
  List<Object?> get props =>
      [recommendation, settedFavorite, settedPriority, settedNotes, timestamp];
}

class RecommendationSetFinishedSuccessState
    extends RecommendationManagerTileState with EquatableMixin {
  final UserRecommendation recommendation;

  RecommendationSetFinishedSuccessState({required this.recommendation});

  @override
  List<Object?> get props => [];
}



class RecommendationManagerTileFavoriteUpdatedState
    extends RecommendationManagerTileState with EquatableMixin {
  final CustomUser user;
  final UserRecommendation recommendation;
  final DateTime timestamp;

  RecommendationManagerTileFavoriteUpdatedState({
    required this.user, 
    required this.recommendation
  }) : timestamp = DateTime.now();

  @override
  List<Object?> get props => [user, recommendation, timestamp];
}

class RecommendationManagerTileViewedState
    extends RecommendationManagerTileState with EquatableMixin {
  final String recommendationID;
  final LastViewed lastViewed;

  RecommendationManagerTileViewedState({
    required this.recommendationID,
    required this.lastViewed
  });

  @override
  List<Object?> get props => [recommendationID, lastViewed];
}
