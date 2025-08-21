import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// Helper class that provides ResponsiveBreakpoints with test support
class ResponsiveHelper {
  static bool _useTestMock = false;

  static void enableTestMode() {
    _useTestMock = true;
  }

  static void disableTestMode() {
    _useTestMock = false;
  }

  static ResponsiveBreakpointsData of(BuildContext context) {
    if (_useTestMock) {
      return _mockData;
    }

    return ResponsiveBreakpoints.of(context);
  }

  static const _mockData = ResponsiveBreakpointsData(
    screenWidth: 1200.0,
    screenHeight: 1600.0,
    breakpoint: Breakpoint(start: 801, end: 1920, name: DESKTOP),
    breakpoints: [
      Breakpoint(start: 0, end: 450, name: MOBILE),
      Breakpoint(start: 451, end: 800, name: TABLET),
      Breakpoint(start: 801, end: 1920, name: DESKTOP),
    ],
    isMobile: false,
    isPhone: false,
    isTablet: false,
    isDesktop: true,
    orientation: Orientation.portrait,
  );
}
