import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';

abstract class LegalsRepository {
  Future<Either<DatabaseFailure, String?>> getLegals(LegalsType type);
}
