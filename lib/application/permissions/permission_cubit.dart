import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/permissions.dart';
import 'package:finanzbegleiter/domain/repositories/permission_repository.dart';

part 'permission_state.dart';

class PermissionCubit extends Cubit<PermissionState> {
  final PermissionRepository permissionRepo;
  StreamSubscription<Either<DatabaseFailure, Permissions>>? _permissionSub;
  bool permissionInitiallyLoaded = false;

  PermissionCubit({required this.permissionRepo}) : super(PermissionInitial());

  void observePermissions() async {
    emit(PermissionLoadingState());
    await _permissionSub?.cancel();
    _permissionSub =
        permissionRepo.observeAllPermissions().listen((failureOrSuccess) {
      failureOrSuccess
          .fold((failure) => emit(PermissionFailureState(failure: failure)),
              (permissions) {
        emit(PermissionSuccessState(
            permissions: permissions,
            permissionInitiallyLoaded: permissionInitiallyLoaded));
        permissionInitiallyLoaded = true;
      });
    });
  }

  @override
  Future<void> close() async {
    await _permissionSub?.cancel();
    return super.close();
  }
}
