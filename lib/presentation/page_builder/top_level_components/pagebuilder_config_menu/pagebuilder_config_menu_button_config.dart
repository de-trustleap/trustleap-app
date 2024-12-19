import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_button_properties.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_text_config.dart';
import 'package:flutter/material.dart';

class PagebuilderConfigMenuButtonConfig extends StatelessWidget {
  final PageBuilderButtonProperties? properties;
  final Function(PageBuilderButtonProperties?) onChanged;
  const PagebuilderConfigMenuButtonConfig(
      {super.key, required this.properties, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      PagebuilderNumberStepperControl(
          title: localization.pagebuilder_button_config_button_width,
          initialValue: properties?.width?.toInt() ?? 0,
          minValue: 0,
          maxValue: 1000,
          onSelected: (width) {
            onChanged(properties?.copyWith(width: width.toDouble()));
          }),
      const SizedBox(height: 20),
      PagebuilderNumberStepperControl(
          title: localization.pagebuilder_button_config_button_height,
          initialValue: properties?.height?.toInt() ?? 0,
          minValue: 0,
          maxValue: 1000,
          onSelected: (height) {
            onChanged(properties?.copyWith(height: height.toDouble()));
          }),
      const SizedBox(height: 20),
      PagebuilderNumberStepperControl(
          title: localization.pagebuilder_button_config_button_border_radius,
          initialValue: properties?.borderRadius?.toInt() ?? 0,
          minValue: 0,
          maxValue: 1000,
          onSelected: (borderRadius) {
            onChanged(
                properties?.copyWith(borderRadius: borderRadius.toDouble()));
          }),
      const SizedBox(height: 20),
      PagebuilderColorControl(
          title: localization.pagebuilder_button_config_button_background_color,
          initialColor: properties?.backgroundColor ?? Colors.transparent,
          onSelected: (color) {
            onChanged(properties?.copyWith(backgroundColor: color));
          }),
      const SizedBox(height: 40),
      Text(localization.pagebuilder_button_config_button_text_configuration,
          style: themeData.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      PagebuilderConfigMenuTextConfig(
          properties: properties?.textProperties,
          onChanged: (textProperties) {
            onChanged(properties?.copyWith(textProperties: textProperties));
          }),
    ]);
  }
}
