part of 'recommendations_cubit.dart';

sealed class RecommendationsState extends Equatable {
  const RecommendationsState();

  @override
  List<Object> get props => [];
}

final class RecommendationsInitial extends RecommendationsState {}

final class RecommendationsShowValidationState extends RecommendationsState {}

final class RecommendorRegisterLoadingState extends RecommendationsState {}

final class RecommendorRegisterFailureState extends RecommendationsState {
  final DatabaseFailure failure;

  const RecommendorRegisterFailureState({
    required this.failure,
  });
}

final class RecommendorAlreadyExistsFailureState extends RecommendationsState {}

final class RecommendorRegisteredSuccessState extends RecommendationsState {}