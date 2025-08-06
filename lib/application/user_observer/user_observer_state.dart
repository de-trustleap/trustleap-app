part of 'user_observer_cubit.dart';

sealed class UserObserverState {}

final class UserObserverInitial extends UserObserverState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class UserObserverLoading extends UserObserverState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class UserObserverFailure extends UserObserverState with EquatableMixin {
  final DatabaseFailure failure;

  UserObserverFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class UserObserverSuccess extends UserObserverState with EquatableMixin {
  final CustomUser user;

  UserObserverSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}
