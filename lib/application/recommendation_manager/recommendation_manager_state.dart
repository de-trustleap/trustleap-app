part of 'recommendation_manager_cubit.dart';

sealed class RecommendationManagerState {
  const RecommendationManagerState();
}

final class RecommendationManagerInitial extends RecommendationManagerState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class RecommendationGetRecosLoadingState extends RecommendationManagerState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class RecommendationGetRecosSuccessState extends RecommendationManagerState
    with EquatableMixin {
  final List<RecommendationItem> recoItems;

  RecommendationGetRecosSuccessState({required this.recoItems});

  @override
  List<Object?> get props => [recoItems];
}

class RecommendationGetRecosFailureState extends RecommendationManagerState
    with EquatableMixin {
  final DatabaseFailure failure;

  RecommendationGetRecosFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class RecommendationGetRecosNoRecosState extends RecommendationManagerState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}
