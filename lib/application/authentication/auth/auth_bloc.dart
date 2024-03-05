// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepo;
  StreamSubscription<User?>? _authStreamSub;

  AuthBloc({
    required this.authRepo,
  }) : super(AuthInitial()) {
    on<SignOutPressedEvent>((event, emit) async {
      await authRepo.signOut();
      //    emit(AuthStateUnAuthenticated());
    });

    on<AuthCheckRequestedEvent>((event, emit) async {
      final userOption = authRepo.getSignedInUser();
      userOption.fold(() => emit(AuthStateUnAuthenticated()), (a) {
        emit(AuthStateAuthenticated());
      });
    });

    on<AuthObserverEvent>((event, emit) async {
      await _authStreamSub?.cancel();
      _authStreamSub = authRepo
          .observeAuthState()
          .listen((user) => add(AuthObserverGotResultEvent(user: user)));
    });

    on<AuthObserverGotResultEvent>((event, emit) {
      if (event.user == null) {
        emit(AuthStateUnAuthenticated());
      }
    });
  }

  @override
  Future<void> close() async {
    await _authStreamSub?.cancel();
    return super.close();
  }
}
