import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_textfield_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_responsive_or_constant_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_text_properties_model.dart';
import 'package:flutter/material.dart';

class PageBuilderTextFieldPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final PagebuilderResponsiveOrConstantModel<double>? width;
  final int? minLines;
  final int? maxLines;
  final bool? isRequired;
  final String? backgroundColor;
  final String? borderColor;
  final Map<String, dynamic>? placeHolderTextProperties;
  final Map<String, dynamic>? textProperties;

  const PageBuilderTextFieldPropertiesModel({
    required this.width,
    required this.minLines,
    required this.maxLines,
    required this.isRequired,
    required this.backgroundColor,
    required this.borderColor,
    required this.placeHolderTextProperties,
    required this.textProperties,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (width != null) map['width'] = width!.toMapValue();
    if (minLines != null) map['minLines'] = minLines;
    if (maxLines != null) map['maxLines'] = maxLines;
    if (isRequired != null) map['isRequired'] = isRequired;
    if (backgroundColor != null) map['backgroundColor'] = backgroundColor;
    if (borderColor != null) map['borderColor'] = borderColor;
    if (placeHolderTextProperties != null) {
      map['placeHolderTextProperties'] = placeHolderTextProperties;
    }
    if (textProperties != null) map['textProperties'] = textProperties;
    return map;
  }

  factory PageBuilderTextFieldPropertiesModel.fromMap(
      Map<String, dynamic> map) {
    return PageBuilderTextFieldPropertiesModel(
        width: PagebuilderResponsiveOrConstantModel.fromMapValue(
            map['width'], (v) => v as double),
        minLines: map['minLines'] != null ? map['minLines'] as int : null,
        maxLines: map['maxLines'] != null ? map['maxLines'] as int : null,
        isRequired:
            map['isRequired'] != null ? map['isRequired'] as bool : null,
        backgroundColor: map['backgroundColor'] != null
            ? map['backgroundColor'] as String
            : null,
        borderColor:
            map['borderColor'] != null ? map['borderColor'] as String : null,
        placeHolderTextProperties: map['placeHolderTextProperties'] != null
            ? map['placeHolderTextProperties'] as Map<String, dynamic>
            : null,
        textProperties: map['textProperties'] != null
            ? map['textProperties'] as Map<String, dynamic>
            : null);
  }

  PageBuilderTextFieldPropertiesModel copyWith({
    PagebuilderResponsiveOrConstantModel<double>? width,
    int? minLines,
    int? maxLines,
    bool? isRequired,
    String? backgroundColor,
    String? borderColor,
    Map<String, dynamic>? placeHolderTextProperties,
    Map<String, dynamic>? textProperties,
  }) {
    return PageBuilderTextFieldPropertiesModel(
      width: width ?? this.width,
      minLines: minLines ?? this.minLines,
      maxLines: maxLines ?? this.maxLines,
      isRequired: isRequired ?? this.isRequired,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      placeHolderTextProperties:
          placeHolderTextProperties ?? this.placeHolderTextProperties,
      textProperties: textProperties ?? this.textProperties,
    );
  }

  PageBuilderTextFieldProperties toDomain(
      PageBuilderGlobalStyles? globalStyles) {
    Color? resolvedBackgroundColor;
    String? bgToken;
    if (backgroundColor != null) {
      if (backgroundColor!.startsWith('@')) {
        bgToken = backgroundColor;
        resolvedBackgroundColor =
            globalStyles?.resolveColorReference(backgroundColor!);
      } else {
        resolvedBackgroundColor =
            Color(ColorUtility.getHexIntFromString(backgroundColor!));
        bgToken = null;
      }
    }

    Color? resolvedBorderColor;
    String? borderToken;
    if (borderColor != null) {
      if (borderColor!.startsWith('@')) {
        borderToken = borderColor;
        resolvedBorderColor = globalStyles?.resolveColorReference(borderColor!);
      } else {
        resolvedBorderColor =
            Color(ColorUtility.getHexIntFromString(borderColor!));
        borderToken = null;
      }
    }

    return PageBuilderTextFieldProperties(
        width: width?.toDomain(),
        minLines: minLines,
        maxLines: maxLines,
        isRequired: isRequired,
        backgroundColor: resolvedBackgroundColor,
        globalBackgroundColorToken: bgToken,
        borderColor: resolvedBorderColor,
        globalBorderColorToken: borderToken,
        placeHolderTextProperties: placeHolderTextProperties != null
            ? PageBuilderTextPropertiesModel.fromMap(placeHolderTextProperties!)
                .toDomain(globalStyles)
            : null,
        textProperties: textProperties != null
            ? PageBuilderTextPropertiesModel.fromMap(textProperties!)
                .toDomain(globalStyles)
            : null);
  }

  factory PageBuilderTextFieldPropertiesModel.fromDomain(
      PageBuilderTextFieldProperties properties) {
    final bgColorValue = properties.globalBackgroundColorToken ??
        (properties.backgroundColor != null
            ? ColorUtility.colorToHex(properties.backgroundColor!)
            : null);
    final borderColorValue = properties.globalBorderColorToken ??
        (properties.borderColor != null
            ? ColorUtility.colorToHex(properties.borderColor!)
            : null);

    return PageBuilderTextFieldPropertiesModel(
        width:
            PagebuilderResponsiveOrConstantModel.fromDomain(properties.width),
        minLines: properties.minLines,
        maxLines: properties.maxLines,
        isRequired: properties.isRequired,
        backgroundColor: bgColorValue,
        borderColor: borderColorValue,
        placeHolderTextProperties: properties.placeHolderTextProperties != null
            ? PageBuilderTextPropertiesModel.fromDomain(
                    properties.placeHolderTextProperties!)
                .toMap()
            : null,
        textProperties: properties.textProperties != null
            ? PageBuilderTextPropertiesModel.fromDomain(
                    properties.textProperties!)
                .toMap()
            : null);
  }

  @override
  List<Object?> get props => [
        width,
        minLines,
        maxLines,
        isRequired,
        backgroundColor,
        borderColor,
        placeHolderTextProperties,
        textProperties
      ];
}
