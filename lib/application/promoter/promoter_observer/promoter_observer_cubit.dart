// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/promoter_repository.dart';

part 'promoter_observer_state.dart';

class PromoterObserverCubit extends Cubit<PromoterObserverState> {
  final PromoterRepository promoterRepo;
  StreamSubscription<Either<DatabaseFailure, List<Promoter>>>?
      _promotersStreamSub;
  String? _currentUserId;
  List<String> _currentRegisteredIds = [];
  List<String> _currentUnregisteredIds = [];

  PromoterObserverCubit(
    this.promoterRepo,
  ) : super(PromoterObserverInitial());

  void observePromotersForUser(CustomUser user) async {
    final registeredIds = user.registeredPromoterIDs ?? [];
    final unregisteredIds = user.unregisteredPromoterIDs ?? [];

    // Check if we need to restart the observer (different user or different IDs)
    if (_currentUserId == user.id.value &&
        _promotersStreamSub != null &&
        const ListEquality().equals(_currentRegisteredIds, registeredIds) &&
        const ListEquality().equals(_currentUnregisteredIds, unregisteredIds)) {
      return;
    }
    _currentUserId = user.id.value;
    _currentRegisteredIds = [...registeredIds];
    _currentUnregisteredIds = [...unregisteredIds];

    // Start new observation
    emit(PromotersObserverLoading());
    await _promotersStreamSub?.cancel();

    if (registeredIds.isNotEmpty || unregisteredIds.isNotEmpty) {
      _promotersStreamSub = promoterRepo
          .observePromotersByIds(
            registeredIds: registeredIds,
            unregisteredIds: unregisteredIds,
          )
          .listen(
              (failureOrSuccess) => _promoterObserverUpdated(failureOrSuccess));
    } else {
      emit(const PromotersObserverSuccess(promoters: []));
    }
  }

  void _promoterObserverUpdated(
      Either<DatabaseFailure, List<Promoter>> failureOrPromoters) {
    failureOrPromoters.fold(
      (failure) => emit(PromotersObserverFailure(failure: failure)),
      (promoters) => emit(PromotersObserverSuccess(promoters: promoters)),
    );
  }

  void getPromoters(List<Promoter> promoters, int last) {
    List<Promoter> visiblePromoters = [];
    visiblePromoters = promoters.skip(last).take(9).toList();
    emit(PromotersObserverLoading());
    emit(PromotersObserverGetElementsSuccess(promoters: visiblePromoters));
  }

  void searchForPromoter(List<Promoter> results, int last) {
    emit(PromotersObserverLoading());
    List<Promoter> visiblePromoters = [];
    visiblePromoters = results.skip(last).take(9).toList();
    if (last == 0 && visiblePromoters.isEmpty) {
      emit(PromotersObserverSearchNotFound());
    } else {
      emit(PromotersObserverGetElementsSuccess(promoters: visiblePromoters));
    }
  }

  List<Promoter> sortPromoters(List<Promoter> promoters) {
    final List<Promoter> sortedPromoters = promoters;
    sortedPromoters.sort((a, b) {
      DateTime aDate = a.expiresAt ?? a.createdAt ?? DateTime(1970);
      DateTime bDate = b.expiresAt ?? b.createdAt ?? DateTime(1970);
      return bDate.compareTo(aDate);
    });
    sortedPromoters.sort((a, b) {
      bool aWarning = showLandingPageWarning(a);
      bool bWarning = showLandingPageWarning(b);
      if (aWarning == bWarning) return 0;
      return aWarning ? -1 : 1;
    });
    sortedPromoters.sort((a, b) {
      bool aActive = a.registered ?? false;
      bool bActive = b.registered ?? false;
      if (aActive == bActive) return 0;
      return aActive ? -1 : 1;
    });
    return sortedPromoters;
  }

  bool showLandingPageWarning(Promoter promoter) {
    if (promoter.landingPages == null || promoter.landingPages!.isEmpty) {
      return true;
    } else {
      return promoter.landingPages!.every((landingPage) =>
          landingPage.isActive == null || landingPage.isActive == false);
    }
  }

  void stopObserving() {
    _promotersStreamSub?.cancel();
    _promotersStreamSub = null;
    _currentUserId = null;
    _currentRegisteredIds = [];
    _currentUnregisteredIds = [];
  }

  @override
  Future<void> close() async {
    await _promotersStreamSub?.cancel();
    return super.close();
  }
}
