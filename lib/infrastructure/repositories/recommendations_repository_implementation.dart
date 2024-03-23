// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/domain/entities/unregistered_promoter.dart';
import 'package:finanzbegleiter/domain/repositories/recommendations_repository.dart';
import 'package:finanzbegleiter/infrastructure/models/unregistered_promoter_model.dart';

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
}
