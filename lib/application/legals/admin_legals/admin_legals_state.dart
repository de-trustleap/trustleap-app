part of 'admin_legals_cubit.dart';

sealed class AdminLegalsState {}

final class AdminLegalsInitial extends AdminLegalsState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class AdminGetLegalsLoadingState extends AdminLegalsState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class AdminGetLegalsFailureState extends AdminLegalsState
    with EquatableMixin {
  final DatabaseFailure failure;
  AdminGetLegalsFailureState({required this.failure});
  @override
  List<Object?> get props => [failure];
}

final class AdminGetLegalsSuccessState extends AdminLegalsState
    with EquatableMixin {
  final Legals legals;
  AdminGetLegalsSuccessState({required this.legals});
  @override
  List<Object?> get props => [legals];
}

final class AdminLegalsShowValidationState extends AdminLegalsState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class AdminSaveLegalsLoadingState extends AdminLegalsState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class AdminSaveLegalsFailureState extends AdminLegalsState
    with EquatableMixin {
  final DatabaseFailure failure;
  AdminSaveLegalsFailureState({required this.failure});
  @override
  List<Object?> get props => [failure];
}

final class AdminSaveLegalsSuccessState extends AdminLegalsState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}
