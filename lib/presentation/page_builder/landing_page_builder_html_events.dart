import 'dart:js_interop';

import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

class LandingPageBuilderHtmlEvents {
  web.EventListener? beforeUnloadListener;
  bool _isBeforeUnloadListenerEnabled = false;

  void removeListener() {
    if (beforeUnloadListener != null) {
      web.window.removeEventListener('beforeunload', beforeUnloadListener!);
      beforeUnloadListener = null;
      _isBeforeUnloadListenerEnabled = false;
    }
  }

  void enableLeavePageListeners(AppLocalizations localization) {
    _enableBeforeUnloadListener(localization);
  }

  void disableLeavePageListeners() {
    _disableBeforeUnloadListener();
  }

  void _enableBeforeUnloadListener(AppLocalizations localization) {
    if (kIsWeb && !_isBeforeUnloadListenerEnabled) {
      beforeUnloadListener = ((web.Event event) {
        event.preventDefault();

        if (event.isA<web.BeforeUnloadEvent>()) {
          final unloadEvent = event as web.BeforeUnloadEvent;
          unloadEvent.returnValue =
              localization.landingpage_pagebuilder_unload_alert_message;
        }
      }).toJS;

      web.window.addEventListener('beforeunload', beforeUnloadListener!);
      _isBeforeUnloadListenerEnabled = true;
    }
  }

  void _disableBeforeUnloadListener() {
    if (kIsWeb && _isBeforeUnloadListenerEnabled) {
      if (beforeUnloadListener != null) {
        web.window.removeEventListener('beforeunload', beforeUnloadListener!);
        beforeUnloadListener = null;
      }
      _isBeforeUnloadListenerEnabled = false;
    }
  }
}
