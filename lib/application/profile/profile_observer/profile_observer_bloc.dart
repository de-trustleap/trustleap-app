import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';

part 'profile_observer_event.dart';
part 'profile_observer_state.dart';

class ProfileObserverBloc
    extends Bloc<ProfileObserverEvent, ProfileObserverState> {
  final UserRepository userRepo;
  StreamSubscription<Either<DatabaseFailure, CustomUser>>? _userStreamSub;

  ProfileObserverBloc({required this.userRepo})
      : super(ProfileObserverInitial()) {
    on<ProfileObserveUserEvent>((event, emit) async {
      emit(ProfileUserObserverLoading());
      await _userStreamSub?.cancel();
      print("ISCLOSED: $isClosed");
      if (!isClosed) {
        _userStreamSub = userRepo.observeUser().listen(
            (failureOrSuccess) {
              try {
                              add(ProfileObserveUserUpdatedEvent(
                failureOrUser: failureOrSuccess));
              } catch (e) {
                print("THE ERROR: $e");
              }
            }, onError: (error) {
          print('STREAM ERROR: $error');
        });
      }
    });

    on<ProfileObserveUserUpdatedEvent>((event, emit) {
      print("ISCLOSED2: $isClosed");
      if (!isClosed) {
        event.failureOrUser.fold(
            (failure) => emit(ProfileUserObserverFailure(failure: failure)),
            (user) => emit(ProfileUserObserverSuccess(user: user)));
      }
    });

    @override
    // ignore: unused_element
    Future<void> close() async {
      await _userStreamSub?.cancel();
      return super.close();
    }
  }
}
