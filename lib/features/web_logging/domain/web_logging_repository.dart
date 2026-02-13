import 'package:finanzbegleiter/constants.dart';

abstract class WebLoggingRepository {
  Future<void> log(LogLevel logLevel, String message, String appVersion,
      String userAgent, StackTrace? stackTrace);
}
