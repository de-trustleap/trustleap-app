// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class SignOutPressedEvent extends AuthEvent {}

class AuthCheckRequestedEvent extends AuthEvent {}

class AuthObserverEvent extends AuthEvent {}

class AuthObserverGotResultEvent extends AuthEvent {
  final User? user;

  AuthObserverGotResultEvent({
    required this.user,
  });
}
