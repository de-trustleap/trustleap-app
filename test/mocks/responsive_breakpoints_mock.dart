import 'package:finanzbegleiter/constants.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// Global mock that replaces ResponsiveBreakpoints.of() for tests
/// This provides immediate, consistent desktop values without async initialization
class ResponsiveBreakpointsMock {
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

  /// Mock replacement for ResponsiveBreakpoints.of(context)
  /// Returns consistent desktop values immediately
  static ResponsiveBreakpointsData of(BuildContext context) {
    return _mockData;
  }
}

/// Extension to easily replace ResponsiveBreakpoints calls in tests
extension ResponsiveBreakpointsTestExtension on Type {
  static ResponsiveBreakpointsData of(BuildContext context) {
    return ResponsiveBreakpointsMock.of(context);
  }
}