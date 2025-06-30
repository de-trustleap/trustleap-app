// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_functions/cloud_functions.dart';
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
  Future<void> reportWebCrash(
      String message, StackTrace? stack, String? browser) async {
    try {
      final appCheckToken = await appCheck.getToken();
      String stackTraceString = stack?.toString() ?? "No stack trace available";
      HttpsCallable callable =
          firebaseFunctions.httpsCallable("reportWebCrash");
      await callable.call({
        "appCheckToken": appCheckToken,
        "message": message,
        "stack": stackTraceString,
        "browser": browser,
        "timestamp": DateTime.now().toIso8601String()
      });
    } catch (e) {
      return;
    }
  }

  @override
  Future<void> log(String loglevel, String message, String appVersion, String userAgent, StackTrace? stack) async {
    try {
      final appCheckToken = await appCheck.getToken();
      String stackTraceString = stack?.toString() ?? "";
      HttpsCallable callable = firebaseFunctions.httpsCallable("onLog");
      await callable.call({
        "appCheckToken": appCheckToken,
        "loglevel": loglevel,
        "message": message,
        "appVersion": appVersion,
        "userAgent": userAgent,
        "stacktrace": stackTraceString
      });
    } catch (e) {
      return;
    }
  }
}
