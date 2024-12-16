import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_column_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_config_menu_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuColumnConfig extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuColumnConfig({super.key, required this.model});

  void updateContainerProperties(PagebuilderColumnProperties properties,
      PagebuilderBloc pagebuilderCubit) {
    final updatedWidget = model.copyWith(properties: properties);
    pagebuilderCubit.add(UpdateWidgetEvent(updatedWidget));
  }

  @override
  Widget build(BuildContext context) {
    final pagebuilderBloc = Modular.get<PagebuilderBloc>();
    final localization = AppLocalizations.of(context);

    if (model.elementType == PageBuilderWidgetType.column &&
            model.properties is PagebuilderColumnProperties ||
        model.properties == null) {
      return CollapsibleTile(
          title:
              localization.landingpage_pagebuilder_column_config_column_title,
          children: [
            PagebuilderConfigMenuDrowdown(
                title: localization
                    .landingpage_pagebuilder_row_config_row_cross_axis_alignment,
                initialValue: model.properties != null
                    ? (model.properties as PagebuilderColumnProperties)
                            .mainAxisAlignment ??
                        MainAxisAlignment.center
                    : MainAxisAlignment.center,
                type: PagebuilderDropdownType.mainAxisAlignment,
                onSelected: (value) {
                  if (model.properties != null) {
                    final updatedProperties =
                        (model.properties as PagebuilderColumnProperties)
                            .copyWith(mainAxisAlignment: value);
                    updateContainerProperties(
                        updatedProperties, pagebuilderBloc);
                  } else {
                    final updatedProperties = PagebuilderColumnProperties(
                        mainAxisAlignment: value, crossAxisAlignment: null);
                    updateContainerProperties(
                        updatedProperties, pagebuilderBloc);
                  }
                }),
            const SizedBox(height: 20),
            PagebuilderConfigMenuDrowdown(
                title: localization
                    .landingpage_pagebuilder_row_config_row_main_axis_alignment,
                initialValue: model.properties != null
                    ? (model.properties as PagebuilderColumnProperties)
                            .crossAxisAlignment ??
                        CrossAxisAlignment.center
                    : CrossAxisAlignment.center,
                type: PagebuilderDropdownType.crossAxisAlignment,
                onSelected: (value) {
                  if (model.properties != null) {
                    final updatedProperties =
                        (model.properties as PagebuilderColumnProperties)
                            .copyWith(crossAxisAlignment: value);
                    updateContainerProperties(
                        updatedProperties, pagebuilderBloc);
                  } else {
                    final updatedProperties = PagebuilderColumnProperties(
                        mainAxisAlignment: null, crossAxisAlignment: value);
                    updateContainerProperties(
                        updatedProperties, pagebuilderBloc);
                  }
                }),
          ]);
    } else {
      return const SizedBox.shrink();
    }
  }
}
