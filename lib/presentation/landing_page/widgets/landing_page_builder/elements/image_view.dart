import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:flutter/material.dart';

class PageBuilderImageView extends StatelessWidget {
  final PageBuilderImageProperties properties;
  final PageBuilderWidget widgetModel;

  const PageBuilderImageView(
      {super.key, required this.properties, required this.widgetModel});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
