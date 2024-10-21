import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

class LandingPageBuilderHtmlEvents {
  html.EventListener? beforeUnloadListener;
  bool _isBeforeUnloadListenerEnabled = false;

  void removeListener() {
    html.window.removeEventListener('beforeunload', beforeUnloadListener);
  }

  void enableLeavePageListeners(AppLocalizations localization) {
    _enableBeforeUnloadListener(localization);
  }

  void disableLeavePageListeners() {
    _disableBeforeUnloadListener();
  }

  void _enableBeforeUnloadListener(AppLocalizations localization) {
    if (kIsWeb && !_isBeforeUnloadListenerEnabled) {
      beforeUnloadListener = (html.Event event) {
        event.preventDefault();
        (event as html.BeforeUnloadEvent).returnValue =
            localization.landingpage_pagebuilder_unload_alert_message;
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
