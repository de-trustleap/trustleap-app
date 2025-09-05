// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_functions/cloud_functions.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/repositories/web_logging_repository.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

class WebLoggingRepositoryImplementation implements WebLoggingRepository {
  final FirebaseFunctions firebaseFunctions;
  final FirebaseAppCheck appCheck;

  WebLoggingRepositoryImplementation({
    required this.firebaseFunctions,
    required this.appCheck,
  });

  @override
  Future<void> log(LogLevel logLevel, String message, String appVersion,
      String userAgent, StackTrace? stackTrace) async {
    try {
      final appCheckToken = await appCheck.getToken();
      String stackTraceString =
          stackTrace?.toString() ?? "No stack trace available";
      HttpsCallable callable = firebaseFunctions.httpsCallable("log");
      await callable.call({
        "appCheckToken": appCheckToken,
        "level": logLevel.name,
        "message": message,
        "appVersion": appVersion,
        "userAgent": userAgent,
        "stackTrace": stackTraceString
      });
    } catch (e) {
      return;
    }
  }
}
