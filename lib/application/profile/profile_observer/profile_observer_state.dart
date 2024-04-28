part of 'profile_observer_bloc.dart';

sealed class ProfileObserverState {}

final class ProfileObserverInitial extends ProfileObserverState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class ProfileUserObserverLoading extends ProfileObserverState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class ProfileUserObserverFailure extends ProfileObserverState
    with EquatableMixin {
  final DatabaseFailure failure;

  ProfileUserObserverFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class ProfileUserObserverSuccess extends ProfileObserverState
    with EquatableMixin {
  final CustomUser user;

  ProfileUserObserverSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}
