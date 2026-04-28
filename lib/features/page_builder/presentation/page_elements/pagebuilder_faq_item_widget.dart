import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_faq_item.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_faq_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/responsive/pagebuilder_responsive_or_constant_extensions.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/page_elements/textstyle_parser.dart';
import 'package:flutter/material.dart';

class PagebuilderFaqItemWidget extends StatelessWidget {
  final PagebuilderFAQItem item;
  final PageBuilderFaqProperties properties;
  final bool isLast;

  const PagebuilderFaqItemWidget({
    super.key,
    required this.item,
    required this.properties,
    required this.isLast,
  });

  BoxDecoration _buildDecoration({required bool isQuestion}) {
    final paint = isQuestion
        ? properties.questionBackgroundPaint
        : properties.answerBackgroundPaint;
    final borderPaint = properties.borderPaint;

    final borderSide = borderPaint?.isColor == true
        ? BorderSide(color: borderPaint!.color!, width: 1)
        : BorderSide.none;

    return BoxDecoration(
      color: paint?.isColor == true ? paint?.color : null,
      gradient:
          paint?.isGradient == true ? paint?.gradient?.toFlutterGradient() : null,
      border: Border(
        left: borderSide,
        right: borderSide,
        top: borderSide,
        bottom: !isLast ? borderSide : BorderSide.none,
      ),
    );
  }

  TextStyle _textStyle(PageBuilderTextProperties? props) {
    return TextStyleParser().getTextStyleFromProperties(props);
  }

  @override
  Widget build(BuildContext context) {
    final indicatorColor = properties.chevronColor ?? Colors.black;
    final questionAlign = properties.questionTextProperties?.alignment?.getValue();
    final answerAlign = properties.answerTextProperties?.alignment?.getValue();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: _buildDecoration(isQuestion: true),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: SelectableText(
                  item.question ?? "",
                  textAlign: questionAlign,
                  style: _textStyle(properties.questionTextProperties),
                ),
              ),
              Icon(Icons.expand_less, color: indicatorColor),
            ],
          ),
        ),
        Container(
          decoration: _buildDecoration(isQuestion: false),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SelectableText(
            item.answer ?? "",
            textAlign: answerAlign,
            style: _textStyle(properties.answerTextProperties),
          ),
        ),
      ],
    );
  }
}
