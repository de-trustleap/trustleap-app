// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/domain/repositories/legals_repository.dart';
import 'package:finanzbegleiter/infrastructure/models/legals_model.dart';

class LegalsRepositoryImplementation implements LegalsRepository {
  final FirebaseFirestore firestore;

  LegalsRepositoryImplementation({
    required this.firestore,
  });

  @override
  Future<Either<DatabaseFailure, String?>> getLegals(LegalsType type) async {
    final legalsDoc = firestore.collection("legals").doc("1");
    try {
      final snapshot = await legalsDoc.get();
      if (snapshot.data() == null) {
        return left(NotFoundFailure());
      } else {
        final legals = LegalsModel.fromMap(snapshot.data()!).toDomain();
        switch (type) {
          case LegalsType.privacyPolicy:
            return right(legals.privacyPolicy);
          case LegalsType.termsAndCondition:
            return right(legals.termsAndCondition);
        }
      }
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }
}
