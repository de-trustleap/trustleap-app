import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/auth/domain/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_observer_event.dart';
part 'auth_observer_state.dart';

class AuthObserverBloc extends Bloc<AuthObserverEvent, AuthObserverState> {
  final AuthRepository authRepo;
  StreamSubscription<User?>? _authStreamSub;

  AuthObserverBloc({
    required this.authRepo,
  }) : super(AuthObserverStateUnAuthenticated()) {
    on<AuthObserverStartedEvent>((event, emit) async {
      await _authStreamSub?.cancel();
      _authStreamSub = authRepo
          .observeAuthState()
          .listen((user) => add(AuthObserverGotResultEvent(user: user)));
    });

    on<AuthObserverGotResultEvent>((event, emit) async {
      if (event.user != null) {
        await event.user!.getIdToken(true);
      } else if (event.user == null &&
          state is AuthObserverStateUnAuthenticated) {
        emit(AuthObserverStateUnAuthenticated());
      }
    });
  }

  @override
  Future<void> close() async {
    await _authStreamSub?.cancel();
    return super.close();
  }
}
