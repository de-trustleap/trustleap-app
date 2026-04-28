// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_faq_item.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_faq_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_paint_model.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_text_properties_model.dart';
import 'package:flutter/material.dart';

class PageBuilderFaqPropertiesModel extends Equatable implements PageBuilderProperties {
  final List<Map<String, dynamic>>? items;
  final Map<String, dynamic>? questionTextProperties;
  final Map<String, dynamic>? answerTextProperties;
  final String? chevronColor;
  final Map<String, dynamic>? questionBackgroundPaint;
  final Map<String, dynamic>? answerBackgroundPaint;
  final Map<String, dynamic>? borderPaint;

  const PageBuilderFaqPropertiesModel({
    required this.items,
    required this.questionTextProperties,
    required this.answerTextProperties,
    required this.chevronColor,
    required this.questionBackgroundPaint,
    required this.answerBackgroundPaint,
    required this.borderPaint,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (items != null) map['items'] = items;
    if (questionTextProperties != null) map['questionTextProperties'] = questionTextProperties;
    if (answerTextProperties != null) map['answerTextProperties'] = answerTextProperties;
    if (chevronColor != null) map['chevronColor'] = chevronColor;
    if (questionBackgroundPaint != null) map['questionBackgroundPaint'] = questionBackgroundPaint;
    if (answerBackgroundPaint != null) map['answerBackgroundPaint'] = answerBackgroundPaint;
    if (borderPaint != null) map['borderPaint'] = borderPaint;
    return map;
  }

  factory PageBuilderFaqPropertiesModel.fromMap(Map<String, dynamic> map) {
    return PageBuilderFaqPropertiesModel(
      items: map['items'] != null
          ? (map['items'] as List).map((e) => e as Map<String, dynamic>).toList()
          : null,
      questionTextProperties: map['questionTextProperties'] != null
          ? map['questionTextProperties'] as Map<String, dynamic>
          : null,
      answerTextProperties: map['answerTextProperties'] != null
          ? map['answerTextProperties'] as Map<String, dynamic>
          : null,
      chevronColor: map['chevronColor'] != null ? map['chevronColor'] as String : null,
      questionBackgroundPaint: map['questionBackgroundPaint'] != null
          ? map['questionBackgroundPaint'] as Map<String, dynamic>
          : null,
      answerBackgroundPaint: map['answerBackgroundPaint'] != null
          ? map['answerBackgroundPaint'] as Map<String, dynamic>
          : null,
      borderPaint: map['borderPaint'] != null
          ? map['borderPaint'] as Map<String, dynamic>
          : null,
    );
  }

  PageBuilderFaqProperties toDomain(PageBuilderGlobalStyles? globalStyles) {
    return PageBuilderFaqProperties(
      items: items
          ?.map((e) => PagebuilderFAQItem(
                question: e['question'] as String?,
                answer: e['answer'] as String?,
              ))
          .toList(),
      questionTextProperties: questionTextProperties != null
          ? PageBuilderTextPropertiesModel.fromMap(questionTextProperties!)
              .toDomain(globalStyles)
          : null,
      answerTextProperties: answerTextProperties != null
          ? PageBuilderTextPropertiesModel.fromMap(answerTextProperties!)
              .toDomain(globalStyles)
          : null,
      chevronColor: chevronColor != null
          ? Color(ColorUtility.getHexIntFromString(chevronColor!))
          : null,
      questionBackgroundPaint: questionBackgroundPaint != null
          ? PagebuilderPaintModel.fromMap(questionBackgroundPaint!).toDomain(globalStyles)
          : null,
      answerBackgroundPaint: answerBackgroundPaint != null
          ? PagebuilderPaintModel.fromMap(answerBackgroundPaint!).toDomain(globalStyles)
          : null,
      borderPaint: borderPaint != null
          ? PagebuilderPaintModel.fromMap(borderPaint!).toDomain(globalStyles)
          : null,
    );
  }

  factory PageBuilderFaqPropertiesModel.fromDomain(PageBuilderFaqProperties properties) {
    return PageBuilderFaqPropertiesModel(
      items: properties.items
          ?.map((e) => <String, dynamic>{
                if (e.question != null) 'question': e.question,
                if (e.answer != null) 'answer': e.answer,
              })
          .toList(),
      questionTextProperties: properties.questionTextProperties != null
          ? PageBuilderTextPropertiesModel.fromDomain(properties.questionTextProperties!)
              .toMap()
          : null,
      answerTextProperties: properties.answerTextProperties != null
          ? PageBuilderTextPropertiesModel.fromDomain(properties.answerTextProperties!)
              .toMap()
          : null,
      chevronColor: properties.chevronColor != null
          ? ColorUtility.colorToHex(properties.chevronColor!)
          : null,
      questionBackgroundPaint: properties.questionBackgroundPaint != null
          ? PagebuilderPaintModel.fromDomain(properties.questionBackgroundPaint!).toMap()
          : null,
      answerBackgroundPaint: properties.answerBackgroundPaint != null
          ? PagebuilderPaintModel.fromDomain(properties.answerBackgroundPaint!).toMap()
          : null,
      borderPaint: properties.borderPaint != null
          ? PagebuilderPaintModel.fromDomain(properties.borderPaint!).toMap()
          : null,
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
