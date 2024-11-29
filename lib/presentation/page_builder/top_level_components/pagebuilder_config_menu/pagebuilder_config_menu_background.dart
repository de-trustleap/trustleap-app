import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_background.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_image_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuBackground extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuBackground({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final pagebuilderBloc = Modular.get<PagebuilderBloc>();

    return CollapsibleTile(title: "Hintergrund", children: [
      PagebuilderColorControl(
          title: "Hintergrundfarbe",
          initialColor: model.background?.backgroundColor ?? Colors.transparent,
          onSelected: (color) {
            final backgroundModel = model.background ??
                PagebuilderBackground(
                    backgroundColor: null, imageProperties: null);
            final updatedBackground =
                backgroundModel.copyWith(backgroundColor: color);
            final updatedWidget = model.copyWith(background: updatedBackground);
            pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
          }),
      SizedBox(height: 20),
      PagebuilderImageControl(
          properties: model.background?.imageProperties ??
              PageBuilderImageProperties(
                  url: null,
                  borderRadius: null,
                  width: null,
                  height: null,
                  alignment: null),
          widgetModel: model,
          onSelected: (properties) {
            final backgroundModel = model.background ??
                PagebuilderBackground(
                    backgroundColor: null, imageProperties: null);
            final updatedBackground =
                backgroundModel.copyWith(imageProperties: properties);
            final updatedWidget = model.copyWith(background: updatedBackground);
            print("UPDATE");
            pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
          })
    ]);
  }
}
