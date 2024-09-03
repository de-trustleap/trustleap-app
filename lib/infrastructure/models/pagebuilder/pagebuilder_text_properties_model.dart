// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:flutter/material.dart';

class PageBuilderTextPropertiesModel extends Equatable implements PageBuilderProperties {
  final String? text;
  final double? fontSize;
  final String? color;
  final String? alignment;

  const PageBuilderTextPropertiesModel({
    this.text,
    this.fontSize,
    this.color,
    this.alignment
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'fontSize': fontSize,
      'color': color,
      'alignment': alignment
    };
  }

  factory PageBuilderTextPropertiesModel.fromMap(Map<String, dynamic> map) {
    return PageBuilderTextPropertiesModel(
        text: map['text'] != null ? map['text'] as String : null,
        fontSize: map['fontSize'] != null ? map['fontSize'] as double : null,
        color: map['color'] != null ? map['color'] as String : null,
        alignment: map['alignment'] != null ? map['alignment'] as String : null);
  }

  PageBuilderTextPropertiesModel copyWith({
    String? text,
    double? fontSize,
    String? color,
    String? alignment
  }) {
    return PageBuilderTextPropertiesModel(
      text: text ?? this.text,
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
      alignment: alignment ?? this.alignment
    );
  }

  factory PageBuilderTextPropertiesModel.fromFirestore(
      Map<String, dynamic> doc) {
    return PageBuilderTextPropertiesModel.fromMap(doc);
  }

  PageBuilderTextProperties toDomain() {
    return PageBuilderTextProperties(
        text: text,
        fontSize: fontSize,
        color: color != null ? Color(_getHexIntFromString(color!)) : null,
        alignment: _getTextAlignFromString(alignment));
  }

  factory PageBuilderTextPropertiesModel.fromDomain(
      PageBuilderTextProperties properties) {
    return PageBuilderTextPropertiesModel(
        text: properties.text,
        fontSize: properties.fontSize,
        color:
            properties.color?.value != null ? properties.color!.value.toString() : null);
  }

  int _getHexIntFromString(String hexCode) {
    final colorCode = int.tryParse(hexCode, radix: 16);
    return colorCode ?? 00000;
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

  @override
  List<Object?> get props => [text, fontSize, color];
}
