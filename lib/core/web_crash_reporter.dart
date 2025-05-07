import 'dart:ui';

import 'package:finanzbegleiter/application/web_logging/web_logging_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:web/web.dart';

class WebCrashReporter {
  static void initialize() {
    FlutterError.onError = (FlutterErrorDetails details) {
      _report(details.exceptionAsString(), details.stack);
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      _report(error.toString(), stack);
      return true;
    };
  }

  static void _report(String message, StackTrace? stack) {
    final cubit = Modular.get<WebLoggingCubit>();
    cubit.reportWebCrash(message, stack, _detectBrowser());
  }

  static String _detectBrowser() {
    return window.navigator.userAgent.toLowerCase();
  }
}
