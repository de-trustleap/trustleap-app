import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/pagebuilder_html_renderer.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_widget_container.dart';
import 'package:flutter/material.dart';

class PagebuilderText extends StatelessWidget {
  final PageBuilderTextProperties properties;
  final PageBuilderWidget widgetModel;
  final int? index;

  const PagebuilderText({
    super.key,
    required this.properties,
    required this.widgetModel,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return LandingPageBuilderWidgetContainer(
      model: widgetModel,
      index: index,
      child: PagebuilderHtmlRenderer(textProperties: properties),
    );
  }
}
