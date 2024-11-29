import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/image_view.dart';
import 'package:flutter/material.dart';

class PagebuilderImageControl extends StatelessWidget {
  final PageBuilderImageProperties properties;
  final PageBuilderWidget widgetModel;
  final Function(PageBuilderImageProperties) onSelected;
  const PagebuilderImageControl(
      {super.key,
      required this.properties,
      required this.widgetModel,
      required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Text("Bild hochladen", style: themeData.textTheme.bodySmall),
      PageBuilderImageView(
          properties: properties,
          widgetModel: widgetModel,
          isConfigMenu: true,
          onSelectedInConfigMenu: (properties) => onSelected(properties))
    ]);
  }
}
