// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepo;

  AuthBloc({
    required this.authRepo,
  }) : super(AuthInitial()) {
    on<SignOutPressedEvent>((event, emit) async {
      await authRepo.signOut();
      emit(AuthStateUnAuthenticated());
    });

    on<AuthCheckRequestedEvent>((event, emit) async {
      final userOption = authRepo.getSignedInUser();
      userOption.fold(() => emit(AuthStateUnAuthenticated()),
          (a) => emit(AuthStateAuthenticated()));
    });
  }
}
