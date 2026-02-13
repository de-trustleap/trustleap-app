// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';

class PagebuilderResponsiveOrConstant<T> extends Equatable {
  final T? constantValue;
  final Map<String, T>? responsiveValue;

  const PagebuilderResponsiveOrConstant.constant(this.constantValue)
      : responsiveValue = null;

  const PagebuilderResponsiveOrConstant.responsive(this.responsiveValue)
      : constantValue = null;

  T? getValueForBreakpoint(PagebuilderResponsiveBreakpoint breakpoint) {
    if (constantValue != null) return constantValue;
    if (responsiveValue == null) return null;

    switch (breakpoint) {
      case PagebuilderResponsiveBreakpoint.mobile:
        return responsiveValue!["mobile"] ??
            responsiveValue!["tablet"] ??
            responsiveValue!["desktop"];
      case PagebuilderResponsiveBreakpoint.tablet:
        return responsiveValue!["tablet"] ??
            responsiveValue!["desktop"];
      case PagebuilderResponsiveBreakpoint.desktop:
        return responsiveValue!["desktop"];
    }
  }

  PagebuilderResponsiveOrConstant<T> deepCopy() {
    if (constantValue != null) {
      return PagebuilderResponsiveOrConstant.constant(constantValue as T);
    }
    if (responsiveValue != null) {
      return PagebuilderResponsiveOrConstant.responsive(
          Map<String, T>.from(responsiveValue!));
    }
    return PagebuilderResponsiveOrConstant.constant(null as T);
  }

  @override
  List<Object?> get props => [constantValue, responsiveValue];
}
