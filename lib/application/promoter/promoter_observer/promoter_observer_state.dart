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
}

final class PromotersObserverSuccess extends PromoterObserverState {
  final List<Promoter> promoters;

  const PromotersObserverSuccess({
    required this.promoters,
  });
}
