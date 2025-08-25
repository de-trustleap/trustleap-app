import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class DeviceDetection {
  static bool isTouchDevice(BuildContext context) {
    if (kIsWeb) {
      try {
        return web.window.navigator.maxTouchPoints > 0 ||
            web.window.matchMedia('(pointer: coarse)').matches;
      } catch (e) {
        final userAgent = web.window.navigator.userAgent.toLowerCase();
        return userAgent.contains('mobile') ||
            userAgent.contains('android') ||
            userAgent.contains('iphone') ||
            userAgent.contains('ipad');
      }
    }

    final platform = Theme.of(context).platform;
    return platform == TargetPlatform.iOS || platform == TargetPlatform.android;
  }

  static bool isDesktop(BuildContext context) {
    return !isTouchDevice(context);
  }
}
