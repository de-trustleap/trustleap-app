// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {}

class ProfileShowValidationState extends ProfileState {}

class ProfileFailureState extends ProfileState {
  final DatabaseFailure failure;

  ProfileFailureState({required this.failure});
}

class ProfileGetCurrentUserSuccessState extends ProfileState {
  final User? user;

  ProfileGetCurrentUserSuccessState({
    required this.user,
  });
}

class ProfileReauthenticateSuccessState extends ProfileState {}

class ProfileEmailLoadingState extends ProfileState {}

class ProfileEmailUpdateSuccessState extends ProfileState {}

class ProfileEmailUpdateFailureState extends ProfileState {
  final AuthFailure failure;

  ProfileEmailUpdateFailureState({
    required this.failure,
  });
}

class ProfileEmailVerifySuccessState extends ProfileState {
  final bool isEmailVerified;

  ProfileEmailVerifySuccessState({
    required this.isEmailVerified,
  });
}
