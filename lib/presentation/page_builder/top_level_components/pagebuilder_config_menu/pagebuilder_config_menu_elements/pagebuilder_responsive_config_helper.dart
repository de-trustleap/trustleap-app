import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';

class PagebuilderResponsiveConfigHelper {
  final PagebuilderResponsiveBreakpoint currentBreakpoint;

  const PagebuilderResponsiveConfigHelper(this.currentBreakpoint);

  /// Gets the value for the current breakpoint
  T? getValue<T>(PagebuilderResponsiveOrConstant<T>? value) {
    return value?.getValueForBreakpoint(currentBreakpoint);
  }

  /// Sets a new value for the current breakpoint
  PagebuilderResponsiveOrConstant<T> setValue<T>(
    PagebuilderResponsiveOrConstant<T>? currentValue,
    T newValue,
  ) {
    // If setting desktop value, keep it as constant (unless already responsive)
    if (currentBreakpoint == PagebuilderResponsiveBreakpoint.desktop) {
      if (currentValue == null || currentValue.constantValue != null) {
        return PagebuilderResponsiveOrConstant.constant(newValue);
      }
      // Already responsive, update desktop value
      final Map<String, T> updatedMap =
          Map.from(currentValue.responsiveValue ?? {});
      updatedMap["desktop"] = newValue;
      return PagebuilderResponsiveOrConstant.responsive(updatedMap);
    }

    // For tablet or mobile, convert to responsive
    if (currentValue == null) {
      return PagebuilderResponsiveOrConstant.responsive({
        _getBreakpointKey(): newValue,
      });
    }

    if (currentValue.constantValue != null) {
      // Convert from constant to responsive, keeping desktop value
      return PagebuilderResponsiveOrConstant.responsive({
        "desktop": currentValue.constantValue as T,
        _getBreakpointKey(): newValue,
      });
    }

    // Update existing responsive value
    final Map<String, T> updatedMap =
        Map.from(currentValue.responsiveValue ?? {});
    updatedMap[_getBreakpointKey()] = newValue;
    return PagebuilderResponsiveOrConstant.responsive(updatedMap);
  }

  String _getBreakpointKey() {
    switch (currentBreakpoint) {
      case PagebuilderResponsiveBreakpoint.mobile:
        return "mobile";
      case PagebuilderResponsiveBreakpoint.tablet:
        return "tablet";
      case PagebuilderResponsiveBreakpoint.desktop:
        return "desktop";
    }
  }
}
