import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/image_view.dart';
import 'package:flutter/material.dart';

class PagebuilderImageControl extends StatelessWidget {
  final PageBuilderImageProperties properties;
  final PageBuilderWidget widgetModel;
  final Function(PageBuilderImageProperties) onSelected;
  final Function onDelete;
  const PagebuilderImageControl(
      {super.key,
      required this.properties,
      required this.widgetModel,
      required this.onSelected,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Hintergrundbild", style: themeData.textTheme.bodySmall),
      SizedBox(height: 16),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PageBuilderImageView(
                properties: properties,
                widgetModel: widgetModel,
                isConfigMenu: true,
                onSelectedInConfigMenu: (properties) => onSelected(properties)),
            SizedBox(width: 16),
            IconButton(
                onPressed: () => onDelete(),
                icon: Icon(Icons.delete,
                    size: 24, color: themeData.colorScheme.secondary))
          ])
    ]);
  }
}
