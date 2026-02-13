// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page_repository.dart';
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
    // Get all landing page IDs including default page
    var landingPageIds = <String>[...(user.landingPageIDs ?? [])];
    if (user.defaultLandingPageID != null &&
        !landingPageIds.contains(user.defaultLandingPageID!)) {
      landingPageIds.add(user.defaultLandingPageID!);
    }

    // Check if we need to restart the observer (different user or different IDs)
    final currentSorted = [..._currentLandingPageIds]..sort();
    final newSorted = [...landingPageIds]..sort();

    if (_currentUserId == user.id.value &&
        _landingPagesStreamSub != null &&
        currentSorted.toString() == newSorted.toString()) {
      return;
    }

    _currentUserId = user.id.value;
    _currentLandingPageIds = landingPageIds;

    // Start new observation
    emit(LandingPageObserverLoading());
    await _landingPagesStreamSub?.cancel();

    if (landingPageIds.isNotEmpty) {
      _landingPagesStreamSub = landingPagesRepo
          .observeLandingPagesByIds(landingPageIds)
          .listen((failureOrSuccess) =>
              _landingPageObserverUpdated(failureOrSuccess, user));
    } else {
      emit(LandingPageObserverSuccess(landingPages: const [], user: user));
    }
  }

  void _landingPageObserverUpdated(
      Either<DatabaseFailure, List<LandingPage>> failureOrLandingPages,
      CustomUser user) {
    failureOrLandingPages.fold(
      (failure) {
        emit(LandingPageObserverFailure(failure: failure));
      },
      (landingPages) {
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
