part of 'profile_observer_bloc.dart';

sealed class ProfileObserverEvent {}

final class ProfileObserveUserEvent extends ProfileObserverEvent {}

final class ProfileObserveUserUpdatedEvent extends ProfileObserverEvent {
  final Either<DatabaseFailure, CustomUser> failureOrUser;
  ProfileObserveUserUpdatedEvent({required this.failureOrUser});
}

