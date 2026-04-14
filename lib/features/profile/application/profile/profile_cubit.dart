import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/features/auth/domain/auth_repository.dart';
import 'package:finanzbegleiter/features/profile/domain/user_repository.dart';
import 'package:flutter/material.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserRepository userRepo;
  final AuthRepository authRepo;
  Timer? _emailVerificationPollingTimer;

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
          (failure) =>
              emit(ProfileEmailUpdateAuthFailureState(failure: failure)),
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
    // delay here is needed to trigger reload of the profile email section
    await Future.delayed(const Duration(milliseconds: 500));
    if (isEmailVerified) {
      _emailVerificationPollingTimer?.cancel();
      _emailVerificationPollingTimer = null;
    }
    emit(ProfileEmailVerifySuccessState(isEmailVerified: isEmailVerified));
  }

  void startEmailVerificationPolling() {
    if (_emailVerificationPollingTimer != null) return;
    verifyEmail();
    _emailVerificationPollingTimer =
        Timer.periodic(const Duration(seconds: 3), (_) => verifyEmail());
  }

  void stopEmailVerificationPolling() {
    _emailVerificationPollingTimer?.cancel();
    _emailVerificationPollingTimer = null;
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
    final failureOrSuccess = await authRepo.resendEmailVerification();
    failureOrSuccess.fold(
        (failure) =>
            emit(ProfileResendEmailVerificationFailureState(failure: failure)),
        (_) => emit(ProfileResendEmailVerificationSuccessState()));
  }

  void deleteAccount() async {
    emit(ProfileAccountDeletionLoadingState());
    final failureOrSuccess = await authRepo.deleteAccount();
    failureOrSuccess.fold(
        (failure) => emit(ProfileAccountDeletionFailureState(failure: failure)),
        (_) => emit(ProfileAccountDeletionSuccessState()));
  }

  @override
  Future<void> close() {
    _emailVerificationPollingTimer?.cancel();
    return super.close();
  }
}
