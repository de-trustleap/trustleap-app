import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/archived_recommendation_item.dart';
import 'package:finanzbegleiter/domain/repositories/recommendation_repository.dart';

part 'recommendation_manager_archive_state.dart';

class RecommendationManagerArchiveCubit
    extends Cubit<RecommendationManagerArchiveState> {
  final RecommendationRepository recommendationRepo;

  RecommendationManagerArchiveCubit(this.recommendationRepo)
      : super(RecommendationManagerArchiveInitial());

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
