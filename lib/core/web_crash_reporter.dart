import 'dart:ui';

import 'package:finanzbegleiter/features/web_logging/application/web_logging_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:web/web.dart';

class WebCrashReporter {
  static void initialize() {
    FlutterError.onError = (FlutterErrorDetails details) {
      report(details.exceptionAsString(), details.stack, LogLevel.error);
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      report(error.toString(), stack, LogLevel.error);
      return true;
    };
  }

  static void report(String message, StackTrace? stack, LogLevel logLevel) {
    final cubit = Modular.get<WebLoggingCubit>();
    cubit.log(message, _detectBrowser(), "1.0.0", logLevel, stack);
  }

  static String _detectBrowser() {
    return window.navigator.userAgent.toLowerCase();
  }
}
