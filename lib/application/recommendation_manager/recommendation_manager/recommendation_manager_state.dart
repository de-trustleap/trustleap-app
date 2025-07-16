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
  final List<UserRecommendation> recoItems;
  final bool showSetAppointmentSnackBar;
  final bool showFinishedSnackBar;
  final bool showFavoriteSnackbar;
  final bool showPrioritySnackbar;
  final bool showNotesSnackbar;

  RecommendationGetRecosSuccessState({
    required this.recoItems,
    required this.showSetAppointmentSnackBar,
    required this.showFinishedSnackBar,
    required this.showFavoriteSnackbar,
    required this.showPrioritySnackbar,
    required this.showNotesSnackbar,
  });

  @override
  List<Object?> get props => [
        recoItems,
        showSetAppointmentSnackBar,
        showFinishedSnackBar,
        showFavoriteSnackbar,
        showPrioritySnackbar,
        showNotesSnackbar
      ];
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
