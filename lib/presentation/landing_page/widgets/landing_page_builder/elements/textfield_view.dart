// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_textfield_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_builder/elements/textstyle_parser.dart';
import 'package:flutter/material.dart';

class TextFieldView extends StatelessWidget {
  final PageBuilderTextFieldProperties properties;
  final PageBuilderWidget widgetModel;
  final TextStyleParser parser = TextStyleParser();

  TextFieldView({
    super.key,
    required this.properties,
    required this.widgetModel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: properties.width,
        child: TextField(
            readOnly: true,
            minLines: 1,
            maxLines: properties.maxLines,
            style: parser.getTextStyleFromProperties(properties.textProperties),
            decoration: InputDecoration(
                hintText: properties.placeHolderTextProperties?.text,
                hintStyle: parser.getTextStyleFromProperties(
                    properties.placeHolderTextProperties),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ))));
  }
}
