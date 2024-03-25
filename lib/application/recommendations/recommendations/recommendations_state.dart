part of 'recommendations_cubit.dart';

sealed class RecommendationsState extends Equatable {
  const RecommendationsState();

  @override
  List<Object> get props => [];
}

final class RecommendationsInitial extends RecommendationsState {}

final class RecommendationsShowValidationState extends RecommendationsState {}

final class PromoterRegisterLoadingState extends RecommendationsState {}

final class PromoterRegisterFailureState extends RecommendationsState {
  final DatabaseFailure failure;

  const PromoterRegisterFailureState({
    required this.failure,
  });
}

final class PromoterAlreadyExistsFailureState extends RecommendationsState {}

final class PromoterRegisteredSuccessState extends RecommendationsState {}

final class RecommendationsGetCurrentUserLoadingState
    extends RecommendationsState {}

final class RecommendationsGetCurrentUserSuccessState
    extends RecommendationsState {
  final User? user;

  const RecommendationsGetCurrentUserSuccessState({
    required this.user,
  });
}
