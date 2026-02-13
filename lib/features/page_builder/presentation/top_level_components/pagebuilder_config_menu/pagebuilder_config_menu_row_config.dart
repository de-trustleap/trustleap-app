import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_row_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_config_menu_dropdown.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_hover_config_tabbar.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_switch_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuRowConfig extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuRowConfig({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final pagebuilderBloc = Modular.get<PagebuilderBloc>();
    final localization = AppLocalizations.of(context);

    if (model.elementType == PageBuilderWidgetType.row &&
            model.properties is PagebuilderRowProperties ||
        model.properties == null) {
      final currentProperties = model.properties as PagebuilderRowProperties? ??
          const PagebuilderRowProperties(
              equalHeights: null,
              mainAxisAlignment: null,
              crossAxisAlignment: null,
              switchToColumnFor: null);

      return CollapsibleTile(
          title: localization.landingpage_pagebuilder_row_config_row_title,
          children: [
            PagebuilderHoverConfigTabBar<PagebuilderRowProperties>(
              properties: currentProperties,
              hoverProperties: model.hoverProperties != null
                  ? model.hoverProperties as PagebuilderRowProperties
                  : null,
              hoverEnabled: model.hoverProperties != null,
              onHoverEnabledChanged: (enabled) {
                if (enabled) {
                  final hoverProperties = currentProperties.deepCopy();
                  final updatedWidget = model.copyWith(
                      properties: currentProperties,
                      hoverProperties: hoverProperties);
                  pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                } else {
                  final updatedWidget = model.copyWith(
                      properties: currentProperties,
                      removeHoverProperties: true);
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
                  _buildRowConfigUI(
                      props, disabled, localization, onChangedLocal),
            )
          ]);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildRowConfigUI(
      PagebuilderRowProperties? props,
      bool disabled,
      AppLocalizations localization,
      Function(PagebuilderRowProperties?) onChangedLocal) {
    if (disabled) {
      return const SizedBox.shrink();
    }

    return Column(children: [
      PagebuilderSwitchControl(
          title:
              localization.landingpage_pagebuilder_row_config_row_equal_heights,
          isActive: props?.equalHeights ?? false,
          onSelected: (isSelected) {
            onChangedLocal(props?.copyWith(equalHeights: isSelected) ??
                PagebuilderRowProperties(
                    equalHeights: isSelected,
                    mainAxisAlignment: null,
                    crossAxisAlignment: null,
                    switchToColumnFor: null));
          }),
      const SizedBox(height: 20),
      PagebuilderConfigMenuDrowdown(
          title: localization
              .landingpage_pagebuilder_row_config_row_main_axis_alignment,
          initialValue: props?.mainAxisAlignment ?? MainAxisAlignment.center,
          type: PagebuilderDropdownType.mainAxisAlignment,
          onSelected: (value) {
            onChangedLocal(props?.copyWith(mainAxisAlignment: value) ??
                PagebuilderRowProperties(
                    equalHeights: null,
                    mainAxisAlignment: value,
                    crossAxisAlignment: null,
                    switchToColumnFor: null));
          }),
      const SizedBox(height: 20),
      PagebuilderConfigMenuDrowdown(
          title: localization
              .landingpage_pagebuilder_row_config_row_cross_axis_alignment,
          initialValue: props?.crossAxisAlignment ?? CrossAxisAlignment.center,
          type: PagebuilderDropdownType.crossAxisAlignment,
          onSelected: (value) {
            onChangedLocal(props?.copyWith(crossAxisAlignment: value) ??
                PagebuilderRowProperties(
                    equalHeights: null,
                    mainAxisAlignment: null,
                    crossAxisAlignment: value,
                    switchToColumnFor: null));
          }),
    ]);
  }
}
