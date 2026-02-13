import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_repository.dart';

part 'recommendations_alert_state.dart';

class RecommendationsAlertCubit extends Cubit<RecommendationsAlertState> {
  final RecommendationRepository recommendationRepo;
  RecommendationsAlertCubit(this.recommendationRepo)
      : super(RecommendationsAlertInitial());

  void saveRecommendation(
      RecommendationItem recommendation, String userID) async {
    emit(RecommendationSaveLoadingState(recommendation: recommendation));
    final failureOrSuccess =
        await recommendationRepo.saveRecommendation(recommendation, userID);
    failureOrSuccess.fold(
        (failure) => emit(RecommendationSaveFailureState(
            failure: failure, recommendation: recommendation)),
        (_) => emit(
            RecommendationSaveSuccessState(recommendation: recommendation)));
  }
}
