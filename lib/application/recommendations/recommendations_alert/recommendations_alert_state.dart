part of 'recommendations_alert_cubit.dart';

sealed class RecommendationsAlertState {
  const RecommendationsAlertState();
}

final class RecommendationsAlertInitial extends RecommendationsAlertState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class RecommendationSaveLoadingState extends RecommendationsAlertState
    with EquatableMixin {
  final RecommendationItem recommendation;

  const RecommendationSaveLoadingState({required this.recommendation});
  @override
  List<Object?> get props => [recommendation];
}

class RecommendationSaveFailureState extends RecommendationsAlertState
    with EquatableMixin {
  final DatabaseFailure failure;
  final RecommendationItem recommendation;

  const RecommendationSaveFailureState(
      {required this.failure, required this.recommendation});

  @override
  List<Object?> get props => [failure];
}

class RecommendationSaveSuccessState extends RecommendationsAlertState
    with EquatableMixin {
  final RecommendationItem recommendation;

  const RecommendationSaveSuccessState({required this.recommendation});
  @override
  List<Object?> get props => [recommendation];
}
