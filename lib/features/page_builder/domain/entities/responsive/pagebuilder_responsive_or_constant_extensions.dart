import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:flutter_modular/flutter_modular.dart';

extension PagebuilderResponsiveOrConstantExtension<T>
    on PagebuilderResponsiveOrConstant<T>? {
  T? getValue() {
    if (this == null) return null;

    final breakpoint =
        Modular.get<PagebuilderResponsiveBreakpointCubit>().state;
    return this!.getValueForBreakpoint(breakpoint);
  }

  T? getValueFor(PagebuilderResponsiveBreakpoint breakpoint) {
    if (this == null) return null;
    return this!.getValueForBreakpoint(breakpoint);
  }
}
