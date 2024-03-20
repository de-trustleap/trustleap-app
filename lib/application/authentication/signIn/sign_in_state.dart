// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'sign_in_cubit.dart';

sealed class SignInState {}

final class SignInInitial extends SignInState {}

class SignInShowValidationState extends SignInState {}

class SignInLoadingState extends SignInState {}

class SignInFailureState extends SignInState {
  final AuthFailure failure;

  SignInFailureState({
    required this.failure,
  });
}

class SignInSuccessState extends SignInState {
  final UserCredential creds;

  SignInSuccessState({
    required this.creds,
  });
}

class SignInCheckCodeFailureState extends SignInState {
  final DatabaseFailure failure;

  SignInCheckCodeFailureState({
    required this.failure,
  });
}

class SignInCheckCodeNotValidFailureState extends SignInState {}

class SignInCheckCodeSuccessState extends SignInState {}

/*
class SignInState {
  final bool isSubmitting;
  final bool showValidationMessages;
  final Option<Either<AuthFailure, UserCredential>> authFailureOrSuccessOption;
  final Option<Either<DatabaseFailure, bool>> databaseFailureOrSuccessOption;

  SignInState(
      {required this.isSubmitting,
      required this.showValidationMessages,
      required this.authFailureOrSuccessOption,
      required this.databaseFailureOrSuccessOption});

  SignInState copyWith(
      {bool? isSubmitting,
      bool? showValidationMessages,
      Option<Either<AuthFailure, UserCredential>>? authFailureOrSuccessOption,
      Option<Either<DatabaseFailure, bool>>? databaseFailureOrSuccessOption}) {
    return SignInState(
        isSubmitting: isSubmitting ?? this.isSubmitting,
        showValidationMessages:
            showValidationMessages ?? this.showValidationMessages,
        authFailureOrSuccessOption:
            authFailureOrSuccessOption ?? this.authFailureOrSuccessOption,
        databaseFailureOrSuccessOption: databaseFailureOrSuccessOption ??
            this.databaseFailureOrSuccessOption);
  } 
} */
