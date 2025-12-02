import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_breakpoint_selector.dart';
import 'package:flutter/material.dart';

class PagebuilderSwitchControl extends StatelessWidget {
  final String title;
  final bool isActive;
  final Function(bool) onSelected;
  final bool showResponsiveButton;
  final PagebuilderResponsiveBreakpoint? currentBreakpoint;

  const PagebuilderSwitchControl({
    super.key,
    required this.title,
    required this.isActive,
    required this.onSelected,
    this.showResponsiveButton = false,
    this.currentBreakpoint,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: themeData.textTheme.bodySmall),
        if (showResponsiveButton && currentBreakpoint != null) ...[
          const SizedBox(width: 8),
          PagebuilderBreakpointSelector(
            currentBreakpoint: currentBreakpoint!,
          ),
        ],
        const Spacer(),
        Switch(
          value: isActive,
          onChanged: (isSelected) => onSelected(isSelected),
        )
      ],
    );
  }
}
