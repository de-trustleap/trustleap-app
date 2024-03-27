part of 'promoter_cubit.dart';

sealed class PromoterState extends Equatable {
  const PromoterState();

  @override
  List<Object> get props => [];
}

final class PromoterInitial extends PromoterState {}

final class PromoterShowValidationState extends PromoterState {}

final class PromoterRegisterLoadingState extends PromoterState {}

final class PromoterRegisterFailureState extends PromoterState {
  final DatabaseFailure failure;

  const PromoterRegisterFailureState({
    required this.failure,
  });
}

final class PromoterAlreadyExistsFailureState extends PromoterState {}

final class PromoterRegisteredSuccessState extends PromoterState {}

final class PromoterGetCurrentUserLoadingState extends PromoterState {}

final class PromoterGetCurrentUserSuccessState extends PromoterState {
  final User? user;

  const PromoterGetCurrentUserSuccessState({
    required this.user,
  });
}
