import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_config_menu_dropdown.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_size_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuImageConfig extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuImageConfig({super.key, required this.model});

  void updateImageProperties(
      PageBuilderImageProperties properties, PagebuilderBloc pagebuilderCubit) {
    final updatedWidget = model.copyWith(properties: properties);
    pagebuilderCubit.add(UpdateWidgetEvent(updatedWidget));
  }

  @override
  Widget build(BuildContext context) {
    final pagebuilderBloc = Modular.get<PagebuilderBloc>();

    if (model.elementType == PageBuilderWidgetType.image &&
        model.properties is PageBuilderImageProperties) {
      return CollapsibleTile(title: "Bild Konfiguration", children: [
        PagebuilderConfigMenuDrowdown(
            title: "Bildmodus",
            initialValue:
                (model.properties as PageBuilderImageProperties).contentMode ??
                    BoxFit.cover,
            type: PagebuilderDropdownType.contentMode,
            onSelected: (contentMode) {
              final updatedProperties =
                  (model.properties as PageBuilderImageProperties)
                      .copyWith(contentMode: contentMode);
              updateImageProperties(updatedProperties, pagebuilderBloc);
            }),
        SizedBox(height: 20),
        PagebuilderColorControl(
            title: "Bild Overlay",
            initialColor:
                (model.properties as PageBuilderImageProperties).overlayColor ??
                    Colors.transparent,
            onSelected: (color) {
              final updatedProperties =
                  (model.properties as PageBuilderImageProperties)
                      .copyWith(overlayColor: color);
              updateImageProperties(updatedProperties, pagebuilderBloc);
            }),
        SizedBox(height: 20),
        PagebuilderNumberStepperControl(
            title: "Radius",
            initialValue: (model.properties as PageBuilderImageProperties)
                    .borderRadius
                    ?.toInt() ??
                0,
            minValue: 0,
            maxValue: 1000,
            onSelected: (radius) {
              final updatedProperties =
                  (model.properties as PageBuilderImageProperties)
                      .copyWith(borderRadius: radius.toDouble());
              updateImageProperties(updatedProperties, pagebuilderBloc);
            }),
        SizedBox(height: 20),
        PagebuilderSizeControl(
            model: model,
            onChanged: (size) {
              final updatedProperties =
                  (model.properties as PageBuilderImageProperties)
                      .copyWith(width: size.width, height: size.height);
              updateImageProperties(updatedProperties, pagebuilderBloc);
            }),
        SizedBox(height: 20),
        PagebuilderConfigMenuDrowdown(
            title: "Ausrichtung",
            initialValue:
                (model.properties as PageBuilderImageProperties).alignment ??
                    Alignment.center,
            type: PagebuilderDropdownType.alignment,
            onSelected: (alignment) {
              final updatedProperties =
                  (model.properties as PageBuilderImageProperties)
                      .copyWith(alignment: alignment);
              updateImageProperties(updatedProperties, pagebuilderBloc);
            }),
      ]);
    } else {
      return SizedBox.shrink();
    }
  }
}
