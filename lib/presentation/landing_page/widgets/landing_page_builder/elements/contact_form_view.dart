// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_contact_form_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_builder/elements/textfield_view.dart';
import 'package:flutter/material.dart';

class ContactFormView extends StatelessWidget {
  final PageBuilderContactFormProperties properties;
  final PageBuilderWidget widgetModel;
  const ContactFormView({
    super.key,
    required this.properties,
    required this.widgetModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (properties.nameTextFieldProperties != null) ...[
            TextFieldView(
                properties: properties.nameTextFieldProperties!,
                widgetModel: widgetModel)
          ],
          if (properties.emailTextFieldProperties != null) ...[
            TextFieldView(
                properties: properties.emailTextFieldProperties!,
                widgetModel: widgetModel)
          ],
          if (properties.messageTextFieldProperties != null) ...[
            TextFieldView(
                properties: properties.messageTextFieldProperties!,
                widgetModel: widgetModel)
          ]
        ]);
  }
}
