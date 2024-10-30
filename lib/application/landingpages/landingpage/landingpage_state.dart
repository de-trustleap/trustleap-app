part of 'landingpage_cubit.dart';

sealed class LandingPageState {}

final class LandingPageInitial extends LandingPageState with EquatableMixin {
  @override
  List<Object> get props => [];
}

class LandingPageShowValidationState extends LandingPageState
    with EquatableMixin {
  @override
  List<Object> get props => [];
}

class CreateLandingPageLoadingState extends LandingPageState
    with EquatableMixin {
  @override
  List<Object> get props => [];
}

class CreateLandingPageFailureState extends LandingPageState
    with EquatableMixin {
  final DatabaseFailure failure;

  CreateLandingPageFailureState({
    required this.failure,
  });

  @override
  List<Object> get props => [failure];
}

class CreatedLandingPageSuccessState extends LandingPageState
    with EquatableMixin {
  @override
  List<Object> get props => [];
}

class GetUserSuccessState extends LandingPageState with EquatableMixin {
  final CustomUser user;
  GetUserSuccessState({
    required this.user,
  });
  @override
  List<Object> get props => [user];
}

class GetUserLoadingState extends LandingPageState with EquatableMixin {
  @override
  List<Object> get props => [];
}

class GetUserFailureState extends LandingPageState with EquatableMixin {
  final DatabaseFailure failure;
  GetUserFailureState({
    required this.failure,
  });
  @override
  List<Object> get props => [failure];
}

class DeleteLandingPageLoadingState extends LandingPageState
    with EquatableMixin {
  @override
  List<Object> get props => [];
}

class DeleteLandingPageFailureState extends LandingPageState
    with EquatableMixin {
  final DatabaseFailure failure;
  DeleteLandingPageFailureState({
    required this.failure,
  });
  @override
  List<Object> get props => [failure];
}

class DeleteLandingPageSuccessState extends LandingPageState
    with EquatableMixin {
  @override
  List<Object> get props => [];
}

class EditLandingPageLoadingState extends LandingPageState with EquatableMixin {
  @override
  List<Object> get props => [];
}

class EditLandingPageFailureState extends LandingPageState with EquatableMixin {
  final DatabaseFailure failure;
  EditLandingPageFailureState({
    required this.failure,
  });
  @override
  List<Object> get props => [failure];
}

class EditLandingPageSuccessState extends LandingPageState with EquatableMixin {
  @override
  List<Object> get props => [];
}

class LandingPageImageExceedsFileSizeLimitFailureState
    extends LandingPageState {}

class LandingPageNoImageFailureState extends LandingPageState
    with EquatableMixin {
  @override
  List<Object> get props => [];
}

class DuplicateLandingPageLoadingState extends LandingPageState
    with EquatableMixin {
  @override
  List<Object> get props => [];
}

class DuplicateLandingPageFailureState extends LandingPageState
    with EquatableMixin {
  final DatabaseFailure failure;
  DuplicateLandingPageFailureState({
    required this.failure,
  });
  @override
  List<Object> get props => [failure];
}

class DuplicateLandingPageSuccessState extends LandingPageState
    with EquatableMixin {
  @override
  List<Object> get props => [];
}

class ToggleLandingPageActivityLoadingState extends LandingPageState
    with EquatableMixin {
  @override
  List<Object> get props => [];
}

class ToggleLandingPageActivityFailureState extends LandingPageState
    with EquatableMixin {
  final DatabaseFailure failure;
  ToggleLandingPageActivityFailureState({
    required this.failure,
  });
  @override
  List<Object> get props => [failure];
}

class ToggleLandingPageActivitySuccessState extends LandingPageState
    with EquatableMixin {
  final bool isActive;
  ToggleLandingPageActivitySuccessState({
    required this.isActive,
  });
  @override
  List<Object> get props => [isActive];
}
