import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';

abstract class TutorialRepository {
  Future<Either<DatabaseFailure, int>> getCurrentStep(CustomUser user);
}
