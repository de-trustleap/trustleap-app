// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
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
      if (e.code == "user-disabled") {
        return left(UserDisabledFailure());
      } else if (e.code == "invalid-email") {
        return left(InvalidEmailFailure());
      } else if (e.code == "user-not-found") {
        return left(UserNotFoundFailure());
      } else if (e.code == "wrong-password") {
        return left(WrongPasswordFailure());
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
      if (e.code == "email-already-in-use") {
        return left(EmailAlreadyInUseFailure());
      } else if (e.code == "invalid-email") {
        return left(InvalidEmailFailure());
      } else if (e.code == "weak-password") {
        return left(WeakPasswordFailure());
      } else {
        return left(ServerFailure());
      }
    }
  }
}
