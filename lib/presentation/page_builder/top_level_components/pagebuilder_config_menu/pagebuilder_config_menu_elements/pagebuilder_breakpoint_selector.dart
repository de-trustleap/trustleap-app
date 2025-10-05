import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderBreakpointSelector extends StatelessWidget {
  final PagebuilderResponsiveBreakpoint currentBreakpoint;

  const PagebuilderBreakpointSelector({
    super.key,
    required this.currentBreakpoint,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return PopupMenuButton<PagebuilderResponsiveBreakpoint>(
      initialValue: currentBreakpoint,
      icon: Icon(_getIconForBreakpoint(currentBreakpoint), size: 20),
      tooltip: _getTooltipForBreakpoint(currentBreakpoint),
      onSelected: (breakpoint) {
        Modular.get<PagebuilderResponsiveBreakpointCubit>()
            .setBreakpoint(breakpoint);
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: PagebuilderResponsiveBreakpoint.desktop,
          child: Row(
            children: [
              Icon(Icons.desktop_windows,
                  size: 18, color: themeData.colorScheme.secondary),
              const SizedBox(width: 8),
              const Text("Desktop"),
            ],
          ),
        ),
        PopupMenuItem(
          value: PagebuilderResponsiveBreakpoint.tablet,
          child: Row(
            children: [
              Icon(Icons.tablet,
                  size: 18, color: themeData.colorScheme.secondary),
              const SizedBox(width: 8),
              const Text("Tablet"),
            ],
          ),
        ),
        PopupMenuItem(
          value: PagebuilderResponsiveBreakpoint.mobile,
          child: Row(
            children: [
              Icon(Icons.phone_android,
                  size: 18, color: themeData.colorScheme.secondary),
              const SizedBox(width: 8),
              const Text("Mobile"),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getIconForBreakpoint(PagebuilderResponsiveBreakpoint breakpoint) {
    switch (breakpoint) {
      case PagebuilderResponsiveBreakpoint.mobile:
        return Icons.phone_android;
      case PagebuilderResponsiveBreakpoint.tablet:
        return Icons.tablet;
      case PagebuilderResponsiveBreakpoint.desktop:
        return Icons.desktop_windows;
    }
  }

  String _getTooltipForBreakpoint(PagebuilderResponsiveBreakpoint breakpoint) {
    switch (breakpoint) {
      case PagebuilderResponsiveBreakpoint.mobile:
        return "Mobile";
      case PagebuilderResponsiveBreakpoint.tablet:
        return "Tablet";
      case PagebuilderResponsiveBreakpoint.desktop:
        return "Desktop";
    }
  }
}
