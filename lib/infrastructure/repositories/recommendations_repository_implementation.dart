// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/domain/entities/registered_recommendor.dart';
import 'package:finanzbegleiter/domain/repositories/recommendations_repository.dart';
import 'package:finanzbegleiter/infrastructure/models/registered_recommendor_model.dart';

class RecommendationsRepositoryImplementation implements RecommendationsRepository {
  final FirebaseFirestore firestore;

  RecommendationsRepositoryImplementation({
    required this.firestore,
  });

  @override
  Future<Either<DatabaseFailure, Unit>> registerRecommendor({required RegisteredRecommendor recommendor}) async {
    final recommendorCollection = firestore.collection("registeredRecommendors");
    final recommendorModel = RegisteredRecommendorModel.fromDomain(recommendor);
    try {
      await recommendorCollection.doc(recommendorModel.id).set(recommendorModel.toMap());
      return right(unit);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, bool>> checkIfRecommendorAlreadyExists({required String email}) async {
    final recommendorCollection = firestore.collection("registeredRecommendors");
    try {
      final recommendor = await recommendorCollection.where('email', isEqualTo: email).limit(1).get();
      if (recommendor.docs.isEmpty) {
        return right(false);
      } else {
        return right(recommendor.docs.first.exists ? true : false);
      }
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

}
