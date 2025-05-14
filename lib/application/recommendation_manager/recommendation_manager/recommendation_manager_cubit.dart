import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/domain/repositories/recommendation_repository.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';

part 'recommendation_manager_state.dart';

class RecommendationManagerCubit extends Cubit<RecommendationManagerState> {
  final RecommendationRepository recommendationRepo;
  final UserRepository userRepo;
  RecommendationManagerCubit(this.recommendationRepo, this.userRepo)
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
            showPrioritySnackbar: false));
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

  void getUser() async {
    emit(RecommendationManagerLoadingState());
    final failureOrSuccess = await userRepo.getUser();
    failureOrSuccess.fold((failure) {
      if (!isClosed) {
        emit(RecommendationManagerGetUserFailureState(failure: failure));
      }
    }, (user) {
      if (!isClosed) {
        emit(RecommendationManagerGetUserSuccessState(user: user));
      }
    });
  }

  void updateReco(UserRecommendation updatedReco, bool shouldBeDeleted,
      bool settedFavorite, bool settedPriority) {
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
            showPrioritySnackbar: false));
      } else if (settedPriority) {
        emit(RecommendationGetRecosSuccessState(
            recoItems: updatedList,
            showSetAppointmentSnackBar: false,
            showFinishedSnackBar: false,
            showFavoriteSnackbar: false,
            showPrioritySnackbar: true));
      } else {
        emit(RecommendationGetRecosSuccessState(
            recoItems: updatedList,
            showSetAppointmentSnackBar: shouldBeDeleted == false,
            showFinishedSnackBar: shouldBeDeleted == true,
            showFavoriteSnackbar: false,
            showPrioritySnackbar: false));
      }
    }
  }
}
