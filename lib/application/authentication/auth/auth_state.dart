// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

sealed class AuthState {}

class AuthStateAuthenticated extends AuthState {}

class AuthStateUnAuthenticated extends AuthState {}

class AuthShowValidationState extends AuthState {}

class AuthPasswordResetSuccessState extends AuthState {}

class AuthPasswordResetLoadingState extends AuthState {}

class AuthPasswordResetFailureState extends AuthState {
  final AuthFailure failure;

  AuthPasswordResetFailureState({
    required this.failure,
  });
}
