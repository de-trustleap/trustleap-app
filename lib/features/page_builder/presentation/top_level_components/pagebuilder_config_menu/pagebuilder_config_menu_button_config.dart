import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_border.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_button_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_paint.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_spacing.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_picker/pagebuilder_color_control.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_hover_config_tabbar.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_breakpoint_selector.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper_control.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_responsive_config_helper.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_size_control.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_spacing_control.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_text_config.dart';
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

  PagebuilderButtonSizeMode _getSizeMode(
      PageBuilderButtonProperties? props,
      PagebuilderResponsiveConfigHelper helper) {
    final mode = helper.getValue(props?.sizeMode);
    if (mode != null) return mode;
    // Fallback for old data without sizeMode
    if (props?.width != null) return PagebuilderButtonSizeMode.fixed;
    if (props?.minWidthPercent != null) return PagebuilderButtonSizeMode.minWidth;
    return PagebuilderButtonSizeMode.auto;
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
        final sizeMode = _getSizeMode(props, helper);

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Size mode radio buttons
          Row(
            children: [
              Text(localization.pagebuilder_button_config_auto_width,
                  style: themeData.textTheme.bodySmall),
              const SizedBox(width: 8),
              PagebuilderBreakpointSelector(
                currentBreakpoint: currentBreakpoint,
              ),
            ],
          ),
          const SizedBox(height: 8),
          RadioGroup<PagebuilderButtonSizeMode>(
            groupValue: sizeMode,
            onChanged: (value) {
              if (value == null) return;
              final updatedSizeMode = helper.setValue(props?.sizeMode, value);
              var updated = props?.copyWith(sizeMode: updatedSizeMode);
              // Set defaults if fields don't have values yet
              if (value == PagebuilderButtonSizeMode.minWidth &&
                  helper.getValue(props?.minWidthPercent) == null) {
                updated = updated?.copyWith(
                    minWidthPercent: helper.setValue(null, 0.5));
              }
              if (value == PagebuilderButtonSizeMode.fixed) {
                if (helper.getValue(props?.width) == null) {
                  updated = updated?.copyWith(
                      width: helper.setValue(null, 200.0));
                }
                if (helper.getValue(props?.height) == null) {
                  updated = updated?.copyWith(
                      height: helper.setValue(null, 50.0));
                }
              }
              onChangedLocal(updated);
            },
            child: Column(
              children: [
                RadioListTile<PagebuilderButtonSizeMode>(
                  title: Text(localization.pagebuilder_button_config_auto_width),
                  value: PagebuilderButtonSizeMode.auto,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
                RadioListTile<PagebuilderButtonSizeMode>(
                  title: Text(localization.pagebuilder_button_config_min_width),
                  value: PagebuilderButtonSizeMode.minWidth,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
                RadioListTile<PagebuilderButtonSizeMode>(
                  title: Text(localization.pagebuilder_button_config_fixed_width),
                  value: PagebuilderButtonSizeMode.fixed,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Mode-specific controls
          if (sizeMode == PagebuilderButtonSizeMode.minWidth) ...[
            Row(
              children: [
                Text(localization.pagebuilder_button_config_min_width,
                    style: themeData.textTheme.bodySmall),
                const SizedBox(width: 8),
                PagebuilderBreakpointSelector(
                  currentBreakpoint: currentBreakpoint,
                ),
                const Spacer(),
                PagebuilderNumberStepper(
                  initialValue:
                      ((helper.getValue(props?.minWidthPercent) ?? 0.5) * 100)
                          .toInt(),
                  minValue: 0,
                  maxValue: 100,
                  placeholder: '%',
                  onSelected: (percent) {
                    final updatedMinWidth = helper.setValue(
                        props?.minWidthPercent, percent / 100.0);
                    onChangedLocal(
                        props?.copyWith(minWidthPercent: updatedMinWidth));
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
          if (sizeMode == PagebuilderButtonSizeMode.fixed) ...[
            PagebuilderSizeControl(
                width: helper.getValue(props?.width) ?? 0,
                height: helper.getValue(props?.height) ?? 0,
                currentBreakpoint: currentBreakpoint,
                onChanged: (size) {
                  final updatedWidth =
                      helper.setValue(props?.width, size.width);
                  final updatedHeight =
                      helper.setValue(props?.height, size.height);
                  onChangedLocal(props?.copyWith(
                      width: updatedWidth, height: updatedHeight));
                }),
            const SizedBox(height: 10),
          ],

          // Content Padding
          _buildContentPaddingControl(
              props, helper, themeData, localization, onChangedLocal,
              currentBreakpoint),
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

  Widget _buildContentPaddingControl(
      PageBuilderButtonProperties? props,
      PagebuilderResponsiveConfigHelper helper,
      ThemeData themeData,
      AppLocalizations localization,
      Function(PageBuilderButtonProperties?) onChangedLocal,
      PagebuilderResponsiveBreakpoint currentBreakpoint) {
    void updatePadding(PageBuilderSpacingDirection direction, double value) {
      final spacing = props?.contentPadding ??
          const PageBuilderSpacing(
              top: PagebuilderResponsiveOrConstant.constant(0.0),
              bottom: PagebuilderResponsiveOrConstant.constant(0.0),
              left: PagebuilderResponsiveOrConstant.constant(0.0),
              right: PagebuilderResponsiveOrConstant.constant(0.0));
      final updatedSpacing = spacing.copyWith(
        top: direction == PageBuilderSpacingDirection.top
            ? helper.setValue(spacing.top, value)
            : spacing.top,
        left: direction == PageBuilderSpacingDirection.left
            ? helper.setValue(spacing.left, value)
            : spacing.left,
        bottom: direction == PageBuilderSpacingDirection.bottom
            ? helper.setValue(spacing.bottom, value)
            : spacing.bottom,
        right: direction == PageBuilderSpacingDirection.right
            ? helper.setValue(spacing.right, value)
            : spacing.right,
      );
      onChangedLocal(props?.copyWith(contentPadding: updatedSpacing));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(localization.pagebuilder_button_config_content_padding,
                style: themeData.textTheme.bodySmall),
            const SizedBox(width: 8),
            PagebuilderBreakpointSelector(
              currentBreakpoint: currentBreakpoint,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            PagebuilderNumberStepper(
              initialValue:
                  (helper.getValue(props?.contentPadding?.top) ?? 0).toInt(),
              minValue: 0,
              maxValue: 1000,
              placeholder:
                  localization.landingpage_pagebuilder_layout_spacing_top,
              onSelected: (value) =>
                  updatePadding(PageBuilderSpacingDirection.top, value.toDouble()),
            ),
            const SizedBox(width: 40),
            PagebuilderNumberStepper(
              initialValue:
                  (helper.getValue(props?.contentPadding?.left) ?? 0).toInt(),
              minValue: 0,
              maxValue: 1000,
              placeholder:
                  localization.landingpage_pagebuilder_layout_spacing_left,
              onSelected: (value) =>
                  updatePadding(PageBuilderSpacingDirection.left, value.toDouble()),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            PagebuilderNumberStepper(
              initialValue:
                  (helper.getValue(props?.contentPadding?.bottom) ?? 0).toInt(),
              minValue: 0,
              maxValue: 1000,
              placeholder:
                  localization.landingpage_pagebuilder_layout_spacing_bottom,
              onSelected: (value) => updatePadding(
                  PageBuilderSpacingDirection.bottom, value.toDouble()),
            ),
            const SizedBox(width: 40),
            PagebuilderNumberStepper(
              initialValue:
                  (helper.getValue(props?.contentPadding?.right) ?? 0).toInt(),
              minValue: 0,
              maxValue: 1000,
              placeholder:
                  localization.landingpage_pagebuilder_layout_spacing_right,
              onSelected: (value) => updatePadding(
                  PageBuilderSpacingDirection.right, value.toDouble()),
            ),
          ],
        ),
      ],
    );
  }
}
