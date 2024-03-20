import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/registered_recommendor.dart';

abstract class RecommendationsRepository {
  Future<Either<DatabaseFailure, Unit>> registerRecommendor(
      {required UnregisteredRecommendor recommendor});
  Future<Either<DatabaseFailure, bool>> checkIfRecommendorAlreadyExists(
      {required String email});
}
