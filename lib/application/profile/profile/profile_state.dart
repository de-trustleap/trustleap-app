// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class ProfileShowValidationState extends ProfileState {}

// Contact Information States
class ProfileUpdateContactInformationFailureState extends ProfileState
    with EquatableMixin {
  final DatabaseFailure failure;

  ProfileUpdateContactInformationFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class ProfileUpdateContactInformationLoadingState extends ProfileState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class ProfileUpdateContactInformationSuccessState extends ProfileState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

// Reauthentication States
class ProfileReauthenticateForEmailUpdateSuccessState extends ProfileState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class ProfileReauthenticateForPasswordUpdateSuccessState extends ProfileState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

//Update Email States
class ProfileEmailLoadingState extends ProfileState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class ProfileEmailUpdateSuccessState extends ProfileState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class ProfileEmailUpdateFailureState extends ProfileState with EquatableMixin {
  final AuthFailure failure;

  ProfileEmailUpdateFailureState({
    required this.failure,
  });

  @override
  List<Object?> get props => [failure];
}

// Verify Email States
class ProfileEmailVerifySuccessState extends ProfileState with EquatableMixin {
  final bool isEmailVerified;

  ProfileEmailVerifySuccessState({
    required this.isEmailVerified,
  });

  @override
  List<Object?> get props => [isEmailVerified];
}

class ProfileResendEmailVerificationLoadingState extends ProfileState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class ProfileResendEmailVerificationSuccessState extends ProfileState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

// Update Password States
class ProfilePasswordUpdateLoadingState extends ProfileState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class ProfilePasswordUpdateSuccessState extends ProfileState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class ProfilePasswordUpdateFailureState extends ProfileState
    with EquatableMixin {
  final AuthFailure failure;

  ProfilePasswordUpdateFailureState({
    required this.failure,
  });

  @override
  List<Object?> get props => [failure];
}

class ProfileAccountDeletionLoadingState extends ProfileState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class ProfileAccountDeletionFailureState extends ProfileState
    with EquatableMixin {
  final AuthFailure failure;

  ProfileAccountDeletionFailureState({
    required this.failure,
  });

  @override
  List<Object?> get props => [failure];
}

class ProfileReauthenticateForAccountDeletionSuccessState extends ProfileState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class ProfileAccountDeletionSuccessState extends ProfileState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}
