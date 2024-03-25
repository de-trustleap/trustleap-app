part of 'recommendations_observer_cubit.dart';

sealed class RecommendationsObserverState extends Equatable {
  const RecommendationsObserverState();

  @override
  List<Object> get props => [];
}

final class RecommendationsObserverInitial
    extends RecommendationsObserverState {}

final class PromotersObserverLoading extends RecommendationsObserverState {}

final class PromotersObserverFailure extends RecommendationsObserverState {
  final DatabaseFailure failure;

  const PromotersObserverFailure({
    required this.failure,
  });
}

final class PromotersObserverSuccess extends RecommendationsObserverState {
  final List<Promoter> promoters;

  const PromotersObserverSuccess({
    required this.promoters,
  });
}
