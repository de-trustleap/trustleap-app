// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImplementation implements AuthRepository {
  final FirebaseAuth firebaseAuth;

  AuthRepositoryImplementation({
    required this.firebaseAuth,
  });

  @override
  Future<Either<AuthFailure, Unit>> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return right(unit);
    } on FirebaseAuthException catch (e) {
      final String code =
          FirebaseExceptionParser.parseFirebaseAuthExceptionMessage(
              input: e.message);
      if (code == "user-disabled") {
        return left(UserDisabledFailure());
      } else if (code == "invalid-email") {
        return left(InvalidEmailFailure());
      } else if (code == "user-not-found") {
        return left(UserNotFoundFailure());
      } else if (code == "wrong-password") {
        return left(WrongPasswordFailure());
      } else if (code == "invalid-credential") {
        return left(InvalidCredentialsFailure());
      } else {
        return left(ServerFailure());
      }
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return right(unit);
    } on FirebaseAuthException catch (e) {
      final String code =
          FirebaseExceptionParser.parseFirebaseAuthExceptionMessage(
              input: e.message);
      if (code == "email-already-in-use") {
        return left(EmailAlreadyInUseFailure());
      } else if (code == "invalid-email") {
        return left(InvalidEmailFailure());
      } else if (code == "weak-password") {
        return left(WeakPasswordFailure());
      } else {
        return left(ServerFailure());
      }
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
