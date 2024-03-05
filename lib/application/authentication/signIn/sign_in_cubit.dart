import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final AuthRepository authRepo;
  SignInCubit({
    required this.authRepo,
  }) : super(SignInState(
            isSubmitting: false,
            showValidationMessages: false,
            authFailureOrSuccessOption: none()));

  void registerWithEmailAndPassword(String? email, String? password) async {
    if (email == null || password == null) {
      emit(state.copyWith(isSubmitting: false, showValidationMessages: true));
    } else {
      emit(state.copyWith(isSubmitting: true, showValidationMessages: false));
      final failureOrSuccess = await authRepo.registerWithEmailAndPassword(
          email: email, password: password);
      emit(state.copyWith(
          isSubmitting: false,
          authFailureOrSuccessOption: optionOf(failureOrSuccess)));
    }
  }

  void loginWithEmailAndPassword(String? email, String? password) async {
    if (email == null || password == null) {
      emit(state.copyWith(isSubmitting: false, showValidationMessages: true));
    } else {
      emit(state.copyWith(isSubmitting: true, showValidationMessages: false));
      final failureOrSuccess = await authRepo.loginWithEmailAndPassword(
          email: email, password: password);
      emit(state.copyWith(
          isSubmitting: false,
          authFailureOrSuccessOption: optionOf(failureOrSuccess)));
    }
  }
}
