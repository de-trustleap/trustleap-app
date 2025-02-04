import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/permissions.dart';

abstract class PermissionRepository {
  Stream<Either<DatabaseFailure, Permissions>> observeAllPermissions();
}
