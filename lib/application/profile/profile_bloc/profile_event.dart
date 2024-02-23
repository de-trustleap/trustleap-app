part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final CustomUser? user;

  UpdateProfileEvent({required this.user});
}
