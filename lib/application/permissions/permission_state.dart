part of 'permission_cubit.dart';

sealed class PermissionState {}

final class PermissionInitial extends PermissionState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class PermissionLoadingState extends PermissionState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class PermissionFailureState extends PermissionState with EquatableMixin {
  final DatabaseFailure failure;

  PermissionFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class PermissionSuccessState extends PermissionState with EquatableMixin {
  final Permissions permissions;
  final bool permissionInitiallyLoaded;

  PermissionSuccessState(
      {required this.permissions, required this.permissionInitiallyLoaded});

  @override
  List<Object?> get props => [permissions];
}
