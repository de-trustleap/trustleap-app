abstract class WebLoggingRepository {
  Future<void> reportWebCrash(
      String message, StackTrace? stack, String? browser);
  Future<void> reportWarning(String message, String? browser);
}
