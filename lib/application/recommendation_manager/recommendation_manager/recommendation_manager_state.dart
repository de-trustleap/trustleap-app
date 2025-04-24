part of 'recommendation_manager_cubit.dart';

sealed class RecommendationManagerState {
  const RecommendationManagerState();
}

final class RecommendationManagerInitial extends RecommendationManagerState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class RecommendationManagerLoadingState extends RecommendationManagerState
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

class RecommendationManagerGetUserSuccessState
    extends RecommendationManagerState with EquatableMixin {
  final CustomUser user;

  RecommendationManagerGetUserSuccessState({required this.user});

  @override
  List<Object?> get props => [user];
}

class RecommendationManagerGetUserFailureState
    extends RecommendationManagerState with EquatableMixin {
  final DatabaseFailure failure;

  RecommendationManagerGetUserFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class RecommendationDeleteRecoFailureState extends RecommendationManagerState
    with EquatableMixin {
  final DatabaseFailure failure;

  RecommendationDeleteRecoFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class RecommendationDeleteRecoSuccessState extends RecommendationManagerState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}
