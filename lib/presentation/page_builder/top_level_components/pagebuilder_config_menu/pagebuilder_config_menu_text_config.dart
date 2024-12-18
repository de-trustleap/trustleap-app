import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_font_family_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_dropdown.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_shadow_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_text_alignment_control.dart';
import 'package:flutter/material.dart';

class PagebuilderConfigMenuTextConfig extends StatelessWidget {
  final PageBuilderTextProperties? properties;
  final Function(PageBuilderTextProperties?) onChanged;
  const PagebuilderConfigMenuTextConfig({super.key, required this.properties, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    return Column(children: [
      PagebuilderTextAlignmentControl(
          initialAlignment:
              properties?.alignment ??
                  TextAlign.center,
          onSelected: (alignment) {
            onChanged(properties?.copyWith(alignment: alignment));
          }),
      const SizedBox(height: 20),
      PagebuilderColorControl(
          title: localization.landingpage_pagebuilder_text_config_color,
          initialColor: properties?.color ??
              Colors.black,
          onSelected: (color) {
            onChanged(properties?.copyWith(color: color));
          }),
      const SizedBox(height: 20),
      PagebuilderFontFamilyControl(
          initialValue:
              properties?.fontFamily ?? "",
          onSelected: (fontFamily) {
            onChanged(properties?.copyWith(fontFamily: fontFamily));
          }),
      const SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(localization.landingpage_pagebuilder_text_config_fontsize,
            style: themeData.textTheme.bodySmall),
        PagebuilderNumberStepper(
            initialValue: properties?.fontSize?.round() ?? 0,
            minValue: 0,
            maxValue: 1000,
            onSelected: (fontSize) {
              onChanged(properties?.copyWith(fontSize: fontSize.toDouble()));
            }),
      ]),
      const SizedBox(height: 20),
      PagebuilderNumberDropdown(
          title: localization.landingpage_pagebuilder_text_config_lineheight,
          initialValue:
             properties?.lineHeight ?? 1.0,
          numbers: List.generate(
              31, (index) => double.parse((index * 0.1).toStringAsFixed(1))),
          onSelected: (lineHeight) {
            onChanged(properties?.copyWith(lineHeight: lineHeight));
          }),
      const SizedBox(height: 20),
      PagebuilderNumberDropdown(
          title: localization.landingpage_pagebuilder_text_config_letterspacing,
          initialValue:
              properties?.letterSpacing ??
                  1.0,
          numbers: List.generate(
              31, (index) => double.parse((index * 0.1).toStringAsFixed(1))),
          onSelected: (letterSpacing) {
            onChanged(properties?.copyWith(letterSpacing: letterSpacing));
          }),
      const SizedBox(height: 20),
      PagebuilderShadowControl(
          title: localization.landingpage_pagebuilder_text_config_shadow,
          initialShadow:
              properties?.textShadow,
          showSpreadRadius: false,
          onSelected: (shadow) {
            onChanged(properties?.copyWith(textShadow: shadow));
          })
    ]);
  }
}
