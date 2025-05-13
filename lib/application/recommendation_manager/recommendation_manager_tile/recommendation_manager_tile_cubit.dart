import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/domain/repositories/recommendation_repository.dart';

part 'recommendation_manager_tile_state.dart';

class RecommendationManagerTileCubit
    extends Cubit<RecommendationManagerTileState> {
  final RecommendationRepository recommendationRepo;
  RecommendationManagerTileCubit(this.recommendationRepo)
      : super(RecommendationManagerTileInitial());

  void setAppointmentState(UserRecommendation recommendation) async {
    emit(RecommendationSetStatusLoadingState(recommendation: recommendation));
    if (recommendation.recommendation == null ||
        recommendation.recommendation?.statusLevel != 2 ||
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
        recommendation.recommendation?.statusLevel != 3 ||
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

  void setFavorite(UserRecommendation recommendation) async {
    if (recommendation.isFavorite == null) {
      return;
    }
    final failureOrSuccess =
        await recommendationRepo.setFavorite(recommendation);
    failureOrSuccess.fold(
        (failure) => emit(RecommendationSetStatusFailureState(
            failure: failure, recommendation: recommendation)),
        (recommendation) => emit(RecommendationSetStatusSuccessState(
            recommendation: recommendation, settedFavorite: true)));
  }
}
