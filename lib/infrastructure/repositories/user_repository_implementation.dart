// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';
import 'package:finanzbegleiter/infrastructure/extensions/firebase_helpers.dart';
import 'package:finanzbegleiter/infrastructure/models/user_model.dart';

class UserRepositoryImplementation implements UserRepository {
  final FirebaseFirestore firestore;

  UserRepositoryImplementation({
    required this.firestore,
  });

  @override
  Stream<Either<DatabaseFailure, CustomUser>> observeUser() async* {
    final userDoc = await firestore.userDocument();
    var requestedUser = await userDoc.get();
    if (!requestedUser.exists) {
      yield left(NotFoundFailure());
    }

    yield* userDoc.snapshots().map((snapshot) {
      var document = snapshot.data() as Map<String, dynamic>;
      var model =
          UserModel.fromMap(document).copyWith(id: snapshot.id).toDomain();
      return right<DatabaseFailure, CustomUser>(model);
    }).handleError((e) {
      if (e is FirebaseException) {
        if (e.code.contains("permission-denied") ||
            e.code.contains("PERMISSION_DENIED")) {
          return left(PermissionDeniedFailure());
        } else {
          return left(BackendFailure());
        }
      } else {
        return left(BackendFailure());
      }
    });
  }

  @override
  Future<Either<DatabaseFailure, Unit>> createUser(
      {required CustomUser user}) async {
    final userCollection = FirebaseFirestore.instance.collection("users");
    final userModel = UserModel.fromDomain(user);
    try {
      await userCollection.doc(userModel.id).set(userModel.toMap());
      return right(unit);
    } on FirebaseException catch (e) {
      if (e.code.contains("PERMISSION_DENIED")) {
        return left(PermissionDeniedFailure());
      } else {
        return left(BackendFailure());
      }
    }
  }

  @override
  Future<Either<DatabaseFailure, Unit>> updateUser(
      {required CustomUser user}) async {
    final userCollection = FirebaseFirestore.instance.collection("users");
    final userModel = UserModel.fromDomain(user);
    try {
      await userCollection.doc(userModel.id).update(userModel.toMap());
      return right(unit);
    } on FirebaseException catch (e) {
      if (e.code.contains("PERMISSION_DENIED")) {
        return left(PermissionDeniedFailure());
      } else if (e.code.contains("NOT_FOUND")) {
        return left(NotFoundFailure());
      } else {
        return left(BackendFailure());
      }
    }
  }
}
