part of 'promoter_cubit.dart';

sealed class PromoterState extends Equatable {
  const PromoterState();

  @override
  List<Object> get props => [];
}

final class PromoterInitial extends PromoterState {}

final class PromoterShowValidationState extends PromoterState {}

final class PromoterLandingPagesMissingState extends PromoterState {}

final class PromoterCompanyMissingState extends PromoterState {}

final class PromoterRegisterLoadingState extends PromoterState {}

final class PromoterRegisterFailureState extends PromoterState {
  final DatabaseFailure failure;

  const PromoterRegisterFailureState({
    required this.failure,
  });
}

final class PromoterAlreadyExistsFailureState extends PromoterState {}

final class PromoterRegisteredSuccessState extends PromoterState {}

final class PromoterLoadingState extends PromoterState {}

final class PromoterGetCurrentUserFailureState extends PromoterState {
  final DatabaseFailure failure;

  const PromoterGetCurrentUserFailureState({
    required this.failure,
  });
}

final class PromoterGetCurrentUserSuccessState extends PromoterState {
  final CustomUser? user;

  const PromoterGetCurrentUserSuccessState({
    required this.user,
  });
}

final class PromoterGetLandingPagesFailureState extends PromoterState {
  final DatabaseFailure failure;

  const PromoterGetLandingPagesFailureState({required this.failure});
}

final class PromoterGetLandingPagesSuccessState extends PromoterState {
  final List<LandingPage> landingPages;

  const PromoterGetLandingPagesSuccessState({required this.landingPages});
}

final class PromoterNoLandingPagesState extends PromoterState {}
