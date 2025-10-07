// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';

class PagebuilderResponsiveValue<T> extends Equatable {
  final T? mobile;
  final T? tablet;
  final T? desktop;

  const PagebuilderResponsiveValue({
    this.mobile,
    this.tablet,
    this.desktop,
  });

  T? getValueForBreakpoint(PagebuilderResponsiveBreakpoint breakpoint) {
    switch (breakpoint) {
      case PagebuilderResponsiveBreakpoint.mobile:
        return mobile ?? tablet ?? desktop;
      case PagebuilderResponsiveBreakpoint.tablet:
        return tablet ?? desktop ?? mobile;
      case PagebuilderResponsiveBreakpoint.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  PagebuilderResponsiveValue<T> setValueForBreakpoint(
    PagebuilderResponsiveBreakpoint breakpoint,
    T value,
  ) {
    switch (breakpoint) {
      case PagebuilderResponsiveBreakpoint.mobile:
        return PagebuilderResponsiveValue(
          mobile: value,
          tablet: tablet,
          desktop: desktop,
        );
      case PagebuilderResponsiveBreakpoint.tablet:
        return PagebuilderResponsiveValue(
          mobile: mobile,
          tablet: value,
          desktop: desktop,
        );
      case PagebuilderResponsiveBreakpoint.desktop:
        return PagebuilderResponsiveValue(
          mobile: mobile,
          tablet: tablet,
          desktop: value,
        );
    }
  }

  PagebuilderResponsiveValue<T> copyWith({
    T? mobile,
    T? tablet,
    T? desktop,
  }) {
    return PagebuilderResponsiveValue(
      mobile: mobile ?? this.mobile,
      tablet: tablet ?? this.tablet,
      desktop: desktop ?? this.desktop,
    );
  }

  @override
  List<Object?> get props => [mobile, tablet, desktop];
}
