import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';

abstract class UserRepository {
  Stream<Either<DatabaseFailure, CustomUser>> observeUser();
  Future<Either<DatabaseFailure, Unit>> updateUser({required CustomUser user});
  Future<Either<DatabaseFailure, Unit>> updateEmail({required String email});
  Future<bool> isEmailVerified();
  Future<Either<AuthFailure, void>> updatePassword({required String password});
  Future<Either<DatabaseFailure, CustomUser>> getUser();
  Future<Either<DatabaseFailure, CustomUser>> getParentUser(
      {required String parentID});
  Future<Either<DatabaseFailure, CustomUser>> getUserByID(
      {required String userId});
}
