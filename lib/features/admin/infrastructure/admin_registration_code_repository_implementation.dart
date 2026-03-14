import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/cloud_functions_service.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/admin/domain/admin_registration_code_repository.dart';

class AdminRegistrationCodeRepositoryImplementation
    implements AdminRegistrationCodeRepository {
  final CloudFunctionsService cloudFunctions;

  AdminRegistrationCodeRepositoryImplementation(
      {required this.cloudFunctions});

  @override
  Future<Either<DatabaseFailure, Unit>> sendRegistrationCodeFromAdmin(
      {required String email,
      required String code,
      required String firstName}) async {
    return cloudFunctions.call(
      'sendRegistrationCodeFromAdmin',
      {'email': email, 'code': code, 'firstName': firstName},
      (_) => unit,
    );
  }
}
