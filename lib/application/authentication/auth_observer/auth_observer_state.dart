part of 'auth_observer_bloc.dart';

sealed class AuthObserverState {}

class AuthObserverStateAuthenticated extends AuthObserverState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class AuthObserverStateUnAuthenticated extends AuthObserverState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}
