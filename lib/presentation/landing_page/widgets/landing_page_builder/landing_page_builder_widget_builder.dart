import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_builder/elements/editable_text.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_builder/elements/image_view.dart';
import 'package:flutter/material.dart';

class LandingPageBuilderWidgetBuilder {
  Widget build(PageBuilderWidget model) {
    if (model.properties == null) {
      return const SizedBox.shrink();
    } else {
      switch (model.elementType) {
        case PageBuilderWidgetType.text:
          return buildTextWidget(
              model.properties as PageBuilderTextProperties, model);
        case PageBuilderWidgetType.image:
          return buildImageWidget(
              model.properties as PageBuilderImageProperties, model);
        default:
          return const SizedBox.shrink();
      }
    }
  }

  Widget buildTextWidget(
      PageBuilderTextProperties properties, PageBuilderWidget model) {
    return PageBuilderEditableText(properties: properties, widgetModel: model);
  }

  Widget buildImageWidget(
      PageBuilderImageProperties properties, PageBuilderWidget model) {
    return PageBuilderImageView(
        properties: properties,
        widgetModel: model);
  }
}
