import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/last_viewed.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/domain/repositories/recommendation_repository.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';

part 'recommendation_manager_tile_state.dart';

class RecommendationManagerTileCubit
    extends Cubit<RecommendationManagerTileState> {
  final RecommendationRepository recommendationRepo;
  final UserRepository userRepo;
  CustomUser? _currentUser;
  List<String> _globalFavoriteRecommendationIDs = [];

  RecommendationManagerTileCubit(this.recommendationRepo, this.userRepo)
      : super(RecommendationManagerTileInitial());

  void getUser() async {
    final userResult = await userRepo.getUser();
    userResult.fold(
        (failure) => emit(
            RecommendationManagerTileGetUserFailureState(failure: failure)),
        (user) {
      _currentUser = user;
      _globalFavoriteRecommendationIDs =
          List<String>.from(user.favoriteRecommendationIDs ?? []);
      emit(RecommendationManagerTileGetUserSuccessState(user: user));
    });
  }

  void initializeFavorites(List<String>? favoriteRecommendationIDs) {
    _globalFavoriteRecommendationIDs =
        List<String>.from(favoriteRecommendationIDs ?? []);
  }

  List<String> get currentFavoriteRecommendationIDs =>
      _globalFavoriteRecommendationIDs;

  CustomUser? get currentUser => _currentUser;

  void setAppointmentState(UserRecommendation recommendation) async {
    emit(RecommendationSetStatusLoadingState(recommendation: recommendation));
    if (recommendation.recommendation == null ||
        recommendation.recommendation?.statusLevel !=
            StatusLevel.contactFormSent ||
        recommendation.recommendation?.statusTimestamps == null) {
      return;
    }
    final failureOrSuccess =
        await recommendationRepo.setAppointmentState(recommendation);
    failureOrSuccess.fold(
        (failure) => emit(RecommendationSetStatusFailureState(
            failure: failure, recommendation: recommendation)),
        (recommendation) => emit(RecommendationSetStatusSuccessState(
            recommendation: recommendation)));
  }

  void setFinished(UserRecommendation recommendation, bool success) async {
    emit(RecommendationSetStatusLoadingState(recommendation: recommendation));
    if (recommendation.recommendation == null ||
        recommendation.recommendation?.statusLevel != StatusLevel.appointment ||
        recommendation.recommendation?.statusTimestamps == null) {
      return;
    }
    final failureOrSuccess =
        await recommendationRepo.finishRecommendation(recommendation, success);
    failureOrSuccess.fold(
        (failure) => emit(RecommendationSetStatusFailureState(
            failure: failure, recommendation: recommendation)),
        (recommendation) => emit(RecommendationSetFinishedSuccessState(
            recommendation: recommendation)));
  }

  void setFavorite(
      UserRecommendation recommendation, String currentUserID) async {
    if (_currentUser == null) {
      final userResult = await userRepo.getUser();
      userResult.fold((failure) {
        emit(RecommendationSetStatusFailureState(
            failure: failure, recommendation: recommendation));
        return;
      }, (user) => _currentUser = user);
    }

    if (_currentUser == null) {
      emit(RecommendationSetStatusFailureState(
          failure: NotFoundFailure(), recommendation: recommendation));
      return;
    }

    final failureOrSuccess =
        await recommendationRepo.setFavorite(recommendation, currentUserID);
    failureOrSuccess.fold(
        (failure) => emit(RecommendationSetStatusFailureState(
            failure: failure,
            recommendation: recommendation)), (recommendation) {
      final recommendationId = recommendation.id.value;

      if (_globalFavoriteRecommendationIDs.contains(recommendationId)) {
        _globalFavoriteRecommendationIDs.remove(recommendationId);
      } else {
        _globalFavoriteRecommendationIDs.add(recommendationId);
      }

      final updatedUser = _currentUser!.copyWith(
          favoriteRecommendationIDs: _globalFavoriteRecommendationIDs);
      _currentUser = updatedUser;

      emit(RecommendationManagerTileFavoriteUpdatedState(
          user: updatedUser, recommendation: recommendation));
    });
  }

  void setPriority(UserRecommendation recommendation) async {
    if (recommendation.priority == null || _currentUser == null) {
      return;
    }
    final failureOrSuccess = await recommendationRepo.setPriority(
        recommendation, _currentUser!.id.value);
    failureOrSuccess.fold(
        (failure) => emit(RecommendationSetStatusFailureState(
            failure: failure, recommendation: recommendation)),
        (recommendation) => emit(RecommendationSetStatusSuccessState(
            recommendation: recommendation, settedPriority: true)));
  }

  void setNotes(UserRecommendation recommendation) async {
    if (recommendation.notes == null || _currentUser == null) {
      return;
    }
    final failureOrSuccess = await recommendationRepo.setNotes(
        recommendation, _currentUser!.id.value);
    failureOrSuccess.fold(
        (failure) => emit(RecommendationSetStatusFailureState(
            failure: failure, recommendation: recommendation)),
        (recommendation) => emit(RecommendationSetStatusSuccessState(
            recommendation: recommendation, settedNotes: true)));
  }

  void markAsViewed(String recommendationID) async {
    if (_currentUser == null) {
      final userResult = await userRepo.getUser();
      userResult.fold((failure) => null, (user) => _currentUser = user);
    }

    if (_currentUser == null) {
      return;
    }

    final lastViewed = LastViewed(
      userID: _currentUser!.id.value,
      viewedAt: DateTime.now(),
    );

    recommendationRepo.markAsViewed(recommendationID, lastViewed);

    emit(RecommendationManagerTileViewedState(
        recommendationID: recommendationID, lastViewed: lastViewed));
  }
}
