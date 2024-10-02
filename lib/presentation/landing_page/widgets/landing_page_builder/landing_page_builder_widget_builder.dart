import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_icon_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_builder/elements/editable_text.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_builder/elements/icon_view.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_builder/elements/image_view.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_builder/landing_page_builder_widget_container.dart';
import 'package:flutter/material.dart';

class LandingPageBuilderWidgetBuilder {
  Widget build(PageBuilderWidget model) {
    switch (model.elementType) {
      case PageBuilderWidgetType.column:
        return buildColumnWidget(model);
      case PageBuilderWidgetType.row:
        return buildRowWidget(model);
      case PageBuilderWidgetType.text:
        return buildTextWidget(
            model.properties as PageBuilderTextProperties, model);
      case PageBuilderWidgetType.image:
        return buildImageWidget(
            model.properties as PageBuilderImageProperties, model);
      case PageBuilderWidgetType.icon:
        return buildIconWidget(
            model.properties as PageBuilderIconProperties, model);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget buildColumnWidget(PageBuilderWidget model) {
    if (model.children == null || model.children!.isEmpty) {
      return const SizedBox.shrink();
    }

    return LandingPageBuilderWidgetContainer(
      model: model,
      child: Column(
          children: model.children?.map((child) {
                return build(child);
              }).toList() ??
              []),
    );
  }

  Widget buildRowWidget(PageBuilderWidget model) {
    if (model.children == null || model.children!.isEmpty) {
      return const SizedBox.shrink();
    }
    // Berechne den Gesamtwert der definierten widthPercentage Werte
    final totalWidthPercentage = model.children!
        .fold<double>(0, (sum, child) => sum + (child.widthPercentage ?? 0));
    // Falls die Gesamtbreite über 100% liegt, passe die Werte an
    final scaleFactor =
        totalWidthPercentage > 100 ? 100 / totalWidthPercentage : 1.0;
    return LandingPageBuilderWidgetContainer(
      model: model,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: model.children?.map((child) {
                final flexValue = (child.widthPercentage ?? 0) * scaleFactor;
                return Expanded(
                    flex: (flexValue * 100).toInt(), child: build(child));
              }).toList() ??
              []),
    );
  }

  Widget buildTextWidget(
      PageBuilderTextProperties properties, PageBuilderWidget model) {
    return PageBuilderEditableText(properties: properties, widgetModel: model);
  }

  Widget buildImageWidget(
      PageBuilderImageProperties properties, PageBuilderWidget model) {
    return PageBuilderImageView(properties: properties, widgetModel: model);
  }

  Widget buildIconWidget(
      PageBuilderIconProperties properties, PageBuilderWidget model) {
    return PageBuilderIconView(properties: properties, widgetModel: model);
  }
}
