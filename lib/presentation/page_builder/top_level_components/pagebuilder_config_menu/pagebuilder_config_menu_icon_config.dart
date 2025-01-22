import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_icon_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuIconConfig extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuIconConfig({super.key, required this.model});

  void updateIconProperties(
      PageBuilderIconProperties properties, PagebuilderBloc pagebuilderCubit) {
    final updatedWidget = model.copyWith(properties: properties);
    pagebuilderCubit.add(UpdateWidgetEvent(updatedWidget));
  }

  @override
  Widget build(BuildContext context) {
    final pagebuilderBloc = Modular.get<PagebuilderBloc>();
    final localization = AppLocalizations.of(context);

    if (model.elementType == PageBuilderWidgetType.icon &&
        model.properties is PageBuilderIconProperties) {
      return CollapsibleTile(
          title: localization.landingpage_pagebuilder_icon_config_icon_title,
          children: [
            PagebuilderColorControl(
                title: localization.landingpage_pagebuilder_icon_config_color,
                initialColor:
                    (model.properties as PageBuilderIconProperties).color ??
                        Colors.black,
                onSelected: (color) {
                  final updatedProperties =
                      (model.properties as PageBuilderIconProperties)
                          .copyWith(color: color);
                  updateIconProperties(updatedProperties, pagebuilderBloc);
                }),
            const SizedBox(height: 20),
            PagebuilderNumberStepperControl(
                title: localization.landingpage_pagebuilder_icon_config_size,
                initialValue: (model.properties as PageBuilderIconProperties)
                        .size
                        ?.toInt() ??
                    0,
                minValue: 0,
                maxValue: 1000,
                onSelected: (size) {
                  final updatedProperties =
                      (model.properties as PageBuilderIconProperties)
                          .copyWith(size: size.toDouble());
                  updateIconProperties(updatedProperties, pagebuilderBloc);
                })
          ]);
    } else {
      return const SizedBox.shrink();
    }
  }
}
