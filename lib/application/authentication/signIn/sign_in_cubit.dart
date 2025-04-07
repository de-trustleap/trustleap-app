import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/failures/failure.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final AuthRepository authRepo;
  SignInCubit({
    required this.authRepo,
  }) : super(SignInInitial());

  void checkForValidRegistrationCode(String? email, String? code) async {
    if (email == null || code == null) {
      emit(SignInShowValidationState());
    } else {
      emit(SignInLoadingState());
      final failureOrSuccess =
          await authRepo.isRegistrationCodeValid(email: email, code: code);
      failureOrSuccess.fold(
          (failure) => emit(SignInCheckCodeFailureState(failure: failure)),
          (isValid) {
        if (isValid) {
          emit(SignInCheckCodeSuccessState());
        } else {
          emit(SignInCheckCodeNotValidFailureState());
        }
      });
    }
  }

  void registerAndCreateUser(String? email, String? password, CustomUser user,
      bool privacyPolicyAccepted, bool termsAndConditionsAccepted) async {
    if (email == null || password == null) {
      emit(SignInShowValidationState());
    } else {
      emit(SignInLoadingState());
      final failureOrSuccess = await authRepo.registerAndCreateUser(
          email: email,
          password: password,
          user: user,
          privacyPolicyAccepted: privacyPolicyAccepted,
          termsAndConditionsAccepted: termsAndConditionsAccepted);
      failureOrSuccess.fold(
          (failure) => emit(RegisterFailureState(failure: failure)),
          (_) => emit(RegisterSuccessState()));
    }
  }

  void loginWithEmailAndPassword(String? email, String? password) async {
    if (email == null || password == null) {
      emit(SignInShowValidationState());
    } else {
      emit(SignInLoadingState());
      final failureOrSuccess = await authRepo.loginWithEmailAndPassword(
          email: email, password: password);
      failureOrSuccess.fold(
          (failure) => emit(SignInFailureState(failure: failure)),
          (creds) => emit(SignInSuccessState(creds: creds)));
    }
  }
}
