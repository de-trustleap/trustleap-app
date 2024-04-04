part of 'profile_observer_bloc.dart';

sealed class ProfileObserverState {}

final class ProfileObserverInitial extends ProfileObserverState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class ProfileObserverLoading extends ProfileObserverState
    with EquatableMixin {
  @override
  @override
  List<Object?> get props => [];
}

final class ProfileObserverFailure extends ProfileObserverState
    with EquatableMixin {
  final DatabaseFailure failure;

  ProfileObserverFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class ProfileObserverSuccess extends ProfileObserverState
    with EquatableMixin {
  final CustomUser user;

  ProfileObserverSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}
