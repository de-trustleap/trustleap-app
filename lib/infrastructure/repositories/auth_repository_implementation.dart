// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';
import 'package:finanzbegleiter/infrastructure/extensions/firebase_user_mapper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImplementation implements AuthRepository {
  final FirebaseAuth firebaseAuth;

  AuthRepositoryImplementation({
    required this.firebaseAuth,
  });

  @override
  Future<Either<AuthFailure, UserCredential>> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final creds = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return right(creds);
    } on FirebaseAuthException catch (e) {
      return left(FirebaseExceptionParser.getAuthException(input: e.message));
    }
  }

  @override
  Future<Either<AuthFailure, UserCredential>> registerWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final creds = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return right(creds);
    } on FirebaseAuthException catch (e) {
      return left(FirebaseExceptionParser.getAuthException(input: e.message));
    }
  }

  @override
  Future<Either<AuthFailure, UserCredential>> reauthenticateWithPassword(
      {required String password}) async {
    try {
      final currentUser = optionOf(firebaseAuth.currentUser);
      return await currentUser.fold(() {
        return left(UserNotFoundFailure());
      }, (user) async {
        if (user.email == null) {
          return left(InvalidEmailFailure());
        } else {
          final credential = EmailAuthProvider.credential(
              email: user.email!, password: password);
          return right(await user.reauthenticateWithCredential(credential));
        }
      });
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getAuthException(input: e.message));
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Option<CustomUser> getSignedInUser() =>
      optionOf(firebaseAuth.currentUser?.toDomain());

  @override
  User? getCurrentUser() => firebaseAuth.currentUser;

  @override
  Stream<User?> observeAuthState() async* {
    yield* firebaseAuth.authStateChanges();
  }

  @override
  Future<void> resendEmailVerification() async {
    await firebaseAuth.currentUser?.sendEmailVerification();
  }
}
