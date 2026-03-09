import 'dart:async';

import 'package:web/web.dart' as web;

class WebInterop {
  static String get userAgent => web.window.navigator.userAgent;

  static void windowOpen(String url, String target) =>
      web.window.open(url, target);

  static Stream<void> get onDocumentVisibilityChange =>
      web.document.onVisibilityChange.map((_) {});

  static bool get documentHidden => web.document.hidden;
}
