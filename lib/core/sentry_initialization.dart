import 'package:sentry_flutter/sentry_flutter.dart';

class SentryInitialization {
  static const String _dsn =
      'https://618cb82100c49afd9b092cd092c96202@o4509530459209728.ingest.de.sentry.io/4509530460586064';

  static Future<void> init({required Future<void> Function() appRunner}) async {
    await SentryFlutter.init(
      (options) {
        options.dsn = _dsn;
        options.sendDefaultPii = false;
        options.tracesSampleRate = 0.1;
        options.profilesSampleRate = 0.1;
        options.beforeSend = _beforeSend;
      },
      appRunner: appRunner,
    );
  }

  static SentryEvent? _beforeSend(SentryEvent event, Hint hint) {
    final exceptions = event.exceptions;
    if (exceptions != null && exceptions.isNotEmpty) {
      final ex = exceptions.first;
      // Drop JS JSON.parse errors caused by html_editor_enhanced trying
      // to json.decode every window.postMessage event without try-catch.
      if (ex.type == 'FormatException' &&
          (ex.value?.contains('SyntaxError') ?? false)) {
        return null;
      }
    }
    return event;
  }
}
