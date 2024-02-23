part of 'profile_observer_bloc.dart';

@immutable
sealed class ProfileObserverState {}

final class ProfileObserverInitial extends ProfileObserverState {}

final class ProfileObserverLoading extends ProfileObserverState {}

final class ProfileObserverFailure extends ProfileObserverState {
  final DatabaseFailure failure;

  ProfileObserverFailure({required this.failure});
}

final class ProfileObserverSuccess extends ProfileObserverState {
  final CustomUser user;

  ProfileObserverSuccess({required this.user});
}
