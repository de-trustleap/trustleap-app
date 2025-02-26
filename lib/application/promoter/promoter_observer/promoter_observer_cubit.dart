// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/promoter_repository.dart';

part 'promoter_observer_state.dart';

class PromoterObserverCubit extends Cubit<PromoterObserverState> {
  final PromoterRepository recommendationsRepo;
  StreamSubscription<Either<DatabaseFailure, CustomUser>>? _usersStreamSub;

  PromoterObserverCubit(
    this.recommendationsRepo,
  ) : super(PromoterObserverInitial());

  void observeAllPromoters() async {
    emit(PromotersObserverLoading());
    await _usersStreamSub?.cancel();
    _usersStreamSub = recommendationsRepo.observeAllPromoters().listen(
        (failureOrSuccess) => promotersObserverUpdated(failureOrSuccess));
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

  void promotersObserverUpdated(
      Either<DatabaseFailure, CustomUser> failureOrUser) async {
    emit(PromotersObserverLoading());
    failureOrUser
        .fold((failure) => emit(PromotersObserverFailure(failure: failure)),
            (user) async {
      final registeredPromoterIDs = user.registeredPromoterIDs;
      final unregisteredPromoterIDs = user.unregisteredPromoterIDs;
      List<Promoter> promoters = [];
      if (registeredPromoterIDs != null && registeredPromoterIDs.isNotEmpty) {
        final failureOrSuccess = await recommendationsRepo
            .getRegisteredPromoters(registeredPromoterIDs);
        failureOrSuccess
            .fold((failure) => emit(PromotersObserverFailure(failure: failure)),
                (registeredPromoters) {
          for (final registeredPromoter in registeredPromoters) {
            promoters.add(Promoter.fromUser(registeredPromoter));
          }
        });
      }
      if (unregisteredPromoterIDs != null &&
          unregisteredPromoterIDs.isNotEmpty) {
        final failureOrSuccess = await recommendationsRepo
            .getUnregisteredPromoters(unregisteredPromoterIDs);
        failureOrSuccess
            .fold((failure) => emit(PromotersObserverFailure(failure: failure)),
                (unregisteredPromoters) {
          for (final unregisteredPromoter in unregisteredPromoters) {
            promoters
                .add(Promoter.fromUnregisteredPromoter(unregisteredPromoter));
          }
        });
      }
      promoters = await _fetchAndAssignLandingPages(promoters);
      emit(PromotersObserverSuccess(promoters: promoters));
    });
  }

  Future<List<Promoter>> _fetchAndAssignLandingPages(
      List<Promoter> promoters) async {
    final allLandingPageIDs = promoters
        .expand((p) => p.landingPageIDs ?? [])
        .whereType<String>()
        .toSet()
        .toList();
    if (allLandingPageIDs.isEmpty) {
      return Future.value(promoters);
    }
    final failureOrLandingPages =
        await recommendationsRepo.getLandingPages(allLandingPageIDs);
    return failureOrLandingPages.fold(
      (failure) {
        emit(PromotersObserverFailure(failure: failure));
        return Future.value(promoters);
      },
      (landingPages) {
        final landingPageMap = {
          for (var page in landingPages) page.id.value: page
        };

        final updatedPromoters = promoters.map((p) {
          final pages = p.landingPageIDs
              ?.map((id) => landingPageMap[id])
              .whereType<LandingPage>()
              .toList();
          return p.copyWith(landingPages: pages);
        }).toList();

        return Future.value(updatedPromoters);
      },
    );
  }

  void stopObserving() {
    _usersStreamSub?.cancel();
    _usersStreamSub = null;
    emit(PromoterObserverInitial());
  }

  @override
  Future<void> close() async {
    await _usersStreamSub?.cancel();
    return super.close();
  }
}
