// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_padding.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:flutter/material.dart';

class PageBuilderTextPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final String? text;
  final double? fontSize;
  final String? color;
  final String? alignment;
  final Map<String, dynamic>? padding;

  const PageBuilderTextPropertiesModel(
      {this.text, this.fontSize, this.color, this.alignment, this.padding});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (text != null) map['text'] = text;
    if (fontSize != null) map['fontSize'] = fontSize;
    if (color != null) map['color'] = color;
    if (alignment != null) map['alignment'] = alignment;
    if (padding != null) map['padding'] = padding;
    return map;
  }

  factory PageBuilderTextPropertiesModel.fromMap(Map<String, dynamic> map) {
    return PageBuilderTextPropertiesModel(
        text: map['text'] != null ? map['text'] as String : null,
        fontSize: map['fontSize'] != null ? map['fontSize'] as double : null,
        color: map['color'] != null ? map['color'] as String : null,
        alignment: map['alignment'] != null ? map['alignment'] as String : null,
        padding: map['padding'] != null
            ? map['padding'] as Map<String, dynamic>
            : null);
  }

  PageBuilderTextPropertiesModel copyWith(
      {String? text,
      double? fontSize,
      String? color,
      String? alignment,
      Map<String, double>? padding}) {
    return PageBuilderTextPropertiesModel(
        text: text ?? this.text,
        fontSize: fontSize ?? this.fontSize,
        color: color ?? this.color,
        alignment: alignment ?? this.alignment,
        padding: padding ?? this.padding);
  }

  PageBuilderTextProperties toDomain() {
    return PageBuilderTextProperties(
        text: text,
        fontSize: fontSize,
        color: color != null ? Color(ColorUtility.getHexIntFromString(color!)) : null,
        alignment: _getTextAlignFromString(alignment),
        padding: PageBuilderPadding.fromMap(padding));
  }

  factory PageBuilderTextPropertiesModel.fromDomain(
      PageBuilderTextProperties properties) {
    return PageBuilderTextPropertiesModel(
        text: properties.text,
        fontSize: properties.fontSize,
        color: properties.color?.value != null
            ? properties.color!.value.toString()
            : null,
        alignment: properties.alignment?.name,
        padding: _getMapFromPadding(properties.padding));
  }

  TextAlign _getTextAlignFromString(String? alignment) {
    switch (alignment) {
      case "center":
        return TextAlign.center;
      case "right":
        return TextAlign.right;
      case "left":
      default:
        return TextAlign.left;
    }
  }

  static Map<String, dynamic>? _getMapFromPadding(PageBuilderPadding? padding) {
    if (padding == null) {
      return null;
    }
    Map<String, dynamic> map = {};
    if (padding.top != null && padding.top != 0) map['top'] = padding.top;
    if (padding.bottom != null && padding.top != 0) map['bottom'] = padding.bottom;
    if (padding.left != null && padding.top != 0) map['left'] = padding.left;
    if (padding.right != null && padding.top != 0) map['right'] = padding.right;
    if (map.isEmpty) {
      return null;
    } else {
      return map;
    }
  }

  @override
  List<Object?> get props => [text, fontSize, color, alignment, padding];
}
