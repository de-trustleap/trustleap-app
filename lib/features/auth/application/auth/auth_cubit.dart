// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/auth/domain/auth_repository.dart';

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

  void checkForAuthState() async {
    final user = authRepo.getCurrentUser();
    if (user != null) {
      final idTokenResult = await user.getIdTokenResult(true);
      final isAdmin = idTokenResult.claims?["admin"] == true;
      if (isAdmin) {
        emit(AuthStateAuthenticatedAsAdmin());
      } else {
        emit(AuthStateAuthenticated());
      }
    } else {
      emit(AuthStateUnAuthenticated());
    }
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
