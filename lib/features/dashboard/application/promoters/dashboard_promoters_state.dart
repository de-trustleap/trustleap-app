part of 'dashboard_promoters_cubit.dart';

sealed class DashboardPromotersState {}

final class DashboardPromotersInitial extends DashboardPromotersState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class DashboardPromotersGetRegisteredPromotersLoadingState
    extends DashboardPromotersState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class DashboardPromotersGetRegisteredPromotersEmptyState
    extends DashboardPromotersState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class DashboardPromotersGetRegisteredPromotersFailureState
    extends DashboardPromotersState with EquatableMixin {
  final DatabaseFailure failure;

  DashboardPromotersGetRegisteredPromotersFailureState({required this.failure});
  @override
  List<Object?> get props => [failure];
}

final class DashboardPromotersGetRegisteredPromotersSuccessState
    extends DashboardPromotersState with EquatableMixin {
  final List<CustomUser> promoters;

  DashboardPromotersGetRegisteredPromotersSuccessState(
      {required this.promoters});
  @override
  List<Object?> get props => [promoters];
}
