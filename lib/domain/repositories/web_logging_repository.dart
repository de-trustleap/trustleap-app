abstract class WebLoggingRepository {
  Future<void> reportWebCrash(
      String message, StackTrace? stack, String? browser);
}
