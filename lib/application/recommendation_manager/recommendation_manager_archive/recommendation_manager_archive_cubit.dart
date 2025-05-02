import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/archived_recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/recommendation_repository.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';

part 'recommendation_manager_archive_state.dart';

class RecommendationManagerArchiveCubit
    extends Cubit<RecommendationManagerArchiveState> {
  final RecommendationRepository recommendationRepo;
  final UserRepository userRepo;
  RecommendationManagerArchiveCubit(this.recommendationRepo, this.userRepo)
      : super(RecommendationManagerArchiveInitial());

  void getUser() async {
    emit(RecommendationManagerArchiveLoadingState());
    final failureOrSuccess = await userRepo.getUser();
    failureOrSuccess.fold((failure) {
      if (!isClosed) {
        emit(RecommendationManagerArchiveGetUserFailureState(failure: failure));
      }
    }, (user) {
      if (!isClosed) {
        emit(RecommendationManagerArchiveGetUserSuccessState(user: user));
      }
    });
  }

  void getArchivedRecommendations(String? userID) async {
    if (userID == null) {
      emit(RecommendationManagerArchiveGetRecommendationsFailureState(
          failure: NotFoundFailure()));
      return;
    }
    emit(RecommendationManagerArchiveLoadingState());
    final failureOrSuccess =
        await recommendationRepo.getArchivedRecommendations(userID);
    failureOrSuccess.fold((failure) {
      if (failure is NotFoundFailure) {
        emit(RecommendationManagerArchiveNoRecosState());
      } else {
        emit(RecommendationManagerArchiveGetRecommendationsFailureState(
            failure: failure));
      }
    },
        (recommendations) => emit(
            RecommendationManagerArchiveGetRecommendationsSuccessState(
                recommendations: recommendations)));
  }
}
