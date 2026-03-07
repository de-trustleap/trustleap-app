import 'dart:async';
import 'dart:io';

import 'package:finanzbegleiter/core/helpers/app_lifecycle_observer.dart';

class WebInterop {
  static final _lifecycleObserver = AppLifecycleObserver();

  static String get userAgent =>
      '${Platform.operatingSystem}/${Platform.operatingSystemVersion}';

  static void windowOpen(String url, String target) {}

  static Stream<void> get onDocumentVisibilityChange =>
      _lifecycleObserver.onResumed;

  static bool get documentHidden => false;
}
