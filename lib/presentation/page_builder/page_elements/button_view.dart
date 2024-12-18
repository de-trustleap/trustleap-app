// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/textstyle_parser.dart';
import 'package:flutter/material.dart';

class PageBuilderButtonView extends StatelessWidget {
  final PageBuilderButtonProperties properties;
  final PageBuilderWidget widgetModel;
  final TextStyleParser parser = TextStyleParser();

  PageBuilderButtonView({
    super.key,
    required this.properties,
    required this.widgetModel,
  });

  Alignment _getAlignment(TextAlign? textAlign) {
    switch (textAlign) {
      case TextAlign.left:
        return Alignment.centerLeft;
      case TextAlign.right:
        return Alignment.centerRight;
      case TextAlign.center:
        return Alignment.center;
      default:
        return Alignment.center;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: properties.width,
        height: properties.height,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
            color: properties.backgroundColor,
            borderRadius: BorderRadius.circular(properties.borderRadius ?? 0)),
        alignment: _getAlignment(properties.textProperties?.alignment),
        child: Text(properties.textProperties?.text ?? "",
            style:
                parser.getTextStyleFromProperties(properties.textProperties)));
  }
}
