part of 'dashboard_tutorial_cubit.dart';

sealed class DashboardTutorialState {}

final class DashboardTutorialInitial extends DashboardTutorialState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class DashboardTutorialFailure extends DashboardTutorialState
    with EquatableMixin {
  final DatabaseFailure failure;
  DashboardTutorialFailure({required this.failure});
  @override
  List<Object?> get props => [failure];
}

final class DashboardTutorialSuccess extends DashboardTutorialState
    with EquatableMixin {
  final int currentStep;
  DashboardTutorialSuccess({required this.currentStep});
  @override
  List<Object?> get props => [currentStep];
}
