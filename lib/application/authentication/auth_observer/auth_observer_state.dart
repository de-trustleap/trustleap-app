part of 'auth_observer_bloc.dart';

sealed class AuthObserverState {}

class AuthObserverStateAuthenticated extends AuthObserverState {}

class AuthObserverStateUnAuthenticated extends AuthObserverState {}
