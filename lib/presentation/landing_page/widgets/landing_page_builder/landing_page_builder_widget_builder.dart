import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_builder/editable_text.dart';
import 'package:flutter/material.dart';

class LandingPageBuilderWidgetBuilder {
  Widget build(PageBuilderWidget model) {
    switch (model.elementType) {
      case PageBuilderWidgetType.text:
        return buildTextWidget(model.properties as PageBuilderTextProperties);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget buildTextWidget(PageBuilderTextProperties properties) {
    return PageBuilderEditableText(
        properties: properties, onTextChanged: (newText) => print(newText));
  }
}
