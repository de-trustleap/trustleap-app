// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepo;

  AuthCubit({
    required this.authRepo,
  }) : super(AuthStateUnAuthenticated());

  void signOut() async {
    emit(AuthStateAuthenticationLoading());
    await authRepo.signOut();
    checkForAuthState();
  }

  void checkForAuthState() {
    final userOption = authRepo.getSignedInUser();
    userOption.fold(() => emit(AuthStateUnAuthenticated()), (a) {
      emit(AuthStateAuthenticated());
    });
  }

  void resetPassword(String? email) async {
    if (email == null) {
      emit(AuthShowValidationState());
    } else {
      emit(AuthPasswordResetLoadingState());
      final failureOrSuccess = await authRepo.resetPassword(email: email);
      failureOrSuccess.fold(
          (failure) => emit(AuthPasswordResetFailureState(failure: failure)),
          (_) => emit(AuthPasswordResetSuccessState()));
    }
  }
}
