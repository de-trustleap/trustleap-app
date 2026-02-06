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
  StreamSubscription<Either<DatabaseFailure, List<LandingPage>>>?
      _landingPagesStreamSub;
  String? _currentUserId;
  List<String> _currentLandingPageIds = [];

  LandingPageObserverCubit(
    this.landingPagesRepo,
  ) : super(LandingPageObserverInitial());

  void observeLandingPagesForUser(CustomUser user) async {
    print('DEBUG LPObserver - observeLandingPagesForUser called');
    // Get all landing page IDs including default page
    var landingPageIds = <String>[...(user.landingPageIDs ?? [])];
    if (user.defaultLandingPageID != null &&
        !landingPageIds.contains(user.defaultLandingPageID!)) {
      landingPageIds.add(user.defaultLandingPageID!);
    }
    print('DEBUG LPObserver - landingPageIds: $landingPageIds');

    // Check if we need to restart the observer (different user or different IDs)
    final currentSorted = [..._currentLandingPageIds]..sort();
    final newSorted = [...landingPageIds]..sort();

    if (_currentUserId == user.id.value &&
        _landingPagesStreamSub != null &&
        currentSorted.toString() == newSorted.toString()) {
      // Same user and same IDs - stream is already observing correctly
      print('DEBUG LPObserver - Same user and IDs, returning early');
      return;
    }

    _currentUserId = user.id.value;
    _currentLandingPageIds = landingPageIds;

    // Start new observation
    print('DEBUG LPObserver - Emitting Loading state');
    emit(LandingPageObserverLoading());
    await _landingPagesStreamSub?.cancel();

    if (landingPageIds.isNotEmpty) {
      print('DEBUG LPObserver - Starting stream subscription');
      _landingPagesStreamSub = landingPagesRepo
          .observeLandingPagesByIds(landingPageIds)
          .listen((failureOrSuccess) =>
              _landingPageObserverUpdated(failureOrSuccess, user));
    } else {
      print('DEBUG LPObserver - No landing pages, emitting empty success');
      emit(LandingPageObserverSuccess(landingPages: const [], user: user));
    }
  }

  void _landingPageObserverUpdated(
      Either<DatabaseFailure, List<LandingPage>> failureOrLandingPages,
      CustomUser user) {
    print('DEBUG LPObserver - _landingPageObserverUpdated called');
    failureOrLandingPages.fold(
      (failure) {
        print('DEBUG LPObserver - Emitting Failure: $failure');
        emit(LandingPageObserverFailure(failure: failure));
      },
      (landingPages) {
        print('DEBUG LPObserver - Emitting Success with ${landingPages.length} pages');
        PaintingBinding.instance.imageCache.clear();
        emit(
            LandingPageObserverSuccess(landingPages: landingPages, user: user));
      },
    );
  }

  void stopObserving() {
    _landingPagesStreamSub?.cancel();
    _landingPagesStreamSub = null;
    _currentUserId = null;
    _currentLandingPageIds = [];
  }

  @override
  Future<void> close() async {
    await _landingPagesStreamSub?.cancel();
    return super.close();
  }
}
