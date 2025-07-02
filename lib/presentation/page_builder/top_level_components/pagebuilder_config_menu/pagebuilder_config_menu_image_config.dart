import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_config_menu_dropdown.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_hover_config_tabbar.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_size_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuImageConfig extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuImageConfig({super.key, required this.model});

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

    return Column(children: [
      PagebuilderConfigMenuDrowdown(
          title: localization.pagebuilder_image_config_content_mode,
          initialValue: props?.contentMode ?? BoxFit.cover,
          type: PagebuilderDropdownType.contentMode,
          onSelected: (contentMode) {
            onChangedLocal(props?.copyWith(contentMode: contentMode));
          }),
      const SizedBox(height: 20),
      PagebuilderColorControl(
          title: localization.pagebuilder_image_config_image_overlay,
          initialColor: props?.overlayColor ?? Colors.transparent,
          onSelected: (color) {
            onChangedLocal(props?.copyWith(overlayColor: color));
          }),
      const SizedBox(height: 20),
      PagebuilderNumberStepperControl(
          title: localization.pagebuilder_image_config_border_radius,
          initialValue: props?.borderRadius?.toInt() ?? 0,
          minValue: 0,
          maxValue: 1000,
          onSelected: (radius) {
            onChangedLocal(props?.copyWith(borderRadius: radius.toDouble()));
          }),
      const SizedBox(height: 20),
      PagebuilderSizeControl(
          width: props?.width ?? 0,
          height: props?.height ?? 0,
          onChanged: (size) {
            onChangedLocal(
                props?.copyWith(width: size.width, height: size.height));
          }),
    ]);
  }
}
