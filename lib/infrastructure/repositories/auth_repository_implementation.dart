// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';
import 'package:finanzbegleiter/infrastructure/extensions/firebase_user_mapper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImplementation implements AuthRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final FirebaseFunctions firebaseFunctions;

  AuthRepositoryImplementation(
      {required this.firebaseAuth,
      required this.firestore,
      required this.firebaseFunctions});

  @override
  Future<Either<AuthFailure, UserCredential>> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final creds = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return right(creds);
    } on FirebaseAuthException catch (e) {
      return left(FirebaseExceptionParser.getAuthException(code: e.code));
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
      return left(FirebaseExceptionParser.getAuthException(code: e.code));
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
      return left(FirebaseExceptionParser.getAuthException(code: e.code));
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

  @override
  Future<Either<AuthFailure, void>> resetPassword(
      {required String email}) async {
    try {
      final result = await firebaseAuth.sendPasswordResetEmail(email: email);
      return right(result);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getAuthException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, bool>> isRegistrationCodeValid(
      {required String email, required String code}) async {
    final promotersCollection = firestore.collection("unregisteredPromoters");
    try {
      final promoter = await promotersCollection
          .where("code", isEqualTo: code)
          .where("email", isEqualTo: email)
          .limit(1)
          .get();
      if (promoter.docs.isEmpty) {
        return right(false);
      } else {
        return right(true);
      }
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> deleteAccount() async {
    HttpsCallable callable =
        firebaseFunctions.httpsCallable("deactivateAccount");
    try {
      await callable.call();
      return right(unit);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getAuthException(code: e.code));
    }
  }
}
