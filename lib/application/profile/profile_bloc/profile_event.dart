// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final CustomUser? user;

  UpdateProfileEvent({required this.user});
}

class ReauthenticateWithPasswordInitiated extends ProfileEvent {
  final String? password;

  ReauthenticateWithPasswordInitiated({
    required this.password,
  });
}

class UpdateEmailEvent extends ProfileEvent {
  final String? email;

  UpdateEmailEvent({
    required this.email,
  });
}

class VerifyEmailEvent extends ProfileEvent {}

class GetCurrentUserEvent extends ProfileEvent {}

class SignoutUserEvent extends ProfileEvent {}

class ResendEmailVerificationEvent extends ProfileEvent {}
