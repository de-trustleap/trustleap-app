// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'sign_in_cubit.dart';

class SignInState {}

final class SignInInitial extends SignInState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class SignInShowValidationState extends SignInState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class SignInLoadingState extends SignInState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class SignInFailureState extends SignInState with EquatableMixin {
  final AuthFailure failure;

  SignInFailureState({
    required this.failure,
  });

  @override
  List<Object?> get props => [failure];
}

class SignInSuccessState extends SignInState with EquatableMixin {
  final UserCredential creds;

  SignInSuccessState({
    required this.creds,
  });

  @override
  List<Object?> get props => [creds];
}

class SignInCheckCodeFailureState extends SignInState with EquatableMixin {
  final DatabaseFailure failure;

  SignInCheckCodeFailureState({
    required this.failure,
  });

  @override
  List<Object?> get props => [failure];
}

class SignInCheckCodeNotValidFailureState extends SignInState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class SignInCheckCodeSuccessState extends SignInState with EquatableMixin {
  @override
  List<Object?> get props => [];
}
