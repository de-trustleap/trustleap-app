import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

class LandingPageBuilderHtmlEvents {
  html.EventListener? beforeUnloadListener;
  bool _isBeforeUnloadListenerEnabled = false;

  void removeListener() {
    html.window.removeEventListener('beforeunload', beforeUnloadListener);
  }

  void enableLeavePageListeners() {
    _enableBeforeUnloadListener();
  }

  void disableLeavePageListeners() {
    _disableBeforeUnloadListener();
  }

  void _enableBeforeUnloadListener() {
    if (kIsWeb && !_isBeforeUnloadListenerEnabled) {
      beforeUnloadListener = (html.Event event) {
        event.preventDefault();
        (event as html.BeforeUnloadEvent).returnValue =
            "Willst du die Seite wirklich verlassen? Nicht gespeicherte Änderungen gehen verloren.";
      };
      html.window.addEventListener("beforeunload", beforeUnloadListener!);
      _isBeforeUnloadListenerEnabled = true;
    }
  }

  void _disableBeforeUnloadListener() {
    if (kIsWeb && _isBeforeUnloadListenerEnabled) {
      if (beforeUnloadListener != null) {
        html.window.removeEventListener('beforeunload', beforeUnloadListener!);
        beforeUnloadListener = null;
      }
      _isBeforeUnloadListenerEnabled = false;
    }
  }
}
