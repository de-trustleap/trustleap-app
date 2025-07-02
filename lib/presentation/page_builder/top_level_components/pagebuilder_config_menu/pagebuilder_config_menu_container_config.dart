import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_container_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_hover_config_tabbar.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_shadow_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuContainerConfig extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuContainerConfig({super.key, required this.model});

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

    return Column(children: [
      PagebuilderNumberStepperControl(
          title: localization.pagebuilder_image_config_border_radius,
          initialValue: props?.borderRadius?.toInt() ?? 0,
          minValue: 0,
          maxValue: 1000,
          onSelected: (radius) {
            onChangedLocal(props?.copyWith(borderRadius: radius.toDouble()));
          }),
      const SizedBox(height: 20),
      PagebuilderShadowControl(
          title: localization
              .landingpage_pagebuilder_container_config_container_shadow,
          initialShadow: props?.shadow,
          showSpreadRadius: true,
          onSelected: (shadow) {
            onChangedLocal(props?.copyWith(shadow: shadow));
          })
    ]);
  }
}
