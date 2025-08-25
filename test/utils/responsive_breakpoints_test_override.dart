import 'package:finanzbegleiter/constants.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// Global test override for ResponsiveBreakpoints.of() that provides immediate desktop values
/// 
/// Usage: Import this file in any test that uses ResponsiveBreakpoints
/// This automatically provides consistent desktop dimensions without async initialization
class ResponsiveBreakpoints {
  /// Mock replacement for ResponsiveBreakpoints.of(context) in tests
  /// Returns consistent desktop values immediately, no async initialization needed
  static ResponsiveBreakpointsData of(BuildContext context) {
    return const ResponsiveBreakpointsData(
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
}