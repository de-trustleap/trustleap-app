part of 'promoter_observer_cubit.dart';

sealed class PromoterObserverState extends Equatable {
  const PromoterObserverState();

  @override
  List<Object> get props => [];
}

final class PromoterObserverInitial extends PromoterObserverState {}

final class PromotersObserverLoading extends PromoterObserverState {}

final class PromotersObserverFailure extends PromoterObserverState {
  final DatabaseFailure failure;

  const PromotersObserverFailure({
    required this.failure,
  });

  @override
  List<Object> get props => [failure];
}

final class PromotersObserverSuccess extends PromoterObserverState {
  final List<Promoter> promoters;

  const PromotersObserverSuccess({
    required this.promoters,
  });

  @override
  List<Object> get props => [promoters];
}

final class PromotersObserverGetElementsSuccess extends PromoterObserverState {
  final List<Promoter> promoters;

  const PromotersObserverGetElementsSuccess({
    required this.promoters,
  });

  @override
  List<Object> get props => [promoters];
}

final class PromotersObserverSearchNotFound extends PromoterObserverState {}
