abstract class WebLoggingRepository {
  Future<void> reportWebCrash(
      String message, StackTrace? stack, String? browser);

  Future<void> log(String loglevel, String message, String appVersion, String userAgent, StackTrace? stack);
}
