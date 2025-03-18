import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';

abstract class AdminRegistrationCodeRepository {
  Future<Either<DatabaseFailure, Unit>> sendRegistrationCodeFromAdmin(
      {required String email, required String code, required String firstName});
}
