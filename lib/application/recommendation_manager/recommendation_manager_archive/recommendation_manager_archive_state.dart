part of 'recommendation_manager_archive_cubit.dart';

sealed class RecommendationManagerArchiveState {
  const RecommendationManagerArchiveState();
}

final class RecommendationManagerArchiveInitial
    extends RecommendationManagerArchiveState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class RecommendationManagerArchiveLoadingState
    extends RecommendationManagerArchiveState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class RecommendationManagerArchiveGetUserSuccessState
    extends RecommendationManagerArchiveState with EquatableMixin {
  final CustomUser user;

  RecommendationManagerArchiveGetUserSuccessState({required this.user});

  @override
  List<Object?> get props => [user];
}

class RecommendationManagerArchiveGetUserFailureState
    extends RecommendationManagerArchiveState with EquatableMixin {
  final DatabaseFailure failure;

  RecommendationManagerArchiveGetUserFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class RecommendationManagerArchiveGetRecommendationsSuccessState
    extends RecommendationManagerArchiveState with EquatableMixin {
  final List<ArchivedRecommendationItem> recommendations;

  RecommendationManagerArchiveGetRecommendationsSuccessState(
      {required this.recommendations});

  @override
  List<Object?> get props => [recommendations];
}

class RecommendationManagerArchiveGetRecommendationsFailureState
    extends RecommendationManagerArchiveState with EquatableMixin {
  final DatabaseFailure failure;

  RecommendationManagerArchiveGetRecommendationsFailureState(
      {required this.failure});

  @override
  List<Object?> get props => [failure];
}

class RecommendationManagerArchiveNoRecosState
    extends RecommendationManagerArchiveState with EquatableMixin {
  @override
  List<Object?> get props => [];
}
