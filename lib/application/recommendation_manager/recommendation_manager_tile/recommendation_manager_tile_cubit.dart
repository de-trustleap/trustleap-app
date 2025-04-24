import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/domain/repositories/recommendation_repository.dart';

part 'recommendation_manager_tile_state.dart';

class RecommendationManagerTileCubit
    extends Cubit<RecommendationManagerTileState> {
  final RecommendationRepository recommendationRepo;
  RecommendationManagerTileCubit(this.recommendationRepo)
      : super(RecommendationManagerTileInitial());

  void setAppointmentState(RecommendationItem recommendation) async {
    emit(RecommendationSetStatusLoadingState(recommendation: recommendation));
    if (recommendation.statusLevel != 2 ||
        recommendation.statusTimestamps == null) {
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

  void setCompleted(RecommendationItem recommendation, bool success) {}
}
