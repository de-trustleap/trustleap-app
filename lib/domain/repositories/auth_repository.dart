import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/failures/failure.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Stream<User?> observeAuthState();
  Future<Either<Failure, Unit>> registerAndCreateUser(
      {required String email,
      required String password,
      required CustomUser user,
      required bool privacyPolicyAccepted,
      required bool termsAndConditionsAccepted});
  Future<Either<AuthFailure, UserCredential>> loginWithEmailAndPassword(
      {required String email, required String password});
  Future<Either<AuthFailure, UserCredential>> reauthenticateWithPassword(
      {required String password});
  Future<void> signOut();
  Option<CustomUser> getSignedInUser();
  User? getCurrentUser();
  Future<Either<DatabaseFailure, Unit>> resendEmailVerification();
  Future<Either<DatabaseFailure, Unit>> resetPassword({required String email});
  Future<Either<DatabaseFailure, bool>> isRegistrationCodeValid(
      {required String email, required String code});
  Future<Either<AuthFailure, Unit>> deleteAccount();
}
