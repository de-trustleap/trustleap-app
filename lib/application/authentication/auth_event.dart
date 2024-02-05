// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class RegisterWithEmailAndPasswordPressed extends AuthEvent {
  final String? email;
  final String? password;

  RegisterWithEmailAndPasswordPressed({
    required this.email,
    required this.password,
  });
}

class LoginWithEmailAndPasswordPressed extends AuthEvent {
  final String? email;
  final String? password;

  LoginWithEmailAndPasswordPressed({
    required this.email,
    required this.password,
  });
}
