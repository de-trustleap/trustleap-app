import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/permissions/domain/permissions.dart';

abstract class PermissionRepository {
  Stream<Either<DatabaseFailure, Permissions>> observeAllPermissions();
}
