part of 'recommendation_manager_cubit.dart';

sealed class RecommendationManagerState extends Equatable {
  const RecommendationManagerState();

  @override
  List<Object> get props => [];
}

final class RecommendationManagerInitial extends RecommendationManagerState {}
