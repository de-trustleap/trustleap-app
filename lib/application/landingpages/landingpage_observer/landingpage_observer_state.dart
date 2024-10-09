part of 'landingpage_observer_cubit.dart';

sealed class LandingPageObserverState {}

final class LandingPageObserverInitial extends LandingPageObserverState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class LandingPageObserverLoading extends LandingPageObserverState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class LandingPageObserverFailure extends LandingPageObserverState with EquatableMixin {
  final DatabaseFailure failure;

  LandingPageObserverFailure({
    required this.failure,
  });

  @override
  List<Object?> get props => [failure];
}

final class LandingPageObserverSuccess extends LandingPageObserverState with EquatableMixin {
  final List<LandingPage> landingPages;
  final CustomUser user;

  LandingPageObserverSuccess(
      {required this.landingPages, required this.user});

  @override
  List<Object?> get props => [landingPages, user];
}
