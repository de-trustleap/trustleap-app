part of 'profile_observer_bloc.dart';

@immutable
sealed class ProfileObserverEvent {}

final class ProfileObserveAllEvent extends ProfileObserverEvent {}

final class ProfileObserveUpdatedEvent extends ProfileObserverEvent {
  final Either<DatabaseFailure, CustomUser> failureOrUser;
  ProfileObserveUpdatedEvent({required this.failureOrUser});
}
