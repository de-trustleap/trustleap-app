part of 'dashboard_overview_cubit.dart';

sealed class DashboardOverviewState {}

final class DashboardOverviewInitial extends DashboardOverviewState
    with EquatableMixin {
  @override
  List<Object> get props => [];
}

class DashboardOverviewGetUserLoadingState extends DashboardOverviewState
    with EquatableMixin {
  @override
  List<Object> get props => [];
}

class DashboardOverviewGetUserFailureState extends DashboardOverviewState
    with EquatableMixin {
  final DatabaseFailure failure;
  DashboardOverviewGetUserFailureState({
    required this.failure,
  });
  @override
  List<Object> get props => [failure];
}

class DashboardOverviewGetUserSuccessState extends DashboardOverviewState
    with EquatableMixin {
  final CustomUser user;
  DashboardOverviewGetUserSuccessState({
    required this.user,
  });
  @override
  List<Object> get props => [user];
}
