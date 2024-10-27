part of 'landingpage_observer_cubit.dart';

sealed class LandingPageObserverState extends Equatable {
  const LandingPageObserverState();

  @override
  List<Object> get props => [];
}

final class LandingPageObserverInitial extends LandingPageObserverState {}

final class LandingPageObserverLoading extends LandingPageObserverState {}

final class LandingPageObserverFailure extends LandingPageObserverState {
  final DatabaseFailure failure;

  const LandingPageObserverFailure({
    required this.failure,
  });
}

final class LandingPageObserverSuccess extends LandingPageObserverState {
  final List<LandingPage> landingPages;
  final CustomUser user;

  const LandingPageObserverSuccess(
      {required this.landingPages, required this.user});
}
