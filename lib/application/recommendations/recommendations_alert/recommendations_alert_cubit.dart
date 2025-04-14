import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/domain/repositories/recommendation_repository.dart';

part 'recommendations_alert_state.dart';

class RecommendationsAlertCubit extends Cubit<RecommendationsAlertState> {
  final RecommendationRepository recommendationRepo;
  RecommendationsAlertCubit(this.recommendationRepo)
      : super(RecommendationsAlertInitial());

  void saveRecommendation(RecommendationItem recommendation) async {
    emit(RecommendationSaveLoadingState(recommendation: recommendation));
    final failureOrSuccess =
        await recommendationRepo.saveRecommendation(recommendation);
    failureOrSuccess.fold(
        (failure) => emit(RecommendationSaveFailureState(
            failure: failure, recommendation: recommendation)),
        (_) => emit(
            RecommendationSaveSuccessState(recommendation: recommendation)));
  }
}
