import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_contact_form_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_container_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_icon_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_row_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_builder/elements/contact_form_view.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_builder/elements/editable_text.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_builder/elements/icon_view.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_builder/elements/image_view.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_builder/landing_page_builder_widget_container.dart';
import 'package:flutter/material.dart';

class LandingPageBuilderWidgetBuilder {
  Widget build(PageBuilderWidget model) {
    switch (model.elementType) {
      case PageBuilderWidgetType.container:
        if (model.properties != null) {
          return buildContainerWidget(
              model.properties as PageBuilderContainerProperties, model);
        } else {
          return buildContainerWidget(null, model);
        }
      case PageBuilderWidgetType.column:
        return buildColumnWidget(model);
      case PageBuilderWidgetType.row:
        if (model.properties != null) {
          return buildRowWidget(
              model.properties as PagebuilderRowProperties, model);
        } else {
          return buildRowWidget(null, model);
        }
      case PageBuilderWidgetType.text:
        return buildTextWidget(
            model.properties as PageBuilderTextProperties, model);
      case PageBuilderWidgetType.image:
        return buildImageWidget(
            model.properties as PageBuilderImageProperties, model);
      case PageBuilderWidgetType.icon:
        return buildIconWidget(
            model.properties as PageBuilderIconProperties, model);
      case PageBuilderWidgetType.contactForm:
        return buildContactFormWidget(
            model.properties as PageBuilderContactFormProperties, model);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget buildContainerWidget(
      PageBuilderContainerProperties? properties, PageBuilderWidget model) {
    return LandingPageBuilderWidgetContainer(
        properties: properties,
        model: model,
        child: model.containerChild != null
            ? build(model.containerChild!)
            : const SizedBox.shrink());
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

  Widget buildRowWidget(
      PagebuilderRowProperties? properties, PageBuilderWidget model) {
    if (model.children == null || model.children!.isEmpty) {
      return const SizedBox.shrink();
    }
    // Berechne den Gesamtwert der definierten widthPercentage Werte
    final totalWidthPercentage = model.children!
        .fold<double>(0, (sum, child) => sum + (child.widthPercentage ?? 0));
    // Falls die Gesamtbreite über 100% liegt, passe die Werte an
    final scaleFactor =
        totalWidthPercentage > 100 ? 100 / totalWidthPercentage : 1.0;
    // Restliche Breite berechnen, falls die Gesamtbreite unter 100% liegt
    final remainingWidthPercentage = 100 - totalWidthPercentage * scaleFactor;

    // Erstelle eine Liste für die Kinder der Row
    List<Widget> rowChildren = [];

    // Füge die Expanded-Widgets für jedes Kind hinzu
    for (var child in model.children!) {
      final flexValue = (child.widthPercentage ?? 0) * scaleFactor;
      rowChildren.add(
        Expanded(
          flex: (flexValue * 100).toInt(),
          child: build(child),
        ),
      );
    }

    // Füge eine SizedBox am Ende hinzu, falls restliche Breite vorhanden ist
    if (remainingWidthPercentage > 0) {
      rowChildren.add(
        Expanded(
          flex: (remainingWidthPercentage * 100).toInt(),
          child: const SizedBox.shrink(),
        ),
      );
    }
    return LandingPageBuilderWidgetContainer(
      model: model,
      child: properties?.equalWidths == true
          ? IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: rowChildren,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: rowChildren,
            ),
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

  Widget buildContactFormWidget(
      PageBuilderContactFormProperties properties, PageBuilderWidget model) {
    return LandingPageBuilderWidgetContainer(
        model: model,
        child: PageBuilderContactFormView(
            properties: properties, widgetModel: model));
  }
}
