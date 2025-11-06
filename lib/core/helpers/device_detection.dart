import 'package:flutter/material.dart';
import 'device_detection_web.dart'
    if (dart.library.io) 'device_detection_mobile.dart';

class DeviceDetection {
  static bool isTouchDevice(BuildContext context) {
    return DeviceDetectionImpl.isTouchDevice(context);
  }

  static bool isDesktop(BuildContext context) {
    return !isTouchDevice(context);
  }
}
