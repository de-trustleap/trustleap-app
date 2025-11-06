import 'package:flutter/material.dart';

class DeviceDetectionImpl {
  static bool isTouchDevice(BuildContext context) {
    final platform = Theme.of(context).platform;
    return platform == TargetPlatform.iOS || platform == TargetPlatform.android;
  }
}
