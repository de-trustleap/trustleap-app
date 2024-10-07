part of 'recommendations_cubit.dart';

sealed class RecommendationsState {
  const RecommendationsState();
}

final class RecommendationsInitial extends RecommendationsState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class RecommendationLoadingState extends RecommendationsState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class RecommendationGetCurrentUserSuccessState extends RecommendationsState
    with EquatableMixin {
  final CustomUser user;

  const RecommendationGetCurrentUserSuccessState({
    required this.user,
  });

  @override
  List<Object?> get props => [user];
}

class RecommendationGetUserFailureState extends RecommendationsState
    with EquatableMixin {
  final DatabaseFailure failure;

  const RecommendationGetUserFailureState({
    required this.failure,
  });

  @override
  List<Object?> get props => [failure];
}

class RecommendationGetParentUserSuccessState extends RecommendationsState
    with EquatableMixin {
  final CustomUser user;

  const RecommendationGetParentUserSuccessState({
    required this.user,
  });

  @override
  List<Object?> get props => [user];
}

class RecommendationGetReasonsFailureState extends RecommendationsState
    with EquatableMixin {
  final DatabaseFailure failure;

  const RecommendationGetReasonsFailureState({
    required this.failure,
  });

  @override
  List<Object?> get props => [failure];
}

class RecommendationGetReasonsSuccessState extends RecommendationsState
    with EquatableMixin {
  final List<Map<String, Object?>>reasons;

  const RecommendationGetReasonsSuccessState({required this.reasons});

  @override
  List<Object?> get props => [reasons];
}

class RecommendationNoReasonsState extends RecommendationsState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}
