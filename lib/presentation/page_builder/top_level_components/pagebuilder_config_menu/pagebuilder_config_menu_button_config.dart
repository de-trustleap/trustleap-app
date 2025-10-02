import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_paint.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_hover_config_tabbar.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_text_config.dart';
import 'package:flutter/material.dart';

class PagebuilderConfigMenuButtonConfig extends StatelessWidget {
  final PageBuilderButtonProperties? properties;
  final PageBuilderButtonProperties? hoverProperties;
  final Function(PageBuilderButtonProperties?) onChanged;
  final Function(PageBuilderButtonProperties?) onChangedHover;
  const PagebuilderConfigMenuButtonConfig(
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
      return PagebuilderHoverConfigTabBar<PageBuilderButtonProperties>(
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
      PageBuilderButtonProperties? props,
      bool disabled,
      ThemeData themeData,
      AppLocalizations localization,
      Function(PageBuilderButtonProperties?) onChangedLocal) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      PagebuilderNumberStepperControl(
          title: localization.pagebuilder_button_config_button_width,
          initialValue: props?.width?.toInt() ?? 0,
          minValue: 0,
          maxValue: 1000,
          onSelected: (width) {
            onChangedLocal(props?.copyWith(width: width.toDouble()));
          }),
      const SizedBox(height: 20),
      PagebuilderNumberStepperControl(
          title: localization.pagebuilder_button_config_button_height,
          initialValue: props?.height?.toInt() ?? 0,
          minValue: 0,
          maxValue: 1000,
          onSelected: (height) {
            onChangedLocal(props?.copyWith(height: height.toDouble()));
          }),
      const SizedBox(height: 20),
      PagebuilderNumberStepperControl(
          title: localization.pagebuilder_button_config_button_border_radius,
          initialValue: props?.borderRadius?.toInt() ?? 0,
          minValue: 0,
          maxValue: 1000,
          onSelected: (borderRadius) {
            onChangedLocal(
                props?.copyWith(borderRadius: borderRadius.toDouble()));
          }),
      const SizedBox(height: 20),
      PagebuilderColorControl(
          title: localization.pagebuilder_button_config_button_background_color,
          initialColor: props?.backgroundPaint?.color ?? Colors.transparent,
          initialGradient: props?.backgroundPaint?.gradient,
          onColorSelected: (color) {
            final paint = PagebuilderPaint.color(color);
            onChangedLocal(props?.copyWith(backgroundPaint: paint));
          },
          onGradientSelected: (gradient) {
            final paint = PagebuilderPaint.gradient(gradient);
            onChangedLocal(props?.copyWith(backgroundPaint: paint));
          }),
      const SizedBox(height: 40),
      Text(localization.pagebuilder_button_config_button_text_configuration,
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
    ]);
  }
}
