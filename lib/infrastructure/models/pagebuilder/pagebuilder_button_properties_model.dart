import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_text_properties_model.dart';
import 'package:flutter/material.dart';

class PageBuilderButtonPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final double? width;
  final double? height;
  final double? borderRadius;
  final String? backgroundColor;
  final Map<String, dynamic>? textProperties;

  const PageBuilderButtonPropertiesModel({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.backgroundColor,
    required this.textProperties,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (width != null) map['width'] = width;
    if (height != null) map['height'] = height;
    if (borderRadius != null) map['borderRadius'] = borderRadius;
    if (backgroundColor != null) map['backgroundColor'] = backgroundColor;
    if (textProperties != null) map['textProperties'] = textProperties;
    return map;
  }

  factory PageBuilderButtonPropertiesModel.fromMap(Map<String, dynamic> map) {
    return PageBuilderButtonPropertiesModel(
        width: map['width'] != null ? map['width'] as double : null,
        height: map['height'] != null ? map['height'] as double : null,
        borderRadius:
            map['borderRadius'] != null ? map['borderRadius'] as double : null,
        backgroundColor: map['backgroundColor'] != null
            ? map['backgroundColor'] as String
            : null,
        textProperties: map['textProperties'] != null
            ? map['textProperties'] as Map<String, dynamic>
            : null);
  }

  PageBuilderButtonPropertiesModel copyWith({
    double? width,
    double? height,
    double? borderRadius,
    String? backgroundColor,
    Map<String, dynamic>? textProperties,
  }) {
    return PageBuilderButtonPropertiesModel(
      width: width ?? this.width,
      height: height ?? this.height,
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textProperties: textProperties ?? this.textProperties,
    );
  }

  PageBuilderButtonProperties toDomain() {
    return PageBuilderButtonProperties(
        width: width,
        height: height,
        borderRadius: borderRadius,
        backgroundColor: backgroundColor != null
            ? Color(ColorUtility.getHexIntFromString(backgroundColor!))
            : null,
        textProperties: textProperties != null
            ? PageBuilderTextPropertiesModel.fromMap(textProperties!).toDomain()
            : null);
  }

  factory PageBuilderButtonPropertiesModel.fromDomain(
      PageBuilderButtonProperties properties) {
    return PageBuilderButtonPropertiesModel(
        width: properties.width,
        height: properties.height,
        borderRadius: properties.borderRadius,
        backgroundColor: properties.backgroundColor?.toARGB32() != null
            ? properties.backgroundColor!.toARGB32().toRadixString(16)
            : null,
        textProperties: properties.textProperties != null
            ? PageBuilderTextPropertiesModel.fromDomain(
                    properties.textProperties!)
                .toMap()
            : null);
  }

  @override
  List<Object?> get props =>
      [width, height, borderRadius, backgroundColor, textProperties];
}
