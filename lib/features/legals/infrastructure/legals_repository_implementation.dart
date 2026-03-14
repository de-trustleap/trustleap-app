// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/cloud_functions_service.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/features/legals/domain/legals.dart';
import 'package:finanzbegleiter/features/legals/domain/legals_repository.dart';
import 'package:finanzbegleiter/features/legals/infrastructure/legals_model.dart';

class LegalsRepositoryImplementation implements LegalsRepository {
  final FirebaseFirestore firestore;
  final CloudFunctionsService cloudFunctions;

  LegalsRepositoryImplementation(
      {required this.firestore, required this.cloudFunctions});

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
          case LegalsType.imprint:
            return right(legals.imprint);
        }
      }
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, Legals>> getAllLegals() async {
    final legalsDoc = firestore.collection("legals").doc("1");
    try {
      final snapshot = await legalsDoc.get();
      if (snapshot.data() == null) {
        return left(NotFoundFailure());
      } else {
        final legals = LegalsModel.fromMap(snapshot.data()!).toDomain();
        return right(legals);
      }
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }

  @override
  Future<Either<DatabaseFailure, Unit>> saveLegals(Legals legals) async {
    final model = LegalsModel.fromDomain(legals);
    return cloudFunctions.call(
      'saveLegals',
      {
        'avv': model.avv,
        'privacyPolicy': model.privacyPolicy,
        'termsAndConditions': model.termsAndCondition,
        'imprint': model.imprint,
      },
      (_) => unit,
    );
  }
}
