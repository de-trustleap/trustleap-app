import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_textfield_properties.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_switch_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_textfield.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_text_config.dart';
import 'package:flutter/material.dart';

class PagebuilderConfigMenuTextfieldConfig extends StatelessWidget {
  final PageBuilderTextFieldProperties? properties;
  final Function(PageBuilderTextFieldProperties?) onChanged;
  const PagebuilderConfigMenuTextfieldConfig(
      {super.key, required this.properties, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      PagebuilderNumberStepperControl(
          title: "Breite",
          initialValue: properties?.width?.toInt() ?? 0,
          minValue: 0,
          maxValue: 1000,
          onSelected: (width) {
            onChanged(properties?.copyWith(width: width.toDouble()));
          }),
      const SizedBox(height: 20),
      PagebuilderNumberStepperControl(
          title: "Zeilenanzahl Minimum",
          initialValue: properties?.minLines ?? 1,
          minValue: 1,
          maxValue: 1000,
          onSelected: (minLines) {
            onChanged(properties?.copyWith(minLines: minLines));
          }),
      const SizedBox(height: 20),
      PagebuilderNumberStepperControl(
          title: "Zeilenanzahl Maximum",
          initialValue: properties?.maxLines ?? 1,
          minValue: properties?.minLines ?? 1,
          maxValue: 1000,
          onSelected: (maxLines) {
            onChanged(properties?.copyWith(maxLines: maxLines));
          }),
      const SizedBox(height: 20),
      PagebuilderSwitchControl(
          title: "Pflichtfeld",
          isActive: properties?.isRequired ?? false,
          onSelected: (isRequired) {
            onChanged(properties?.copyWith(isRequired: isRequired));
          }),
      const SizedBox(height: 20),
      PagebuilderColorControl(
          title: "Hintergrundfarbe",
          initialColor: properties?.backgroundColor ?? Colors.transparent,
          onSelected: (backgroundColor) {
            onChanged(properties?.copyWith(backgroundColor: backgroundColor));
          }),
      const SizedBox(height: 20),
      PagebuilderColorControl(
          title: "Rahmenfarbe",
          initialColor: properties?.borderColor ?? Colors.transparent,
          onSelected: (borderColor) {
            onChanged(properties?.copyWith(borderColor: borderColor));
          }),
      const SizedBox(height: 20),
      PagebuilderTextField(
          initialText: properties?.placeHolderTextProperties?.text,
          minLines: properties?.minLines ?? 1,
          maxLines: properties?.maxLines ?? (properties?.minLines ?? 1),
          placeholder: "Platzhalter",
          onChanged: (placeholder) {
            final updatedPlaceholderProperties = properties
                ?.placeHolderTextProperties
                ?.copyWith(text: placeholder);
            onChanged(properties?.copyWith(
                placeHolderTextProperties: updatedPlaceholderProperties));
          }),
      const SizedBox(height: 40),
      Text("Textfeld Text Konfiguration",
          style: themeData.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      PagebuilderConfigMenuTextConfig(
          properties: properties?.textProperties,
          onChanged: (textProperties) {
            onChanged(properties?.copyWith(textProperties: textProperties));
          }),
      const SizedBox(height: 40),
      Text("Textfeld Platzhalter Konfiguration",
          style: themeData.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      PagebuilderConfigMenuTextConfig(
          properties: properties?.placeHolderTextProperties,
          onChanged: (placeholderProperties) {
            onChanged(properties?.copyWith(
                placeHolderTextProperties: placeholderProperties));
          }),
    ]);
  }
}