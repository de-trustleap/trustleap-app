import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/features/admin/domain/admin_registration_code_repository.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

class AdminRegistrationCodeRepositoryImplementation
    implements AdminRegistrationCodeRepository {
  final FirebaseFunctions firebaseFunctions;
  final FirebaseAppCheck appCheck;

  AdminRegistrationCodeRepositoryImplementation(
      {required this.firebaseFunctions, required this.appCheck});

  @override
  Future<Either<DatabaseFailure, Unit>> sendRegistrationCodeFromAdmin(
      {required String email,
      required String code,
      required String firstName}) async {
    final appCheckToken = await appCheck.getToken();
    HttpsCallable callable =
        firebaseFunctions.httpsCallable("sendRegistrationCodeFromAdmin");
    try {
      await callable.call({
        "appCheckToken": appCheckToken,
        "email": email,
        "code": code,
        "firstName": firstName
      });
      return right(unit);
    } on FirebaseFunctionsException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }
}
