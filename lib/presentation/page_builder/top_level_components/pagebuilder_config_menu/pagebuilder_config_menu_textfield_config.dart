import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_textfield_properties.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_hover_config_tabbar.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_switch_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_textfield.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_text_config.dart';
import 'package:flutter/material.dart';

class PagebuilderConfigMenuTextfieldConfig extends StatelessWidget {
  final PageBuilderTextFieldProperties? properties;
  final PageBuilderTextFieldProperties? hoverProperties;
  final Function(PageBuilderTextFieldProperties?) onChanged;
  final Function(PageBuilderTextFieldProperties?) onChangedHover;
  const PagebuilderConfigMenuTextfieldConfig(
      {super.key,
      required this.properties,
      this.hoverProperties,
      required this.onChanged,
      required this.onChangedHover});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    if (properties != null) {
      return PagebuilderHoverConfigTabBar<PageBuilderTextFieldProperties>(
        properties: properties!,
        hoverProperties: hoverProperties,
        hoverEnabled: hoverProperties != null,
        onHoverEnabledChanged: (enabled) {
          if (enabled) {
            onChangedHover(properties?.deepCopy());
          } else {
            onChangedHover(null);
          }
        },
        onChanged: (updated, isHover) {
          if (isHover) {
            onChangedHover(updated);
          } else {
            onChanged(updated);
          }
        },
        configBuilder: (props, disabled, onChangedLocal) => _buildConfigUI(
            props, disabled, themeData, localization, onChangedLocal),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildConfigUI(
      PageBuilderTextFieldProperties? props,
      bool disabled,
      ThemeData themeData,
      AppLocalizations localization,
      Function(PageBuilderTextFieldProperties?) onChangedLocal) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      PagebuilderNumberStepperControl(
          title: localization.pagebuilder_textfield_config_textfield_width,
          initialValue: props?.width?.toInt() ?? 0,
          minValue: 0,
          maxValue: 1000,
          onSelected: (width) {
            onChangedLocal(props?.copyWith(width: width.toDouble()));
          }),
      const SizedBox(height: 20),
      PagebuilderNumberStepperControl(
          title: localization.pagebuilder_textfield_config_textfield_min_lines,
          initialValue: props?.minLines ?? 1,
          minValue: 1,
          maxValue: 1000,
          onSelected: (minLines) {
            onChangedLocal(props?.copyWith(minLines: minLines));
          }),
      const SizedBox(height: 20),
      PagebuilderNumberStepperControl(
          title: localization.pagebuilder_textfield_config_textfield_max_lines,
          initialValue: props?.maxLines ?? 1,
          minValue: props?.minLines ?? 1,
          maxValue: 1000,
          onSelected: (maxLines) {
            onChangedLocal(props?.copyWith(maxLines: maxLines));
          }),
      const SizedBox(height: 20),
      PagebuilderSwitchControl(
          title: localization.pagebuilder_textfield_config_textfield_required,
          isActive: props?.isRequired ?? false,
          onSelected: (isRequired) {
            onChangedLocal(props?.copyWith(isRequired: isRequired));
          }),
      const SizedBox(height: 20),
      PagebuilderColorControl(
          title: localization
              .pagebuilder_textfield_config_textfield_background_color,
          initialColor: props?.backgroundColor ?? Colors.transparent,
          onSelected: (backgroundColor) {
            onChangedLocal(props?.copyWith(backgroundColor: backgroundColor));
          }),
      const SizedBox(height: 20),
      PagebuilderColorControl(
          title:
              localization.pagebuilder_textfield_config_textfield_border_color,
          initialColor: props?.borderColor ?? Colors.transparent,
          onSelected: (borderColor) {
            onChangedLocal(props?.copyWith(borderColor: borderColor));
          }),
      const SizedBox(height: 20),
      PagebuilderTextField(
          initialText: props?.placeHolderTextProperties?.text,
          minLines: props?.minLines ?? 1,
          maxLines: props?.maxLines ?? (props?.minLines ?? 1),
          placeholder:
              localization.pagebuilder_textfield_config_textfield_placeholder,
          onChanged: (placeholder) {
            final updatedPlaceholderProperties =
                props?.placeHolderTextProperties?.copyWith(text: placeholder);
            onChangedLocal(props?.copyWith(
                placeHolderTextProperties: updatedPlaceholderProperties));
          }),
      const SizedBox(height: 40),
      Text(
          localization
              .pagebuilder_textfield_config_textfield_text_configuration,
          style: themeData.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      PagebuilderConfigMenuTextConfig(
          properties: props?.textProperties,
          hoverProperties: hoverProperties?.textProperties,
          showHoverTabBar: false,
          onChanged: (textProperties) {
            onChangedLocal(props?.copyWith(textProperties: textProperties));
          },
          onChangedHover: (textProperties) {
            onChangedLocal(props?.copyWith(textProperties: textProperties));
          }),
      const SizedBox(height: 40),
      Text(
          localization
              .pagebuilder_textfield_config_textfield_placeholder_text_configuration,
          style: themeData.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      PagebuilderConfigMenuTextConfig(
          properties: props?.placeHolderTextProperties,
          hoverProperties: hoverProperties?.placeHolderTextProperties,
          showHoverTabBar: false,
          onChanged: (placeholderProperties) {
            onChangedLocal(props?.copyWith(
                placeHolderTextProperties: placeholderProperties));
          },
          onChangedHover: (placeholderProperties) {
            onChangedLocal(props?.copyWith(
                placeHolderTextProperties: placeholderProperties));
          }),
    ]);
  }
}
// TODO: HOVER TABBAR FÜR VERSCHACHTELTE PROPERTIES AUSBLENDEN! (FERTIG)
// TODO: GRÖ?ENBERECHNUNG FÜR HOVER TAB FIXEN WENN DER SWITCH ABGESCHALTET IST!
