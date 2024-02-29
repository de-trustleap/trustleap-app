import 'package:bloc/bloc.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepo;
  final AuthRepository authRepo;

  ProfileBloc({required this.userRepo, required this.authRepo})
      : super(ProfileInitial()) {
    on<UpdateProfileEvent>((event, emit) async {
      if (event.user == null) {
        emit(ProfileShowValidationState());
      } else {
        emit(ProfileUpdateContactInformationLoadingState());
        final failureOrSuccess = await userRepo.updateUser(user: event.user!);
        failureOrSuccess.fold(
            (failure) => emit(
                ProfileUpdateContactInformationFailureState(failure: failure)),
            (_) => emit(ProfileUpdateContactInformationSuccessState()));
      }
    });

    on<ReauthenticateWithPasswordInitiated>((event, emit) async {
      if (event.password == null) {
        emit(ProfileShowValidationState());
      } else {
        emit(ProfileEmailLoadingState());
        final failureOrSuccess = await authRepo.reauthenticateWithPassword(
            password: event.password!);
        failureOrSuccess.fold(
            (failure) => emit(ProfileEmailUpdateFailureState(failure: failure)),
            (_) => emit(ProfileReauthenticateSuccessState()));
      }
    });

    on<UpdateEmailEvent>((event, emit) async {
      emit(ProfileEmailLoadingState());
      if (event.email == null) {
        emit(ProfileShowValidationState());
      } else {
        emit(ProfileEmailLoadingState());
        final failureOrSuccess =
            await userRepo.updateEmail(email: event.email!);
        failureOrSuccess.fold(
            (failure) => emit(ProfileEmailUpdateFailureState(failure: failure)),
            (_) => emit(ProfileEmailUpdateSuccessState()));
      }
    });

    on<VerifyEmailEvent>((event, emit) async {
      final isEmailVerified = await userRepo.isEmailVerified();
      emit(ProfileEmailVerifySuccessState(isEmailVerified: isEmailVerified));
    });

    on<GetCurrentUserEvent>((event, emit) async {
      final currentUser = await authRepo.getCurrentUser();
      emit(ProfileGetCurrentUserSuccessState(user: currentUser));
    });

    on<SignoutUserEvent>((event, emit) async {
      await authRepo.signOut();
    });

    on<ResendEmailVerificationEvent>((event, emit) async {
      emit(ProfileResendEmailVerificationLoadingState());
      await authRepo.resendEmailVerification();
      emit(ProfileResendEmailVerificationSuccessState());
    });
  }
}
