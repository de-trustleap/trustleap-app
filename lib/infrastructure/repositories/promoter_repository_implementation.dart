// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/domain/entities/unregistered_promoter.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/promoter_repository.dart';
import 'package:finanzbegleiter/infrastructure/extensions/firebase_helpers.dart';
import 'package:finanzbegleiter/infrastructure/models/unregistered_promoter_model.dart';
import 'package:finanzbegleiter/infrastructure/models/user_model.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

class PromoterRepositoryImplementation implements PromoterRepository {
  final FirebaseFirestore firestore;
  final FirebaseFunctions firebaseFunctions;
  final FirebaseAppCheck appCheck;

  PromoterRepositoryImplementation(
      {required this.firestore,
      required this.firebaseFunctions,
      required this.appCheck});

  @override
  Future<Either<DatabaseFailure, Unit>> registerPromoter(
      {required UnregisteredPromoter promoter}) async {
    final appCheckToken = await appCheck.getToken();
    HttpsCallable callable = firebaseFunctions.httpsCallable("createPromoter");
    final promoterMap = UnregisteredPromoterModel.fromDomain(promoter).toMap();
    promoterMap.remove("createdAt");
    promoterMap.remove("expiresAt");
    promoterMap["appCheckToken"] = appCheckToken;
    try {
      await callable.call(promoterMap);
      return right(unit);
    } on FirebaseFunctionsException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, bool>> checkIfPromoterAlreadyExists(
      {required String email}) async {
    final promoterCollection = firestore.collection("unregisteredPromoters");
    final usersCollection = firestore.collection("users");
    try {
      final promoter = await promoterCollection
          .where("email", isEqualTo: email)
          .limit(1)
          .get();
      final user =
          await usersCollection.where("email", isEqualTo: email).limit(1).get();
      if (promoter.docs.isEmpty && user.docs.isEmpty) {
        return right(false);
      } else {
        if (promoter.docs.isNotEmpty && promoter.docs.first.exists) {
          return right(true);
        } else if (user.docs.isNotEmpty && user.docs.first.exists) {
          return right(true);
        } else {
          return right(false);
        }
      }
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Stream<Either<DatabaseFailure, CustomUser>> observeAllPromoters() async* {
    final userDoc = await firestore.userDocument();
    var requestedUser = await userDoc.get();
    if (!requestedUser.exists) {
      yield left(NotFoundFailure());
    }
    yield* userDoc.snapshots().map((snapshot) {
      var document = snapshot.data() as Map<String, dynamic>;
      var model = UserModel.fromFirestore(document, snapshot.id).toDomain();
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
  Future<Either<DatabaseFailure, List<CustomUser>>> getRegisteredPromoters(
      List<String> ids) async {
    final usersCollection = firestore.collection("users");
    // The ids needs to be sliced into chunks of 10 elements because the whereIn function can only process 10 elements at once.
    final chunks = ids.slices(10);
    final List<QuerySnapshot<Map<String, dynamic>>> querySnapshots = [];
    final List<CustomUser> users = [];
    try {
      await Future.forEach(chunks, (element) async {
        final document = await usersCollection
            .orderBy("firstName", descending: true)
            .where(FieldPath.documentId, whereIn: element)
            .get();
        querySnapshots.add(document);
      });
      for (var document in querySnapshots) {
        for (var snapshot in document.docs) {
          var doc = snapshot.data();
          var model = UserModel.fromFirestore(doc, snapshot.id).toDomain();
          // do not show deactivated users
          if (model.deletesAt == null) {
            users.add(model);
          }
        }
      }
      users.sort((a, b) {
        if (a.createdAt != null && b.createdAt != null) {
          return b.createdAt!.compareTo(a.createdAt!);
        } else {
          return a.id.value.compareTo(b.id.value);
        }
      });
      return right(users);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, List<UnregisteredPromoter>>>
      getUnregisteredPromoters(List<String> ids) async {
    final unregisteredPromotersCollection =
        firestore.collection("unregisteredPromoters");
    // The ids needs to be sliced into chunks of 10 elements because the whereIn function can only process 10 elements at once.
    final chunks = ids.slices(10);
    final List<QuerySnapshot<Map<String, dynamic>>> querySnapshots = [];
    final List<UnregisteredPromoter> unregisteredPromoters = [];
    try {
      await Future.forEach(chunks, (element) async {
        final document = await unregisteredPromotersCollection
            .orderBy("expiresAt", descending: true)
            .where(FieldPath.documentId, whereIn: element)
            .get();
        querySnapshots.add(document);
      });
      for (var document in querySnapshots) {
        for (var snapshot in document.docs) {
          var doc = snapshot.data();
          var model = UnregisteredPromoterModel.fromFirestore(doc, snapshot.id)
              .toDomain();
          unregisteredPromoters.add(model);
        }
      }
      unregisteredPromoters.sort((a, b) => b.expiresAt.compareTo(a.expiresAt));
      return right(unregisteredPromoters);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }
}
