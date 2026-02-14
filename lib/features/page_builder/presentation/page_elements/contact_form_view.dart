// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_contact_form_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/page_elements/button_view.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/page_elements/textfield_view.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/landing_page_builder_widget_container.dart';
import 'package:flutter/material.dart';

class PageBuilderContactFormView extends StatelessWidget {
  final PageBuilderContactFormProperties properties;
  final PageBuilderWidget widgetModel;
  final int? index;

  const PageBuilderContactFormView({
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
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (properties.nameTextFieldProperties != null) ...[
              PageBuilderTextFieldView(
                  properties: properties.nameTextFieldProperties!,
                  widgetModel: widgetModel)
            ],
            const SizedBox(height: 16),
            if (properties.emailTextFieldProperties != null) ...[
              PageBuilderTextFieldView(
                  properties: properties.emailTextFieldProperties!,
                  widgetModel: widgetModel)
            ],
            const SizedBox(height: 16),
            if (properties.phoneTextFieldProperties != null) ...[
              PageBuilderTextFieldView(
                  properties: properties.phoneTextFieldProperties!,
                  widgetModel: widgetModel)
            ],
            const SizedBox(height: 16),
            if (properties.messageTextFieldProperties != null) ...[
              PageBuilderTextFieldView(
                  properties: properties.messageTextFieldProperties!,
                  widgetModel: widgetModel)
            ],
            const SizedBox(height: 16),
            if (properties.buttonProperties != null) ...[
              PageBuilderButtonView(
                  properties: properties.buttonProperties!,
                  widgetModel: widgetModel)
            ]
          ]),
    );
  }
}
