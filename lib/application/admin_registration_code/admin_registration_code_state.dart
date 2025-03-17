part of 'admin_registration_code_cubit.dart';

sealed class AdminRegistrationCodeState {}

final class AdminRegistrationCodeInitial extends AdminRegistrationCodeState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class AdminRegistrationCodeSendSuccessfulShowValidationState
    extends AdminRegistrationCodeState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class AdminRegistrationCodeSendSuccessful
    extends AdminRegistrationCodeState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class AdminRegistrationCodeSendLoading extends AdminRegistrationCodeState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class AdminRegistrationCodeSendFailure extends AdminRegistrationCodeState
    with EquatableMixin {
  final DatabaseFailure failure;

  AdminRegistrationCodeSendFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
