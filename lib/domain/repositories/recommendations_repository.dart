import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/unregistered_promoter.dart';

abstract class RecommendationsRepository {
  Future<Either<DatabaseFailure, Unit>> registerPromoter(
      {required UnregisteredPromoter promoter});
  Future<Either<DatabaseFailure, bool>> checkIfPromoterAlreadyExists(
      {required String email});
}
