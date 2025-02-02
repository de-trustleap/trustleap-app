import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/domain/entities/permissions.dart';
import 'package:finanzbegleiter/domain/repositories/permission_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PermissionRepositoryImplementation implements PermissionRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  PermissionRepositoryImplementation(
      {required this.firestore, required this.auth});

  @override
  Stream<Either<DatabaseFailure, Permissions>> observeAllPermissions() async* {
    final user = auth.currentUser;
    if (user == null) {
      yield left(NotFoundFailure());
    }
    final permissionDoc =
        firestore.collection("userPermissions").doc(user!.uid);

    yield* permissionDoc
        .snapshots()
        .map<Either<DatabaseFailure, Permissions>>((snapshot) {
      if (!snapshot.exists) {
        return left(NotFoundFailure());
      }

      final data = snapshot.data() as Map<String, dynamic>;

      Map<String, bool> permissions = {};
      data.forEach((key, value) {
        if (value is bool) {
          permissions[key] = value;
        }
      });
      final permissionModel = Permissions(permissions: permissions);
      return right(permissionModel);
    }).handleError((e) {
      if (e is FirebaseException) {
        return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
      } else {
        return left(BackendFailure());
      }
    });
  }
}
