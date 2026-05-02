import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_observer_repository.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';

part 'recommendation_manager_state.dart';

class RecommendationManagerCubit extends Cubit<RecommendationManagerState> {
  final RecommendationObserverRepository observerRepo;

  StreamSubscription<Either<DatabaseFailure, List<UserRecommendation>>>? _sub;
  String? _currentUserId;
  List<String> _currentObservedIDs = const <String>[];

  RecommendationManagerCubit(this.observerRepo)
      : super(RecommendationManagerInitial());

  Future<void> observeRecommendationsForUser(CustomUser user) async {
    final userID = user.id.value;
    final List<String> aggregatedIDs;

    if (user.role == Role.company) {
      final result = await observerRepo.aggregateCompanyUserRecoIDs(user);
      final ids = result.fold<List<String>?>(
        (failure) {
          emit(RecommendationGetRecosFailureState(failure: failure));
          return null;
        },
        (ids) => ids,
      );
      if (ids == null) return;
      aggregatedIDs = ids;
    } else {
      aggregatedIDs = user.recommendationIDs ?? const <String>[];
    }

    final sortedNew = [...aggregatedIDs]..sort();
    final sortedCurrent = [..._currentObservedIDs]..sort();

    if (_currentUserId == userID &&
        _sub != null &&
        sortedNew.toString() == sortedCurrent.toString()) {
      return;
    }

    final isUserChange = _currentUserId != userID;
    _currentUserId = userID;
    _currentObservedIDs = aggregatedIDs;

    final shouldShowLoading = isUserChange ||
        state is RecommendationManagerInitial ||
        state is RecommendationGetRecosFailureState;
    if (shouldShowLoading) {
      emit(RecommendationManagerLoadingState());
    }

    await _sub?.cancel();

    if (aggregatedIDs.isEmpty) {
      emit(RecommendationGetRecosNoRecosState());
      return;
    }

    _sub = observerRepo.observeRecommendations(aggregatedIDs).listen(
      (res) {
        res.fold(
          (failure) {
            if (failure is NotFoundFailure) {
              emit(RecommendationGetRecosNoRecosState());
            } else {
              emit(RecommendationGetRecosFailureState(failure: failure));
            }
          },
          (recos) {
            if (recos.isEmpty) {
              emit(RecommendationGetRecosNoRecosState());
            } else {
              emit(RecommendationGetRecosSuccessState(recoItems: recos));
            }
          },
        );
      },
      onDone: () {
        _sub = null;
        _currentObservedIDs = const <String>[];
      },
    );
  }

  void stopObserving() {
    _sub?.cancel();
    _sub = null;
    _currentUserId = null;
    _currentObservedIDs = const <String>[];
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
