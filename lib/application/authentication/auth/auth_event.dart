part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class SignOutPressedEvent extends AuthEvent {}

class AuthCheckRequestedEvent extends AuthEvent {}
