part of 'auth_observer_bloc.dart';

sealed class AuthObserverEvent {}

class AuthObserverStartedEvent extends AuthObserverEvent {}

class AuthObserverGotResultEvent extends AuthObserverEvent {
  final User? user;

  AuthObserverGotResultEvent({
    required this.user,
  });
}
