// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

class ProfileShowValidationState extends ProfileState {}

// Contact Information States
class ProfileUpdateContactInformationFailureState extends ProfileState {
  final DatabaseFailure failure;

  ProfileUpdateContactInformationFailureState({required this.failure});
}

class ProfileUpdateContactInformationLoadingState extends ProfileState {}

class ProfileUpdateContactInformationSuccessState extends ProfileState {}

// Get Current User States
class ProfileGetCurrentUserSuccessState extends ProfileState {
  final User? user;

  ProfileGetCurrentUserSuccessState({
    required this.user,
  });
}

// Reauthentication States
class ProfileReauthenticateForEmailUpdateSuccessState extends ProfileState {}

class ProfileReauthenticateForPasswordUpdateSuccessState extends ProfileState {}

//Update Email States
class ProfileEmailLoadingState extends ProfileState {}

class ProfileEmailUpdateSuccessState extends ProfileState {}

class ProfileEmailUpdateFailureState extends ProfileState {
  final AuthFailure failure;

  ProfileEmailUpdateFailureState({
    required this.failure,
  });
}

// Verify Email States
class ProfileEmailVerifySuccessState extends ProfileState {
  final bool isEmailVerified;

  ProfileEmailVerifySuccessState({
    required this.isEmailVerified,
  });
}

class ProfileResendEmailVerificationLoadingState extends ProfileState {}

class ProfileResendEmailVerificationSuccessState extends ProfileState {}

// Update Password States
class ProfilePasswordUpdateLoadingState extends ProfileState {}

class ProfilePasswordUpdateSuccessState extends ProfileState {}

class ProfilePasswordUpdateFailureState extends ProfileState {
  final AuthFailure failure;

  ProfilePasswordUpdateFailureState({
    required this.failure,
  });
}
