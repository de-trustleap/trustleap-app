import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_container_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_shadow_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuContainerConfig extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuContainerConfig({super.key, required this.model});

  void updateContainerProperties(PageBuilderContainerProperties properties,
      PagebuilderBloc pagebuilderCubit) {
    final updatedWidget = model.copyWith(properties: properties);
    pagebuilderCubit.add(UpdateWidgetEvent(updatedWidget));
  }

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
            PagebuilderNumberStepperControl(
                title: localization.pagebuilder_image_config_border_radius,
                initialValue:
                    (model.properties as PageBuilderContainerProperties)
                            .borderRadius
                            ?.toInt() ??
                        0,
                minValue: 0,
                maxValue: 1000,
                onSelected: (radius) {
                  final updatedProperties =
                      (model.properties as PageBuilderContainerProperties)
                          .copyWith(borderRadius: radius.toDouble());
                  updateContainerProperties(updatedProperties, pagebuilderBloc);
                }),
            SizedBox(height: 20),
            PagebuilderShadowControl(
                title: localization
                    .landingpage_pagebuilder_container_config_container_shadow,
                initialShadow:
                    (model.properties as PageBuilderContainerProperties).shadow,
                showSpreadRadius: true,
                onSelected: (shadow) {
                  final updatedProperties =
                      (model.properties as PageBuilderContainerProperties)
                          .copyWith(shadow: shadow);
                  updateContainerProperties(updatedProperties, pagebuilderBloc);
                })
          ]);
    } else {
      return SizedBox.shrink();
    }
  }
}
