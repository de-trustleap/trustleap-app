part of 'dashboard_landingpage_ranking_cubit.dart';

sealed class DashboardLandingpageRankingState {}

final class DashboardLandingpageRankingInitial
    extends DashboardLandingpageRankingState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class DashboardLandingPageRankingGetTop3LoadingState
    extends DashboardLandingpageRankingState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class DashboardLandingPageRankingGetTop3NoPagesState
    extends DashboardLandingpageRankingState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class DashboardLandingPageRankingGetTop3FailureState
    extends DashboardLandingpageRankingState with EquatableMixin {
  final DatabaseFailure failure;
  DashboardLandingPageRankingGetTop3FailureState({required this.failure});
  @override
  List<Object?> get props => [failure];
}

final class DashboardLandingPageRankingGetTop3SuccessState
    extends DashboardLandingpageRankingState with EquatableMixin {
  final List<DashboardRankedLandingpage> landingPages;
  DashboardLandingPageRankingGetTop3SuccessState({required this.landingPages});
  @override
  List<Object?> get props => [landingPages];
}
