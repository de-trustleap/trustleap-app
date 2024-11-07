// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:flutter/material.dart';

class PageBuilderTextPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final String? text;
  final double? fontSize;
  final String? fontFamily;
  final double? lineHeight;
  final String? color;
  final String? alignment;
  final bool? isBold;
  final bool? isItalic;

  const PageBuilderTextPropertiesModel(
      {required this.text,
      required this.fontSize,
      required this.fontFamily,
      required this.lineHeight,
      required this.color,
      required this.alignment,
      required this.isBold,
      required this.isItalic});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (text != null) map['text'] = text;
    if (fontSize != null) map['fontSize'] = fontSize;
    if (fontFamily != null) map['fontFamily'] = fontFamily;
    if (lineHeight != null) map['lineHeight'] = lineHeight;
    if (color != null) map['color'] = color;
    if (alignment != null) map['alignment'] = alignment;
    if (isBold != null) map['isBold'] = isBold;
    if (isItalic != null) map['isItalic'] = isItalic;
    return map;
  }

  factory PageBuilderTextPropertiesModel.fromMap(Map<String, dynamic> map) {
    return PageBuilderTextPropertiesModel(
        text: map['text'] != null ? map['text'] as String : null,
        fontSize: map['fontSize'] != null ? map['fontSize'] as double : null,
        fontFamily:
            map['fontFamily'] != null ? map['fontFamily'] as String : null,
        lineHeight:
            map['lineHeight'] != null ? map['lineHeight'] as double : null,
        color: map['color'] != null ? map['color'] as String : null,
        alignment: map['alignment'] != null ? map['alignment'] as String : null,
        isBold: map['isBold'] != null ? map['isBold'] as bool : null,
        isItalic: map['isItalic'] != null ? map['isItalic'] as bool : null);
  }

  PageBuilderTextPropertiesModel copyWith(
      {String? text,
      double? fontSize,
      String? fontFamily,
      double? lineHeight,
      String? color,
      String? alignment,
      bool? isBold,
      bool? isItalic}) {
    return PageBuilderTextPropertiesModel(
        text: text ?? this.text,
        fontSize: fontSize ?? this.fontSize,
        fontFamily: fontFamily ?? this.fontFamily,
        lineHeight: lineHeight ?? this.lineHeight,
        color: color ?? this.color,
        alignment: alignment ?? this.alignment,
        isBold: isBold ?? this.isBold,
        isItalic: isItalic ?? this.isItalic);
  }

  PageBuilderTextProperties toDomain() {
    return PageBuilderTextProperties(
        text: text,
        fontSize: fontSize,
        fontFamily: fontFamily,
        lineHeight: lineHeight,
        color: color != null
            ? Color(ColorUtility.getHexIntFromString(color!))
            : null,
        alignment: getTextAlignFromString(alignment),
        isBold: isBold,
        isItalic: isItalic);
  }

  factory PageBuilderTextPropertiesModel.fromDomain(
      PageBuilderTextProperties properties) {
    return PageBuilderTextPropertiesModel(
        text: properties.text,
        fontSize: properties.fontSize,
        fontFamily: properties.fontFamily,
        lineHeight: properties.lineHeight,
        color: properties.color?.value != null
            ? properties.color!.value.toRadixString(16)
            : null,
        alignment: properties.alignment?.name,
        isBold: properties.isBold,
        isItalic: properties.isItalic);
  }

  TextAlign getTextAlignFromString(String? alignment) {
    switch (alignment) {
      case "center":
        return TextAlign.center;
      case "right":
        return TextAlign.right;
      case "justify":
        return TextAlign.justify;
      case "left":
      default:
        return TextAlign.left;
    }
  }

  @override
  List<Object?> get props => [
        text,
        fontSize,
        fontFamily,
        lineHeight,
        color,
        alignment,
        isBold,
        isItalic
      ];
}
