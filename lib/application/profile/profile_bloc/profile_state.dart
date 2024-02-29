// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

class ProfileShowValidationState extends ProfileState {}

class ProfileUpdateContactInformationFailureState extends ProfileState {
  final DatabaseFailure failure;

  ProfileUpdateContactInformationFailureState({required this.failure});
}

class ProfileUpdateContactInformationLoadingState extends ProfileState {}

class ProfileUpdateContactInformationSuccessState extends ProfileState {}

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

class ProfileResendEmailVerificationLoadingState extends ProfileState {}

class ProfileResendEmailVerificationSuccessState extends ProfileState {}
