// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
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
      emit(PromotersObserverSuccess(promoters: promoters));
    });
  }

  @override
  Future<void> close() async {
    await _usersStreamSub?.cancel();
    return super.close();
  }
}
