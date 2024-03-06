import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';

abstract class UserRepository {
  Stream<Either<DatabaseFailure, CustomUser>> observeUser();
  Future<Either<DatabaseFailure, Unit>> createUser({required CustomUser user});
  Future<Either<DatabaseFailure, Unit>> updateUser({required CustomUser user});
  Future<Either<AuthFailure, void>> updateEmail({required String email});
  Future<bool> isEmailVerified();
  Future<Either<AuthFailure, void>> updatePassword({required String password});
}
