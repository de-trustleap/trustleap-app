import 'package:finanzbegleiter/constants.dart';

class PagebuilderResponsiveViewportSizes {
  static const double mobile = 375.0;
  static const double tablet = 768.0;
  static const double desktop = 1440.0;

  static double getWidth(PagebuilderResponsiveBreakpoint breakpoint) {
    switch (breakpoint) {
      case PagebuilderResponsiveBreakpoint.mobile:
        return mobile;
      case PagebuilderResponsiveBreakpoint.tablet:
        return tablet;
      case PagebuilderResponsiveBreakpoint.desktop:
        return desktop;
    }
  }
}
