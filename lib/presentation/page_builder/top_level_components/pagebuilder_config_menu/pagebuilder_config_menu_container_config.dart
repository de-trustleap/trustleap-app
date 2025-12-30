import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_border.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_container_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_colors.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_picker/pagebuilder_color_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_hover_config_tabbar.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_responsive_config_helper.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_shadow_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_size_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuContainerConfig extends StatelessWidget {
  final PageBuilderWidget model;
  final PageBuilderGlobalColors? globalColors;
  const PagebuilderConfigMenuContainerConfig({super.key, required this.model, this.globalColors});

  @override
  Widget build(BuildContext context) {
    final pagebuilderBloc = Modular.get<PagebuilderBloc>();
    final localization = AppLocalizations.of(context);

    if (model.elementType == PageBuilderWidgetType.container &&
        model.properties is PageBuilderContainerProperties) {
      return CollapsibleTile(
          title: localization
              .landingpage_pagebuilder_container_config_container_title,
          children: [
            PagebuilderHoverConfigTabBar<PageBuilderContainerProperties>(
              properties: model.properties as PageBuilderContainerProperties,
              hoverProperties: model.hoverProperties != null
                  ? model.hoverProperties as PageBuilderContainerProperties
                  : null,
              hoverEnabled: model.hoverProperties != null,
              onHoverEnabledChanged: (enabled) {
                if (enabled) {
                  final hoverProperties =
                      (model.properties as PageBuilderContainerProperties)
                          .deepCopy();
                  final updatedWidget =
                      model.copyWith(hoverProperties: hoverProperties);
                  pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                } else {
                  final updatedWidget =
                      model.copyWith(removeHoverProperties: true);
                  pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                }
              },
              onChanged: (updated, isHover) {
                if (isHover) {
                  final updatedWidget =
                      model.copyWith(hoverProperties: updated);
                  pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                } else {
                  final updatedWidget = model.copyWith(properties: updated);
                  pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                }
              },
              configBuilder: (props, disabled, onChangedLocal) =>
                  _buildContainerConfigUI(
                      props, disabled, localization, onChangedLocal),
            )
          ]);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildContainerConfigUI(
      PageBuilderContainerProperties? props,
      bool disabled,
      AppLocalizations localization,
      Function(PageBuilderContainerProperties?) onChangedLocal) {
    if (disabled) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<PagebuilderResponsiveBreakpointCubit,
        PagebuilderResponsiveBreakpoint>(
      bloc: Modular.get<PagebuilderResponsiveBreakpointCubit>(),
      builder: (context, currentBreakpoint) {
        final helper = PagebuilderResponsiveConfigHelper(currentBreakpoint);

        final isAutoSizing = props?.width == null && props?.height == null;

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Checkbox(
                value: isAutoSizing,
                onChanged: (value) {
                  if (value == true) {
                    // Enable auto sizing: set width and height to null
                    onChangedLocal(props?.copyWith(
                      removeWidth: true,
                      removeHeight: true,
                    ));
                  } else {
                    // Disable auto sizing: set width and height to 0
                    final zeroWidth = helper.setValue(null, 0.0);
                    final zeroHeight = helper.setValue(null, 0.0);
                    onChangedLocal(props?.copyWith(
                      width: zeroWidth,
                      height: zeroHeight,
                    ));
                  }
                },
              ),
              Text(
                localization.landingpage_pagebuilder_container_config_auto_sizing,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          if (!isAutoSizing) ...[
            const SizedBox(height: 10),
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
          ],
          const SizedBox(height: 20),
          PagebuilderShadowControl(
          title: localization
              .landingpage_pagebuilder_container_config_container_shadow,
          initialShadow: props?.shadow,
          showSpreadRadius: true,
          onSelected: (shadow) {
            onChangedLocal(props?.copyWith(shadow: shadow));
          }),
      const SizedBox(height: 30),
      Text(
        localization.landingpage_pagebuilder_container_config_container_border_title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 20),
      PagebuilderNumberStepperControl(
          title: localization.pagebuilder_image_config_border_radius,
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
          title: localization.landingpage_pagebuilder_container_config_container_border_width,
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
          title: localization.landingpage_pagebuilder_container_config_container_border_color,
          initialColor: props?.border?.color ?? Colors.transparent,
          globalColors: globalColors,
          selectedGlobalColorToken: props?.border?.globalColorToken,
          onColorSelected: (color, {token}) {
            final newBorder = (props?.border ?? const PagebuilderBorder(width: null, radius: null, color: null, globalColorToken: null))
                .copyWith(color: color, globalColorToken: token);
            onChangedLocal(props?.copyWith(border: newBorder));
          },
          onGradientSelected: null),
        ]);
      },
    );
  }
}
