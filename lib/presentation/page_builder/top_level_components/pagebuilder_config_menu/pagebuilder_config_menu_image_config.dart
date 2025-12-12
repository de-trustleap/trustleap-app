import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_border.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_colors.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_paint.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_picker/pagebuilder_color_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_config_menu_dropdown.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_hover_config_tabbar.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_responsive_config_helper.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_shadow_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_size_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuImageConfig extends StatelessWidget {
  final PageBuilderWidget model;
  final PageBuilderGlobalColors? globalColors;
  const PagebuilderConfigMenuImageConfig({super.key, required this.model, this.globalColors});

  @override
  Widget build(BuildContext context) {
    final pagebuilderBloc = Modular.get<PagebuilderBloc>();
    final localization = AppLocalizations.of(context);

    if (model.elementType == PageBuilderWidgetType.image &&
        model.properties is PageBuilderImageProperties) {
      return CollapsibleTile(
          title: localization.pagebuilder_image_config_title,
          children: [
            PagebuilderHoverConfigTabBar<PageBuilderImageProperties>(
              properties: model.properties as PageBuilderImageProperties,
              hoverProperties: model.hoverProperties != null
                  ? model.hoverProperties as PageBuilderImageProperties
                  : null,
              hoverEnabled: model.hoverProperties != null,
              onHoverEnabledChanged: (enabled) {
                if (enabled) {
                  final hoverProperties =
                      (model.properties as PageBuilderImageProperties)
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
                  _buildImageConfigUI(
                      props, disabled, localization, onChangedLocal),
            )
          ]);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildImageConfigUI(
      PageBuilderImageProperties? props,
      bool disabled,
      AppLocalizations localization,
      Function(PageBuilderImageProperties?) onChangedLocal) {
    if (disabled) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<PagebuilderResponsiveBreakpointCubit,
        PagebuilderResponsiveBreakpoint>(
      bloc: Modular.get<PagebuilderResponsiveBreakpointCubit>(),
      builder: (context, currentBreakpoint) {
        final helper = PagebuilderResponsiveConfigHelper(currentBreakpoint);

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          PagebuilderConfigMenuDrowdown(
              title: localization.pagebuilder_image_config_content_mode,
              initialValue: helper.getValue(props?.contentMode) ?? BoxFit.cover,
              type: PagebuilderDropdownType.contentMode,
              showResponsiveButton: true,
              currentBreakpoint: currentBreakpoint,
              onSelected: (contentMode) {
                final updatedContentMode =
                    helper.setValue(props?.contentMode, contentMode);
                onChangedLocal(
                    props?.copyWith(contentMode: updatedContentMode));
              }),
          const SizedBox(height: 20),
          PagebuilderColorControl(
              title: localization.pagebuilder_image_config_image_overlay,
              initialColor: props?.overlayPaint?.color ?? Colors.transparent,
              initialGradient: props?.overlayPaint?.gradient,
              globalColors: globalColors,
              selectedGlobalColorToken: props?.overlayPaint?.globalColorToken,
              onColorSelected: (color, {token}) {
                final paint = PagebuilderPaint.color(color, globalColorToken: token);
                onChangedLocal(props?.copyWith(overlayPaint: paint));
              },
              onGradientSelected: (gradient) {
                final paint = PagebuilderPaint.gradient(gradient);
                onChangedLocal(props?.copyWith(overlayPaint: paint));
              }),
          const SizedBox(height: 20),
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
            localization.pagebuilder_image_config_border_title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          PagebuilderNumberStepperControl(
              title: localization.pagebuilder_image_config_border_radius,
              initialValue: props?.border?.radius?.toInt() ?? 0,
              minValue: 0,
              maxValue: 1000,
              onSelected: (radius) {
                final newBorder = (props?.border ??
                        const PagebuilderBorder(
                            width: null, radius: null, color: null))
                    .copyWith(radius: radius.toDouble());
                onChangedLocal(props?.copyWith(border: newBorder));
              }),
          const SizedBox(height: 20),
          PagebuilderNumberStepperControl(
              title: localization.pagebuilder_image_config_border_width,
              initialValue: props?.border?.width?.toInt() ?? 0,
              minValue: 0,
              maxValue: 100,
              onSelected: (width) {
                final newBorder = (props?.border ??
                        const PagebuilderBorder(
                            width: null, radius: null, color: null))
                    .copyWith(width: width.toDouble());
                onChangedLocal(props?.copyWith(border: newBorder));
              }),
          const SizedBox(height: 20),
          PagebuilderColorControl(
              title: localization.pagebuilder_image_config_border_color,
              initialColor: props?.border?.color ?? Colors.transparent,
              globalColors: globalColors,
              selectedGlobalColorToken: props?.border?.globalColorToken,
              onColorSelected: (color, {token}) {
                final newBorder = (props?.border ??
                        const PagebuilderBorder(
                            width: null, radius: null, color: null, globalColorToken: null))
                    .copyWith(color: color, globalColorToken: token);
                onChangedLocal(props?.copyWith(border: newBorder));
              },
              onGradientSelected: null),
        ]);
      },
    );
  }
}
