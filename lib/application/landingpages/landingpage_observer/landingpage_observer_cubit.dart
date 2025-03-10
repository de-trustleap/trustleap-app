// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/landing_page_repository.dart';
import 'package:flutter/material.dart';

part 'landingpage_observer_state.dart';

class LandingPageObserverCubit extends Cubit<LandingPageObserverState> {
  final LandingPageRepository landingPagesRepo;
  StreamSubscription<Either<DatabaseFailure, CustomUser>>? _usersStreamSub;

  LandingPageObserverCubit(
    this.landingPagesRepo,
  ) : super(LandingPageObserverInitial());

  void observeAllLandingPages() async {
    emit(LandingPageObserverLoading());
    await _usersStreamSub?.cancel();
    _usersStreamSub = null;
    _usersStreamSub = landingPagesRepo.observeAllLandingPages().listen(
        (failureOrSuccess) => landingPageObserverUpdated(failureOrSuccess));
  }

  void landingPageObserverUpdated(
      Either<DatabaseFailure, CustomUser> failureOrUser) async {
    emit(LandingPageObserverLoading());
    failureOrUser
        .fold((failure) => emit(LandingPageObserverFailure(failure: failure)),
            (user) async {
      var landingPagesIDs = user.landingPageIDs;
      if (user.defaultLandingPageID != null) {
        landingPagesIDs?.add(user.defaultLandingPageID!);
      }
      if (landingPagesIDs != null && landingPagesIDs.isNotEmpty) {
        final failureOrSuccess =
            await landingPagesRepo.getAllLandingPages(landingPagesIDs);
        failureOrSuccess.fold((failure) {
          emit(LandingPageObserverFailure(failure: failure));
        }, (landingPages) {
          PaintingBinding.instance.imageCache.clear();
          emit(LandingPageObserverSuccess(
              landingPages: landingPages, user: user));
        });
      } else {
        emit(LandingPageObserverSuccess(landingPages: const [], user: user));
      }
    });
  }

  void stopObserving() {
    _usersStreamSub?.cancel();
    _usersStreamSub = null;
  }

  @override
  Future<void> close() async {
    await _usersStreamSub?.cancel();
    return super.close();
  }
}
