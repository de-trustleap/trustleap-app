// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';
import 'package:finanzbegleiter/infrastructure/extensions/firebase_helpers.dart';
import 'package:finanzbegleiter/infrastructure/models/user_model.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepositoryImplementation implements UserRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseFunctions firebaseFunctions;
  final FirebaseAppCheck appCheck;

  UserRepositoryImplementation(
      {required this.firestore,
      required this.firebaseAuth,
      required this.firebaseFunctions,
      required this.appCheck});

  @override
  Stream<Either<DatabaseFailure, CustomUser>> observeUser() async* {
    final userDoc = await firestore.userDocument();
    var requestedUser = await userDoc.get();
    if (!requestedUser.exists) {
      yield left(NotFoundFailure());
    }
    final role = await _getUserCustomClaims();
    yield* userDoc.snapshots().map((snapshot) {
      var document = snapshot.data() as Map<String, dynamic>;
      var model = UserModel.fromFirestore(document, snapshot.id)
          .toDomain()
          .copyWith(role: role);
      return right<DatabaseFailure, CustomUser>(model);
    }).handleError((e) {
      if (e is FirebaseException) {
        return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
      } else {
        return left(BackendFailure());
      }
    });
  }

  @override
  Future<Either<DatabaseFailure, Unit>> createUser(
      {required CustomUser user}) async {
    final appCheckToken = await appCheck.getToken();
    HttpsCallable callable = firebaseFunctions.httpsCallable("createUser");
    UserModel userModel = UserModel.fromDomain(user);
    try {
      await callable.call({
        "appCheckToken": appCheckToken,
        "id": userModel.id,
        "gender": userModel.gender,
        "firstName": userModel.firstName,
        "lastName": userModel.lastName,
        "birthDate": userModel.birthDate,
        "address": userModel.address,
        "postCode": userModel.postCode,
        "place": userModel.place,
        "email": userModel.email
      });
      return right(unit);
    } on FirebaseFunctionsException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, Unit>> updateUser(
      {required CustomUser user}) async {
    final userCollection = firestore.collection("users");
    final userModel = UserModel.fromDomain(user);
    try {
      await userCollection.doc(userModel.id).update(userModel.toMap());
      return right(unit);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, Unit>> updateEmail(
      {required String email}) async {
    try {
      final currentUser = optionOf(firebaseAuth.currentUser);
      return await currentUser.fold(() {
        return left(BackendFailure());
      }, (user) async {
        final appCheckToken = await appCheck.getToken();
        HttpsCallable callable = firebaseFunctions.httpsCallable("updateEmail");
        await callable.call({
          "appCheckToken": appCheckToken,
          "newEmail": email,
        });
        final updateDatabaseFailureOrSuccess =
            await _updateEmailInDatabase(user: user, email: email);
        return updateDatabaseFailureOrSuccess.fold((failure) {
          return left(failure);
        }, (r) {
          return right(unit);
        });
      });
    } on FirebaseFunctionsException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  Future<Either<DatabaseFailure, void>> _updateEmailInDatabase(
      {required User user, required String email}) async {
    final doc = firestore.collection("users").doc(user.uid);
    try {
      return right(await doc.update({"email": email}));
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<bool> isEmailVerified() async {
    await firebaseAuth.currentUser?.reload();
    final user = firebaseAuth.currentUser;
    return user?.emailVerified ?? false;
  }

  @override
  Future<Either<AuthFailure, void>> updatePassword(
      {required String password}) async {
    try {
      final currentUser = optionOf(firebaseAuth.currentUser);
      return await currentUser.fold(() {
        return left(UserNotFoundFailure());
      }, (user) async {
        return right(await user.updatePassword(password));
      });
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getAuthException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, CustomUser>> getUser() async {
    final currentUser = optionOf(firebaseAuth.currentUser);
    try {
      return await currentUser.fold(() {
        return left(BackendFailure());
      }, (user) async {
        final id = user.uid;
        final userCollection = firestore.collection("users");
        final userDoc = await userCollection.doc(id).get();
        if (userDoc.data() != null) {
          final role = await _getUserCustomClaims();
          var userModel = UserModel.fromFirestore(userDoc.data()!, id)
              .toDomain()
              .copyWith(role: role);
          return right(userModel);
        } else {
          return left(NotFoundFailure());
        }
      });
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, CustomUser>> getParentUser(
      {required String parentID}) async {
    final userCollection = firestore.collection("users");
    try {
      final userDoc = await userCollection.doc(parentID).get();
      if (userDoc.data() != null) {
        var userModel =
            UserModel.fromFirestore(userDoc.data()!, parentID).toDomain();
        return right(userModel);
      } else {
        return left(NotFoundFailure());
      }
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  Future<Role> _getUserCustomClaims() async {
    final user = FirebaseAuth.instance.currentUser!;
    final idTokenResult = await user.getIdTokenResult(true);
    final claims = idTokenResult.claims;
    if (claims != null) {
      final isAdmin = claims["admin"] ?? false;
      final isCompany = claims["company"] ?? false;
      if (isAdmin is bool && isAdmin) {
        return Role.admin;
      } else if (isCompany is bool && isCompany) {
        return Role.company;
      } else {
        return Role.promoter;
      }
    } else {
      return Role.promoter;
    }
  }
}
