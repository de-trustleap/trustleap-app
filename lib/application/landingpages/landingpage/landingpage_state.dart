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