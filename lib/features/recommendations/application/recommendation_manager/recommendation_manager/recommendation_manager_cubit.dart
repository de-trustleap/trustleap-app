import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_repository.dart';

part 'recommendation_manager_state.dart';

class RecommendationManagerCubit extends Cubit<RecommendationManagerState> {
  final RecommendationRepository recommendationRepo;
  
  RecommendationManagerCubit(this.recommendationRepo)
      : super(RecommendationManagerInitial());

  void getRecommendations(String? userID) async {
    if (userID == null) {
      emit(RecommendationGetRecosFailureState(failure: NotFoundFailure()));
      return;
    }
    emit(RecommendationManagerLoadingState());
    final failureOrSuccess =
        await recommendationRepo.getRecommendations(userID);
    failureOrSuccess.fold((failure) {
      if (failure is NotFoundFailure) {
        emit(RecommendationGetRecosNoRecosState());
      } else {
        emit(RecommendationGetRecosFailureState(failure: failure));
      }
    }, (recommendations) {
      if (recommendations.isEmpty) {
        emit(RecommendationGetRecosNoRecosState());
      } else {
        emit(RecommendationGetRecosSuccessState(
            recoItems: recommendations,
            showSetAppointmentSnackBar: false,
            showFinishedSnackBar: false,
            showFavoriteSnackbar: false,
            showPrioritySnackbar: false,
            showNotesSnackbar: false));
      }
    });
  }

  void getRecommendationsForCompany(String? userID) async {
    if (userID == null) {
      emit(RecommendationGetRecosFailureState(failure: NotFoundFailure()));
      return;
    }
    emit(RecommendationManagerLoadingState());
    final failureOrSuccess =
        await recommendationRepo.getRecommendationsCompany(userID);
    failureOrSuccess.fold((failure) {
      if (failure is NotFoundFailure) {
        emit(RecommendationGetRecosNoRecosState());
      } else {
        emit(RecommendationGetRecosFailureState(failure: failure));
      }
    }, (promoterRecommendations) {
      if (promoterRecommendations.isEmpty) {
        emit(RecommendationGetRecosNoRecosState());
      } else {
        final flattenedRecommendations = promoterRecommendations
            .expand((promoterRec) => promoterRec.recommendations)
            .toList();
        emit(RecommendationGetRecosSuccessState(
            recoItems: flattenedRecommendations,
            showSetAppointmentSnackBar: false,
            showFinishedSnackBar: false,
            showFavoriteSnackbar: false,
            showPrioritySnackbar: false,
            showNotesSnackbar: false));
      }
    });
  }

  void deleteRecommendation(
      String recoID, String userID, String userRecoID) async {
    emit(RecommendationManagerLoadingState());
    final failureOrSuccess = await recommendationRepo.deleteRecommendation(
        recoID, userID, userRecoID);
    failureOrSuccess.fold(
        (failure) =>
            emit(RecommendationDeleteRecoFailureState(failure: failure)),
        (_) => emit(RecommendationDeleteRecoSuccessState()));
  }


  void updateReco(UserRecommendation updatedReco, bool shouldBeDeleted,
      bool settedFavorite, bool settedPriority, bool settedNotes) {
    final currentState = state;
    if (currentState is RecommendationGetRecosSuccessState) {
      final updatedList = shouldBeDeleted
          ? currentState.recoItems.where((r) => r.id != updatedReco.id).toList()
          : currentState.recoItems
              .map((r) => r.id == updatedReco.id ? updatedReco : r)
              .toList();
      if (settedFavorite) {
        emit(RecommendationGetRecosSuccessState(
            recoItems: updatedList,
            showSetAppointmentSnackBar: false,
            showFinishedSnackBar: false,
            showFavoriteSnackbar: true,
            showPrioritySnackbar: false,
            showNotesSnackbar: false));
      } else if (settedPriority) {
        emit(RecommendationGetRecosSuccessState(
            recoItems: updatedList,
            showSetAppointmentSnackBar: false,
            showFinishedSnackBar: false,
            showFavoriteSnackbar: false,
            showPrioritySnackbar: true,
            showNotesSnackbar: false));
      } else if (settedNotes) {
        emit(RecommendationGetRecosSuccessState(
            recoItems: updatedList,
            showSetAppointmentSnackBar: false,
            showFinishedSnackBar: false,
            showFavoriteSnackbar: false,
            showPrioritySnackbar: false,
            showNotesSnackbar: true));
      } else {
        emit(RecommendationGetRecosSuccessState(
            recoItems: updatedList,
            showSetAppointmentSnackBar: shouldBeDeleted == false,
            showFinishedSnackBar: shouldBeDeleted == true,
            showFavoriteSnackbar: false,
            showPrioritySnackbar: false,
            showNotesSnackbar: false));
      }
    }
  }
}
