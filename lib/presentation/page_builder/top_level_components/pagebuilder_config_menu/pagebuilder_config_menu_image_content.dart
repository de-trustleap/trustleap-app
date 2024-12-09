import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_image_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuImageContent extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuImageContent({super.key, required this.model});

  void updateImageProperties(
      PageBuilderImageProperties properties, PagebuilderBloc pagebuilderCubit) {
    final updatedWidget = model.copyWith(properties: properties);
    pagebuilderCubit.add(UpdateWidgetEvent(updatedWidget));
  }

  @override
  Widget build(BuildContext context) {
    final pagebuilderCubit = Modular.get<PagebuilderBloc>();
    return CollapsibleTile(title: "Bild Inhalt", children: [
      if (model.properties is PageBuilderImageProperties) ...[
        PagebuilderImageControl(
            properties: model.properties as PageBuilderImageProperties,
            widgetModel: model,
            onSelected: (imageProperties) {
              updateImageProperties(imageProperties, pagebuilderCubit);
            })
      ]
    ]);
  }
}

// TODO: Fehler beheben: Das Speichern eines Bildes mit Hintergrundbild funktioniert nicht. Dann ist nur das Hintergrundbild gespeichert worden und das Bild zeigt ebenfalls das Hintergrundbild an.