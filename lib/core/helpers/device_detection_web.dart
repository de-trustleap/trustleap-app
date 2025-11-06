import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class DeviceDetectionImpl {
  static bool isTouchDevice(BuildContext context) {
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
}
