import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

class CloudFunctionsService {
  final FirebaseFunctions functions;
  final FirebaseAppCheck appCheck;

  CloudFunctionsService({required this.functions, required this.appCheck});

  Future<Either<DatabaseFailure, T>> call<T>(
    String functionName,
    Map<String, dynamic> params,
    T Function(dynamic) mapper, {
    HttpsCallableOptions? options,
  }) async {
    final String? token;
    try {
      token = await appCheck.getToken();
    } on FirebaseException catch (e) {
      if (e.plugin == 'firebase_app_check' || e.plugin == 'app-check') {
        return left(PermissionDeniedFailure());
      }
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    } catch (e) {
      return left(PermissionDeniedFailure());
    }

    try {
      final result =
          await functions.httpsCallable(functionName, options: options).call({
        ...params,
        'appCheckToken': token,
      });
      return right(mapper(result.data));
    } on FirebaseFunctionsException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    }
  }
}
