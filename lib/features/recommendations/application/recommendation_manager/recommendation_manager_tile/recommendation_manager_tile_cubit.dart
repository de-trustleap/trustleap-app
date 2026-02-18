import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/last_viewed.dart';
import 'package:finanzbegleiter/features/recommendations/domain/personalized_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_repository.dart';
import 'package:finanzbegleiter/features/profile/domain/user_repository.dart';

part 'recommendation_manager_tile_state.dart';

class RecommendationManagerTileCubit
    extends Cubit<RecommendationManagerTileState> {
  final RecommendationRepository recommendationRepo;
  final UserRepository userRepo;
  CustomUser? _currentUser;
  List<String> _globalFavoriteRecommendationIDs = [];

  RecommendationManagerTileCubit(this.recommendationRepo, this.userRepo)
      : super(RecommendationManagerTileInitial());


  void initializeFavorites(List<String>? favoriteRecommendationIDs) {
    _globalFavoriteRecommendationIDs =
        List<String>.from(favoriteRecommendationIDs ?? []);
  }

  void setCurrentUser(CustomUser user) {
    _currentUser = user;
    _globalFavoriteRecommendationIDs =
        List<String>.from(user.favoriteRecommendationIDs ?? []);
  }

  List<String> get currentFavoriteRecommendationIDs =>
      _globalFavoriteRecommendationIDs;

  CustomUser? get currentUser => _currentUser;

  void setAppointmentState(UserRecommendation recommendation) async {
    emit(RecommendationSetStatusLoadingState(recommendation: recommendation));
    final reco = recommendation.recommendation;
    if (reco is! PersonalizedRecommendationItem ||
        reco.statusLevel != StatusLevel.contactFormSent ||
        reco.statusTimestamps == null) {
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
    final reco = recommendation.recommendation;
    if (reco is! PersonalizedRecommendationItem ||
        reco.statusLevel != StatusLevel.appointment ||
        reco.statusTimestamps == null) {
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

  Future<String> getUserDisplayName(String userID) async {
    final userResult = await userRepo.getUserByID(userId: userID);
    return userResult.fold(
      (failure) => "",
      (user) {
        final firstName = user.firstName ?? "";
        final lastName = user.lastName ?? "";
        return "$firstName $lastName".trim();
      },
    );
  }
}
