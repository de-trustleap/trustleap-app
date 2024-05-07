import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserRepository userRepo;
  final AuthRepository authRepo;

  ProfileCubit({required this.userRepo, required this.authRepo})
      : super(ProfileInitial());

  void updateProfile(CustomUser? user) async {
    if (user == null) {
      emit(ProfileShowValidationState());
    } else {
      emit(ProfileUpdateContactInformationLoadingState());
      final failureOrSuccess = await userRepo.updateUser(user: user);
      failureOrSuccess.fold(
          (failure) => emit(
              ProfileUpdateContactInformationFailureState(failure: failure)),
          (_) => emit(ProfileUpdateContactInformationSuccessState()));
    }
  }

  void reauthenticateWithPasswordForEmailUpdate(String? password) async {
    if (password == null) {
      emit(ProfileShowValidationState());
    } else {
      emit(ProfileEmailLoadingState());
      final failureOrSuccess =
          await authRepo.reauthenticateWithPassword(password: password);
      failureOrSuccess.fold(
          (failure) => emit(ProfileEmailUpdateFailureState(failure: failure)),
          (_) => emit(ProfileReauthenticateForEmailUpdateSuccessState()));
    }
  }

  void reauthenticateWithPasswordForPasswordUpdate(String? password) async {
    if (password == null) {
      emit(ProfileShowValidationState());
    } else {
      emit(ProfilePasswordUpdateLoadingState());
      final failureOrSuccess =
          await authRepo.reauthenticateWithPassword(password: password);
      failureOrSuccess.fold(
          (failure) =>
              emit(ProfilePasswordUpdateFailureState(failure: failure)),
          (_) => emit(ProfileReauthenticateForPasswordUpdateSuccessState()));
    }
  }

  void reauthenticateWithPasswordForAccountDeletion(String? password) async {
    if (password == null) {
      emit(ProfileShowValidationState());
    } else {
      emit(ProfileAccountDeletionLoadingState());
      final failureOrSuccess =
          await authRepo.reauthenticateWithPassword(password: password);
      failureOrSuccess.fold(
          (failure) =>
              emit(ProfileAccountDeletionFailureState(failure: failure)),
          (_) => emit(ProfileReauthenticateForAccountDeletionSuccessState()));
    }
  }

  void updateEmail(String? email) async {
    if (email == null) {
      emit(ProfileShowValidationState());
    } else {
      emit(ProfileEmailLoadingState());
      final failureOrSuccess = await userRepo.updateEmail(email: email);
      failureOrSuccess.fold(
          (failure) => emit(ProfileEmailUpdateFailureState(failure: failure)),
          (_) => emit(ProfileEmailUpdateSuccessState()));
    }
  }

  void verifyEmail() async {
    final isEmailVerified = await userRepo.isEmailVerified();
    emit(ProfileEmailVerifySuccessState(isEmailVerified: isEmailVerified));
  }

  void updatePassword(String? password) async {
    if (password == null) {
      emit(ProfileShowValidationState());
    } else {
      emit(ProfilePasswordUpdateLoadingState());
      final failureOrSuccess =
          await userRepo.updatePassword(password: password);
      failureOrSuccess.fold(
          (failure) =>
              emit(ProfilePasswordUpdateFailureState(failure: failure)),
          (_) => emit(ProfilePasswordUpdateSuccessState()));
    }
  }

  void resendEmailVerification() async {
    emit(ProfileResendEmailVerificationLoadingState());
    await authRepo.resendEmailVerification();
    emit(ProfileResendEmailVerificationSuccessState());
  }

  void getCurrentUser() async {
    // ignore: await_only_futures
    final currentUser = await authRepo.getCurrentUser();
    emit(ProfileGetCurrentUserSuccessState(user: currentUser));
  }

  void deleteAccount() async {
    emit(ProfileAccountDeletionLoadingState());
    final failureOrSuccess = await authRepo.deleteAccount();
    failureOrSuccess.fold(
        (failure) => emit(ProfileAccountDeletionFailureState(failure: failure)),
        (_) => emit(ProfileAccountDeletionSuccessState()));
  }
}
