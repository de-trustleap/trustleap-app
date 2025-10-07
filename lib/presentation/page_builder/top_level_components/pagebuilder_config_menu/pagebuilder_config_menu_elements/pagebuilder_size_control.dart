import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_breakpoint_selector.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper.dart';
import 'package:flutter/material.dart';

class PagebuilderSizeControl extends StatelessWidget {
  final double width;
  final double height;
  final Function(Size) onChanged;
  final PagebuilderResponsiveBreakpoint currentBreakpoint;

  const PagebuilderSizeControl({
    super.key,
    required this.width,
    required this.height,
    required this.onChanged,
    required this.currentBreakpoint,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    return Row(children: [
      Text(localization.pagebuilder_layout_menu_size_control_size,
          style: themeData.textTheme.bodySmall),
      const SizedBox(width: 8),
      PagebuilderBreakpointSelector(
        currentBreakpoint: currentBreakpoint,
      ),
      const SizedBox(width: 8),
      const Spacer(),
      PagebuilderNumberStepper(
          initialValue: width.toInt(),
          minValue: 0,
          maxValue: 3000,
          placeholder: localization.pagebuilder_layout_menu_size_control_width,
          onSelected: (width) {
            final Size size = Size(width.toDouble(), height);
            onChanged(size);
          }),
      const SizedBox(width: 20),
      PagebuilderNumberStepper(
          initialValue: height.toInt(),
          minValue: 0,
          maxValue: 3000,
          placeholder: localization.pagebuilder_layout_menu_size_control_height,
          onSelected: (height) {
            final Size size = Size(width, height.toDouble());
            onChanged(size);
          }),
    ]);
  }
}
