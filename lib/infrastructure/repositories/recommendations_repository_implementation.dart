// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/domain/entities/unregistered_promoter.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/recommendations_repository.dart';
import 'package:finanzbegleiter/infrastructure/extensions/firebase_helpers.dart';
import 'package:finanzbegleiter/infrastructure/models/unregistered_promoter_model.dart';
import 'package:finanzbegleiter/infrastructure/models/user_model.dart';

class RecommendationsRepositoryImplementation
    implements RecommendationsRepository {
  final FirebaseFirestore firestore;

  RecommendationsRepositoryImplementation({
    required this.firestore,
  });

  @override
  Future<Either<DatabaseFailure, Unit>> registerPromoter(
      {required UnregisteredPromoter promoter}) async {
    final promoterCollection = firestore.collection("unregisteredPromoters");
    final promoterModel = UnregisteredPromoterModel.fromDomain(promoter);
    try {
      await promoterCollection.doc(promoterModel.id).set(promoterModel.toMap());
      return right(unit);
    } on FirebaseException catch (e) {
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
    print("USER: $requestedUser");
    yield* userDoc.snapshots().map((snapshot) {
      var document = snapshot.data() as Map<String, dynamic>;
      var model = UserModel.fromFirestore(document, snapshot.id).toDomain();
      print("MODEL: $model");
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
            .where(FieldPath.documentId, whereIn: ids)
            .get();
        querySnapshots.add(document);
      });
      for (var document in querySnapshots) {
        for (var snapshot in document.docs) {
          var doc = snapshot.data();
          var model = UserModel.fromFirestore(doc, snapshot.id).toDomain();
          users.add(model);
        }
      }
      return right(users);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, List<UnregisteredPromoter>>>
      getUnregisteredPromoters(List<String> ids) {
    // TODO: implement getUnregisteredPromoters
    throw UnimplementedError();
  }
}
