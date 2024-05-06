// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/landing_page_repository.dart';

part 'landingpage_observer_state.dart';

class LandingPageCubit extends Cubit<LandingPageObserverState> {
  final LandingPageRepository landingPagesRepo;
  StreamSubscription<Either<DatabaseFailure, CustomUser>>? _usersStreamSub;

  LandingPageCubit(
    this.landingPagesRepo,
  ) : super(LandingPageObserverInitial());

  void observeAllLandingPages() async {
    emit(LandingPageObserverLoading());
    await _usersStreamSub?.cancel();
    _usersStreamSub = landingPagesRepo.observeAllLandingPages().listen(
        (failureOrSuccess) => landingPageObserverUpdated(failureOrSuccess));
  }

  void landingPageObserverUpdated(
      Either<DatabaseFailure, CustomUser> failureOrUser) async {

    emit(LandingPageObserverLoading());
    failureOrUser
        .fold((failure) => emit(LandingPageObserverFailure(failure: failure)),
            (user) async {
      final landingPagesIDs = user.landingPageIDs;
      if (landingPagesIDs != null && landingPagesIDs.isNotEmpty) {
        final failureOrSuccess = await landingPagesRepo
            .getAllLandingPages(landingPagesIDs);
        failureOrSuccess
            .fold((failure) => emit(LandingPageObserverFailure(failure: failure)),
                (landingPages) {
            emit(LandingPageObserverSuccess(landingPages: landingPages));
        });
      }
    });
  }

  @override
  Future<void> close() async {
    await _usersStreamSub?.cancel();
    return super.close();
  }
}
