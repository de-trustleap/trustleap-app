import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Stream<User?> observeAuthState();
  Future<Either<AuthFailure, UserCredential>> registerWithEmailAndPassword(
      {required String email, required String password});
  Future<Either<AuthFailure, UserCredential>> loginWithEmailAndPassword(
      {required String email, required String password});
  Future<Either<AuthFailure, UserCredential>> reauthenticateWithPassword(
      {required String password});
  Future<void> signOut();
  Option<CustomUser> getSignedInUser();
  User? getCurrentUser();
}
