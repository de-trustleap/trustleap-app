// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'sign_in_bloc.dart';

@immutable
sealed class SignInEvent {}

class RegisterWithEmailAndPasswordPressed extends SignInEvent {
  final String? email;
  final String? password;

  RegisterWithEmailAndPasswordPressed({
    required this.email,
    required this.password,
  });
}

class LoginWithEmailAndPasswordPressed extends SignInEvent {
  final String? email;
  final String? password;

  LoginWithEmailAndPasswordPressed({
    required this.email,
    required this.password,
  });
}
