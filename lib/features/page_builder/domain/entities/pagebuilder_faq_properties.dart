import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_faq_item.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_paint.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:flutter/material.dart';

class PageBuilderFaqProperties extends Equatable implements PageBuilderProperties {
  final List<PagebuilderFAQItem>? items;
  final PageBuilderTextProperties? questionTextProperties;
  final PageBuilderTextProperties? answerTextProperties;
  final Color? chevronColor;
  final PagebuilderPaint? questionBackgroundPaint;
  final PagebuilderPaint? answerBackgroundPaint;
  final PagebuilderPaint? borderPaint;

  const PageBuilderFaqProperties({
    required this.items,
    required this.questionTextProperties,
    required this.answerTextProperties,
    required this.chevronColor,
    required this.questionBackgroundPaint,
    required this.answerBackgroundPaint,
    required this.borderPaint,
  });

  PageBuilderFaqProperties copyWith({
    List<PagebuilderFAQItem>? items,
    PageBuilderTextProperties? questionTextProperties,
    PageBuilderTextProperties? answerTextProperties,
    Color? chevronColor,
    PagebuilderPaint? questionBackgroundPaint,
    PagebuilderPaint? answerBackgroundPaint,
    PagebuilderPaint? borderPaint,
  }) {
    return PageBuilderFaqProperties(
      items: items ?? this.items,
      questionTextProperties: questionTextProperties ?? this.questionTextProperties,
      answerTextProperties: answerTextProperties ?? this.answerTextProperties,
      chevronColor: chevronColor ?? this.chevronColor,
      questionBackgroundPaint: questionBackgroundPaint ?? this.questionBackgroundPaint,
      answerBackgroundPaint: answerBackgroundPaint ?? this.answerBackgroundPaint,
      borderPaint: borderPaint ?? this.borderPaint,
    );
  }

  @override
  List<Object?> get props => [
        items,
        questionTextProperties,
        answerTextProperties,
        chevronColor,
        questionBackgroundPaint,
        answerBackgroundPaint,
        borderPaint,
      ];
}
