import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_calendly_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_widget_container.dart';
import 'package:flutter/material.dart';

class PagebuilderCalendly extends StatelessWidget {
  final PagebuilderCalendlyProperties properties;
  final PageBuilderWidget widgetModel;
  
  const PagebuilderCalendly({
    super.key,
    required this.properties,
    required this.widgetModel,
  });

  @override
  Widget build(BuildContext context) {
    return LandingPageBuilderWidgetContainer(
      model: widgetModel,
      child: Container(
        width: properties.width,
        height: properties.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(properties.borderRadius ?? 0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(properties.borderRadius ?? 0),
          child: Image.asset(
            'assets/images/calendly_logo.png',
            width: properties.width,
            height: properties.height,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}