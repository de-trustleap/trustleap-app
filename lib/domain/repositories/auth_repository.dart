import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword(
      {required String email, required String password});
  Future<Either<AuthFailure, Unit>> loginWithEmailAndPassword(
      {required String email, required String password});
  Future<void> signOut();
  Option<CustomUser> getSignedInUser();
}
