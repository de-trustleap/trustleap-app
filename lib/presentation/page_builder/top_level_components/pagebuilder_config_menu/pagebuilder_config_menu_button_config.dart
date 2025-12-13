import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_border.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_paint.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_picker/pagebuilder_color_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_hover_config_tabbar.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_responsive_config_helper.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_size_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_text_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuButtonConfig extends StatelessWidget {
  final PageBuilderButtonProperties? properties;
  final PageBuilderButtonProperties? hoverProperties;
  final Function(PageBuilderButtonProperties?) onChanged;
  final Function(PageBuilderButtonProperties?) onChangedHover;
  final PageBuilderGlobalStyles? globalStyles;

  const PagebuilderConfigMenuButtonConfig({
    super.key,
    required this.properties,
    this.hoverProperties,
    required this.onChanged,
    required this.onChangedHover,
    this.globalStyles,
  });

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
    return BlocBuilder<PagebuilderResponsiveBreakpointCubit,
        PagebuilderResponsiveBreakpoint>(
      bloc: Modular.get<PagebuilderResponsiveBreakpointCubit>(),
      builder: (context, currentBreakpoint) {
        final helper = PagebuilderResponsiveConfigHelper(currentBreakpoint);

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          PagebuilderSizeControl(
              width: helper.getValue(props?.width) ?? 0,
              height: helper.getValue(props?.height) ?? 0,
              currentBreakpoint: currentBreakpoint,
              onChanged: (size) {
                final updatedWidth = helper.setValue(props?.width, size.width);
                final updatedHeight =
                    helper.setValue(props?.height, size.height);
                onChangedLocal(props?.copyWith(
                    width: updatedWidth, height: updatedHeight));
              }),
          const SizedBox(height: 20),
          PagebuilderColorControl(
              title: localization
                  .pagebuilder_button_config_button_background_color,
              initialColor: props?.backgroundPaint?.color ?? Colors.transparent,
              initialGradient: props?.backgroundPaint?.gradient,
              globalColors: globalStyles?.colors,
              selectedGlobalColorToken: props?.backgroundPaint?.globalColorToken,
              onColorSelected: (color, {token}) {
                final paint = PagebuilderPaint.color(color, globalColorToken: token);
                onChangedLocal(props?.copyWith(backgroundPaint: paint));
              },
              onGradientSelected: (gradient) {
                final paint = PagebuilderPaint.gradient(gradient);
                onChangedLocal(props?.copyWith(backgroundPaint: paint));
              }),
          const SizedBox(height: 30),
          Text(
            localization.pagebuilder_button_config_button_border_title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          PagebuilderNumberStepperControl(
              title:
                  localization.pagebuilder_button_config_button_border_radius,
              initialValue: props?.border?.radius?.toInt() ?? 0,
              minValue: 0,
              maxValue: 1000,
              onSelected: (radius) {
                final newBorder = (props?.border ?? const PagebuilderBorder(width: null, radius: null, color: null))
                    .copyWith(radius: radius.toDouble());
                onChangedLocal(props?.copyWith(border: newBorder));
              }),
          const SizedBox(height: 20),
          PagebuilderNumberStepperControl(
              title:
                  localization.pagebuilder_button_config_button_border_width,
              initialValue: props?.border?.width?.toInt() ?? 0,
              minValue: 0,
              maxValue: 100,
              onSelected: (width) {
                final newBorder = (props?.border ?? const PagebuilderBorder(width: null, radius: null, color: null))
                    .copyWith(width: width.toDouble());
                onChangedLocal(props?.copyWith(border: newBorder));
              }),
          const SizedBox(height: 20),
          PagebuilderColorControl(
              title: localization.pagebuilder_button_config_button_border_color,
              initialColor: props?.border?.color ?? Colors.transparent,
              globalColors: globalStyles?.colors,
              selectedGlobalColorToken: props?.border?.globalColorToken,
              onColorSelected: (color, {token}) {
                final newBorder = (props?.border ?? const PagebuilderBorder(width: null, radius: null, color: null, globalColorToken: null))
                    .copyWith(color: color, globalColorToken: token);
                onChangedLocal(props?.copyWith(border: newBorder));
              },
              onGradientSelected: null),
          const SizedBox(height: 40),
          Text(localization.pagebuilder_button_config_button_text_configuration,
              style: themeData.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          PagebuilderConfigMenuTextConfig(
              properties: props?.textProperties,
              hoverProperties: hoverProperties?.textProperties,
              showHoverTabBar: false,
              globalStyles: globalStyles,
              onChanged: (textProperties) {
                onChangedLocal(props?.copyWith(textProperties: textProperties));
              },
              onChangedHover: (textProperties) {
                onChangedLocal(props?.copyWith(textProperties: textProperties));
              }),
        ]);
      },
    );
  }
}
