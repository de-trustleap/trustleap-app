import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';

part 'user_observer_state.dart';

class UserObserverCubit extends Cubit<UserObserverState> {
  final UserRepository userRepo;
  StreamSubscription<Either<DatabaseFailure, CustomUser>>? _userStreamSub;
  UserObserverCubit(this.userRepo) : super(UserObserverInitial());

  void observeUser() async {
    emit(UserObserverLoading());
    await _userStreamSub?.cancel();

    _userStreamSub = userRepo.observeUser().listen((failureOrSuccess) {
      try {
        failureOrSuccess.fold(
            (failure) => emit(UserObserverFailure(failure: failure)),
            (user) => emit(UserObserverSuccess(user: user)));
      } catch (e) {
        emit(UserObserverFailure(failure: BackendFailure()));
      }
    }, onError: (error) {
      emit(UserObserverFailure(failure: BackendFailure()));
    });
  }

  @override
  Future<void> close() async {
    await _userStreamSub?.cancel();
    return super.close();
  }
}

    // TODO: IMPLEMENT USER OBSERVER (GIBT ES SCHON IN USERREPO) (DONE)
    // TODO: OBSERVER EINBAUEN IN MAIN
    // TODO: USER OBSERVER VON PROFIL LÖSCHEN
    // TODO: PROFILE PAGE REPARIEREN
    // TODO: ANDERE GETUSER CALLS LÖSCHEN