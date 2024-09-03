part of 'landingpage_cubit.dart';

sealed class LandingPageState extends Equatable {
  const LandingPageState();

  @override
  List<Object> get props => [];
}

final class LandingPageInitial extends LandingPageState {}

final class LandingPageShowValidationState extends LandingPageState {}

final class CreateLandingPageLoadingState extends LandingPageState {}

final class CreateLandingPageFailureState extends LandingPageState {
  final DatabaseFailure failure;

  const CreateLandingPageFailureState({
    required this.failure,
  });
}

final class CreatedLandingPageSuccessState extends LandingPageState {}

final class GetUserSuccessState extends LandingPageState {
  final CustomUser user;
  const GetUserSuccessState({
    required this.user,
  });
}

final class GetUserLoadingState extends LandingPageState {}

final class GetUserFailureState extends LandingPageState {
  final DatabaseFailure failure;
  const GetUserFailureState({
    required this.failure,
  });
}

final class DeleteLandingPageLoadingState extends LandingPageState {}

final class DeleteLandingPageFailureState extends LandingPageState {
  final DatabaseFailure failure;
  const DeleteLandingPageFailureState({
    required this.failure,
  });
}

final class DeleteLandingPageSuccessState extends LandingPageState {}

final class EditLandingPageLoadingState extends LandingPageState {}

final class EditLandingPageFailureState extends LandingPageState {
  final DatabaseFailure failure;
  const EditLandingPageFailureState({
    required this.failure,
  });
}

final class EditLandingPageSuccessState extends LandingPageState {}

final class LandingPageImageExceedsFileSizeLimitFailureState
    extends LandingPageState {}

final class LandingPageNoImageFailureState extends LandingPageState {}

final class DuplicateLandingPageLoadingState extends LandingPageState {}

final class DuplicateLandingPageFailureState extends LandingPageState {
  final DatabaseFailure failure;
  const DuplicateLandingPageFailureState({
    required this.failure,
  });
}

final class DuplicateLandingPageSuccessState extends LandingPageState {}

final class TroggleLandingPageActivityLoadingState extends LandingPageState {}

final class TroggleLandingPageActivityFailureState extends LandingPageState {
  final DatabaseFailure failure;
  const TroggleLandingPageActivityFailureState({
    required this.failure,
  });
}

final class TroggleLandingPageActivitySuccessState extends LandingPageState {}
