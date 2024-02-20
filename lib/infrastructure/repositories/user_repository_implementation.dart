// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';
import 'package:finanzbegleiter/infrastructure/models/user_model.dart';

class UserRepositoryImplementation implements UserRepository {
  final FirebaseFirestore firestore;

  UserRepositoryImplementation({
    required this.firestore,
  });

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
        return left(PermissionDenied());
      } else {
        return left(BackendFailure());
      }
    }
  }

  @override
  Future<Either<DatabaseFailure, Unit>> updateUser({required CustomUser user}) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
