import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant_extensions.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/textstyle_parser.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_widget_container.dart';
import 'package:flutter/material.dart';

class PagebuilderText extends StatelessWidget {
  final PageBuilderTextProperties properties;
  final PageBuilderWidget widgetModel;
  const PagebuilderText(
      {super.key, required this.properties, required this.widgetModel});

  @override
  Widget build(BuildContext context) {
    return LandingPageBuilderWidgetContainer(
        model: widgetModel,
        child: Text(properties.text ?? "",
            style: TextStyleParser().getTextStyleFromProperties(properties),
            textAlign: properties.alignment?.getValue()));
  }
}
