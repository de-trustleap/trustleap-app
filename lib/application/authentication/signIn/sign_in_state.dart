// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'sign_in_bloc.dart';

class SignInState {
  final bool isSubmitting;
  final bool showValidationMessages;
  final Option<Either<AuthFailure, UserCredential>> authFailureOrSuccessOption;

  SignInState(
      {required this.isSubmitting,
      required this.showValidationMessages,
      required this.authFailureOrSuccessOption});

  SignInState copyWith(
      {bool? isSubmitting,
      bool? showValidationMessages,
      Option<Either<AuthFailure, UserCredential>>?
          authFailureOrSuccessOption}) {
    return SignInState(
        isSubmitting: isSubmitting ?? this.isSubmitting,
        showValidationMessages:
            showValidationMessages ?? this.showValidationMessages,
        authFailureOrSuccessOption:
            authFailureOrSuccessOption ?? this.authFailureOrSuccessOption);
  }
}
