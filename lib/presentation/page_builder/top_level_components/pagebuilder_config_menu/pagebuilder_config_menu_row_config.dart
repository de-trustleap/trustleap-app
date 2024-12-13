import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_row_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_config_menu_dropdown.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_switch_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuRowConfig extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuRowConfig({super.key, required this.model});

  void updateContainerProperties(
      PagebuilderRowProperties properties, PagebuilderBloc pagebuilderBloc) {
    final updatedWidget = model.copyWith(properties: properties);
    pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
  }

  @override
  Widget build(BuildContext context) {
    final pagebuilderBloc = Modular.get<PagebuilderBloc>();
    final localization = AppLocalizations.of(context);

    if (model.elementType == PageBuilderWidgetType.row &&
            model.properties is PagebuilderRowProperties ||
        model.properties == null) {
      return CollapsibleTile(
          title: localization.landingpage_pagebuilder_row_config_row_title,
          children: [
            PagebuilderSwitchControl(
                title: localization
                    .landingpage_pagebuilder_row_config_row_equal_heights,
                isActive: model.properties != null
                    ? (model.properties as PagebuilderRowProperties)
                            .equalHeights ??
                        false
                    : false,
                onSelected: (isSelected) {
                  if (model.properties != null) {
                    final updatedProperties =
                        (model.properties as PagebuilderRowProperties)
                            .copyWith(equalHeights: isSelected);
                    updateContainerProperties(
                        updatedProperties, pagebuilderBloc);
                  } else {
                    final updatedProperties = PagebuilderRowProperties(
                        equalHeights: isSelected,
                        mainAxisAlignment: null,
                        crossAxisAlignment: null);
                    updateContainerProperties(
                        updatedProperties, pagebuilderBloc);
                  }
                }),
            SizedBox(height: 20),
            PagebuilderConfigMenuDrowdown(
                title: localization
                    .landingpage_pagebuilder_row_config_row_main_axis_alignment,
                initialValue: model.properties != null
                    ? (model.properties as PagebuilderRowProperties)
                            .mainAxisAlignment ??
                        MainAxisAlignment.center
                    : MainAxisAlignment.center,
                type: PagebuilderDropdownType.mainAxisAlignment,
                onSelected: (value) {
                  if (model.properties != null) {
                    final updatedProperties =
                        (model.properties as PagebuilderRowProperties)
                            .copyWith(mainAxisAlignment: value);
                    updateContainerProperties(
                        updatedProperties, pagebuilderBloc);
                  } else {
                    final updatedProperties = PagebuilderRowProperties(
                        equalHeights: null,
                        mainAxisAlignment: value,
                        crossAxisAlignment: null);
                    updateContainerProperties(
                        updatedProperties, pagebuilderBloc);
                  }
                }),
            SizedBox(height: 20),
            PagebuilderConfigMenuDrowdown(
                title: localization
                    .landingpage_pagebuilder_row_config_row_cross_axis_alignment,
                initialValue: model.properties != null
                    ? (model.properties as PagebuilderRowProperties)
                            .crossAxisAlignment ??
                        CrossAxisAlignment.center
                    : CrossAxisAlignment.center,
                type: PagebuilderDropdownType.crossAxisAlignment,
                onSelected: (value) {
                  if (model.properties != null) {
                    final updatedProperties =
                        (model.properties as PagebuilderRowProperties)
                            .copyWith(crossAxisAlignment: value);
                    updateContainerProperties(
                        updatedProperties, pagebuilderBloc);
                  } else {
                    final updatedProperties = PagebuilderRowProperties(
                        equalHeights: null,
                        mainAxisAlignment: null,
                        crossAxisAlignment: value);
                    updateContainerProperties(
                        updatedProperties, pagebuilderBloc);
                  }
                }),
          ]);
    } else {
      return SizedBox.shrink();
    }
  }
}
