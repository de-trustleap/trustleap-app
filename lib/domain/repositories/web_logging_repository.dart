import 'package:finanzbegleiter/constants.dart';

abstract class WebLoggingRepository {
  Future<void> reportWebCrash(
      String message, StackTrace? stack, String? browser);
  Future<void> log(LogLevel logLevel, String message, String appVersion,
      String userAgent, StackTrace? stackTrace);
}
