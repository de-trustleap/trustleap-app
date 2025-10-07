import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
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
    final localization = AppLocalizations.of(context);

    return PopupMenuButton<PagebuilderResponsiveBreakpoint>(
      initialValue: currentBreakpoint,
      icon: Icon(_getIconForBreakpoint(currentBreakpoint), size: 20),
      tooltip: _getTooltipForBreakpoint(currentBreakpoint, localization),
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
              Text(localization.pagebuilder_breakpoint_desktop),
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
              Text(localization.pagebuilder_breakpoint_tablet),
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
              Text(localization.pagebuilder_breakpoint_mobile),
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

  String _getTooltipForBreakpoint(
      PagebuilderResponsiveBreakpoint breakpoint, AppLocalizations localization) {
    switch (breakpoint) {
      case PagebuilderResponsiveBreakpoint.mobile:
        return localization.pagebuilder_breakpoint_mobile;
      case PagebuilderResponsiveBreakpoint.tablet:
        return localization.pagebuilder_breakpoint_tablet;
      case PagebuilderResponsiveBreakpoint.desktop:
        return localization.pagebuilder_breakpoint_desktop;
    }
  }
}
