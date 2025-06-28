import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_column_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_config_menu_dropdown.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_hover_config_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuColumnConfig extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuColumnConfig({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final pagebuilderBloc = Modular.get<PagebuilderBloc>();
    final localization = AppLocalizations.of(context);

    if (model.elementType == PageBuilderWidgetType.column &&
            model.properties is PagebuilderColumnProperties ||
        model.properties == null) {
      final currentProperties =
          model.properties as PagebuilderColumnProperties? ??
              const PagebuilderColumnProperties(
                  mainAxisAlignment: null, crossAxisAlignment: null);

      return CollapsibleTile(
          title:
              localization.landingpage_pagebuilder_column_config_column_title,
          children: [
            PagebuilderHoverConfigTabBar<PagebuilderColumnProperties>(
              properties: currentProperties,
              hoverProperties: model.hoverProperties != null
                  ? model.hoverProperties as PagebuilderColumnProperties
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
                  _buildColumnConfigUI(
                      props, disabled, localization, onChangedLocal),
            )
          ]);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildColumnConfigUI(
      PagebuilderColumnProperties? props,
      bool disabled,
      AppLocalizations localization,
      Function(PagebuilderColumnProperties?) onChangedLocal) {
    if (disabled) {
      return const SizedBox.shrink();
    }

    return Column(children: [
      PagebuilderConfigMenuDrowdown(
          title: localization
              .landingpage_pagebuilder_row_config_row_cross_axis_alignment,
          initialValue: props?.mainAxisAlignment ?? MainAxisAlignment.center,
          type: PagebuilderDropdownType.mainAxisAlignment,
          onSelected: (value) {
            onChangedLocal(props?.copyWith(mainAxisAlignment: value) ??
                PagebuilderColumnProperties(
                    mainAxisAlignment: value, crossAxisAlignment: null));
          }),
      const SizedBox(height: 20),
      PagebuilderConfigMenuDrowdown(
          title: localization
              .landingpage_pagebuilder_row_config_row_main_axis_alignment,
          initialValue: props?.crossAxisAlignment ?? CrossAxisAlignment.center,
          type: PagebuilderDropdownType.crossAxisAlignment,
          onSelected: (value) {
            onChangedLocal(props?.copyWith(crossAxisAlignment: value) ??
                PagebuilderColumnProperties(
                    mainAxisAlignment: null, crossAxisAlignment: value));
          }),
    ]);
  }
}
