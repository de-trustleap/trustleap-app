import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_breakpoint_selector.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_font_family_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_hover_config_tabbar.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_dropdown.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_responsive_config_helper.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_shadow_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_text_alignment_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuTextConfig extends StatefulWidget {
  final PageBuilderTextProperties? properties;
  final PageBuilderTextProperties? hoverProperties;
  final bool showHoverTabBar;
  final bool hideColorPicker;
  final Function(PageBuilderTextProperties?) onChanged;
  final Function(PageBuilderTextProperties?) onChangedHover;

  const PagebuilderConfigMenuTextConfig({
    super.key,
    required this.properties,
    this.hoverProperties,
    this.showHoverTabBar = true,
    this.hideColorPicker = false,
    required this.onChanged,
    required this.onChangedHover,
  });

  @override
  State<PagebuilderConfigMenuTextConfig> createState() =>
      _PagebuilderConfigMenuTextConfigState();
}

class _PagebuilderConfigMenuTextConfigState
    extends State<PagebuilderConfigMenuTextConfig> {
  @override
  Widget build(BuildContext context) {
    final breakpointCubit = Modular.get<PagebuilderResponsiveBreakpointCubit>();
    final localization = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    return BlocBuilder<PagebuilderResponsiveBreakpointCubit,
        PagebuilderResponsiveBreakpoint>(
      bloc: breakpointCubit,
      builder: (context, currentBreakpoint) {
        final helper = PagebuilderResponsiveConfigHelper(currentBreakpoint);

        if (widget.properties != null) {
          if (!widget.showHoverTabBar) {
            return _buildConfigUI(widget.properties!, false, themeData,
                localization, widget.onChanged, helper, currentBreakpoint);
          }

          return PagebuilderHoverConfigTabBar<PageBuilderTextProperties>(
            properties: widget.properties!,
            hoverProperties: widget.hoverProperties,
            hoverEnabled: widget.hoverProperties != null,
            onHoverEnabledChanged: (enabled) {
              if (enabled) {
                widget.onChangedHover(widget.properties?.deepCopy());
              } else {
                widget.onChangedHover(null);
              }
            },
            onChanged: (updated, isHover) {
              if (isHover) {
                widget.onChangedHover(updated);
              } else {
                widget.onChanged(updated);
              }
            },
            configBuilder: (props, disabled, onChangedLocal) => _buildConfigUI(
                props,
                disabled,
                themeData,
                localization,
                onChangedLocal,
                helper,
                currentBreakpoint),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildConfigUI(
      PageBuilderTextProperties? props,
      bool disabled,
      ThemeData themeData,
      AppLocalizations localization,
      Function(PageBuilderTextProperties?) onChangedLocal,
      PagebuilderResponsiveConfigHelper helper,
      PagebuilderResponsiveBreakpoint currentBreakpoint) {
    if (disabled) {
      return const SizedBox.shrink();
    } else {
      return Column(children: [
        PagebuilderTextAlignmentControl(
            initialAlignment:
                helper.getValue(props?.alignment) ?? TextAlign.center,
            onSelected: (alignment) {
              onChangedLocal(props?.copyWith(
                  alignment: helper.setValue(props.alignment, alignment)));
            },
            currentBreakpoint: currentBreakpoint),
        if (!widget.hideColorPicker) ...[
          const SizedBox(height: 20),
          PagebuilderColorControl(
              title: localization.landingpage_pagebuilder_text_config_color,
              initialColor: props?.color ?? Colors.black,
              enableGradients: false,
              onColorSelected: (color) {
                onChangedLocal(props?.copyWith(color: color));
              }),
        ],
        const SizedBox(height: 20),
        PagebuilderFontFamilyControl(
            initialValue: props?.fontFamily ?? "",
            onSelected: (fontFamily) {
              onChangedLocal(props?.copyWith(fontFamily: fontFamily));
            }),
        const SizedBox(height: 20),
        Row(children: [
          Text(localization.landingpage_pagebuilder_text_config_fontsize,
              style: themeData.textTheme.bodySmall),
          const SizedBox(width: 8),
          PagebuilderBreakpointSelector(
            currentBreakpoint: currentBreakpoint,
          ),
          const Spacer(),
          PagebuilderNumberStepper(
              initialValue: helper.getValue(props?.fontSize)?.round() ?? 0,
              minValue: 0,
              maxValue: 1000,
              onSelected: (fontSize) {
                onChangedLocal(props?.copyWith(
                    fontSize:
                        helper.setValue(props.fontSize, fontSize.toDouble())));
              }),
        ]),
        const SizedBox(height: 20),
        PagebuilderNumberDropdown(
            title: localization.landingpage_pagebuilder_text_config_lineheight,
            initialValue: helper.getValue(props?.lineHeight) ?? 1.0,
            numbers: List.generate(
                31, (index) => double.parse((index * 0.1).toStringAsFixed(1))),
            onSelected: (lineHeight) {
              onChangedLocal(props?.copyWith(
                  lineHeight: helper.setValue(props.lineHeight, lineHeight)));
            },
            currentBreakpoint: currentBreakpoint),
        const SizedBox(height: 20),
        PagebuilderNumberDropdown(
            title:
                localization.landingpage_pagebuilder_text_config_letterspacing,
            initialValue: helper.getValue(props?.letterSpacing) ?? 1.0,
            numbers: List.generate(
                31, (index) => double.parse((index * 0.1).toStringAsFixed(1))),
            onSelected: (letterSpacing) {
              onChangedLocal(props?.copyWith(
                  letterSpacing:
                      helper.setValue(props.letterSpacing, letterSpacing)));
            },
            currentBreakpoint: currentBreakpoint),
        const SizedBox(height: 20),
        PagebuilderShadowControl(
            title: localization.landingpage_pagebuilder_text_config_shadow,
            initialShadow: props?.textShadow,
            showSpreadRadius: false,
            onSelected: (shadow) {
              onChangedLocal(props?.copyWith(textShadow: shadow));
            })
      ]);
    }
  }
}
