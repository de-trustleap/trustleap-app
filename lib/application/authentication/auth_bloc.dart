import 'package:bloc/bloc.dart';
import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepo;
  AuthBloc({required this.authRepo})
      : super(AuthState(isSubmitting: false, showValidationMessages: false)) {
    on<RegisterWithEmailAndPasswordPressed>((event, emit) {
      if (event.email == null || event.password == null) {
        emit(state.copyWith(isSubmitting: false, showValidationMessages: true));
      } else {
        emit(state.copyWith(isSubmitting: true, showValidationMessages: false));
      }
    });

    on<LoginWithEmailAndPasswordPressed>((event, emit) {
      if (event.email == null || event.password == null) {
        emit(state.copyWith(isSubmitting: false, showValidationMessages: true));
      } else {
        emit(state.copyWith(isSubmitting: true, showValidationMessages: false));
      }
    });
  }
}
