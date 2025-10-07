import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_breakpoint_selector.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper.dart';
import 'package:flutter/material.dart';

class PagebuilderNumberStepperControl extends StatelessWidget {
  final String title;
  final int initialValue;
  final int minValue;
  final int maxValue;
  final Function(int) onSelected;
  final bool bigNumbers;
  final bool showResponsiveButton;
  final PagebuilderResponsiveBreakpoint? currentBreakpoint;

  const PagebuilderNumberStepperControl({
    super.key,
    required this.title,
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
    required this.onSelected,
    this.bigNumbers = false,
    this.showResponsiveButton = false,
    this.currentBreakpoint,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: themeData.textTheme.bodySmall),
          if (showResponsiveButton && currentBreakpoint != null) ...[
            const SizedBox(width: 8),
            PagebuilderBreakpointSelector(
              currentBreakpoint: currentBreakpoint!,
            ),
          ],
          const Spacer(),
          PagebuilderNumberStepper(
              initialValue: initialValue,
              minValue: minValue,
              maxValue: maxValue,
              onSelected: onSelected,
              bigNumbers: bigNumbers)
        ]);
  }
}
