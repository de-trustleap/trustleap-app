import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/legals/domain/legals.dart';

abstract class LegalsRepository {
  Future<Either<DatabaseFailure, String?>> getLegals(LegalsType type);
  Future<Either<DatabaseFailure, Legals>> getAllLegals();
  Future<Either<DatabaseFailure, Unit>> saveLegals(Legals legals);
}
