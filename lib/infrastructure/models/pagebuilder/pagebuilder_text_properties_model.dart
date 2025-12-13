// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/infrastructure/models/model_helper/shadow_mapper.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_responsive_or_constant_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_shadow_model.dart';
import 'package:flutter/material.dart';

class PageBuilderTextPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final String? text;
  final PagebuilderResponsiveOrConstantModel<double>? fontSize;
  final String? fontFamily;
  final PagebuilderResponsiveOrConstantModel<double>? lineHeight;
  final PagebuilderResponsiveOrConstantModel<double>? letterSpacing;
  final String? color;
  final PagebuilderResponsiveOrConstantModel<String>? alignment;
  final Map<String, dynamic>? textShadow;
  final String? globalColorToken;

  const PageBuilderTextPropertiesModel({
    required this.text,
    required this.fontSize,
    required this.fontFamily,
    required this.lineHeight,
    required this.letterSpacing,
    required this.color,
    required this.alignment,
    required this.textShadow,
    this.globalColorToken,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (text != null) map['text'] = text;
    if (fontSize != null) map['fontSize'] = fontSize!.toMapValue();
    if (fontFamily != null) map['fontFamily'] = fontFamily;
    if (lineHeight != null) map['lineHeight'] = lineHeight!.toMapValue();
    if (letterSpacing != null) {
      map['letterSpacing'] = letterSpacing!.toMapValue();
    }
    if (color != null) map['color'] = color;
    if (alignment != null) map['alignment'] = alignment!.toMapValue();
    if (textShadow != null) map['textShadow'] = textShadow;
    return map;
  }

  factory PageBuilderTextPropertiesModel.fromMap(Map<String, dynamic> map) {
    return PageBuilderTextPropertiesModel(
      text: map['text'] != null ? map['text'] as String : null,
      fontSize: PagebuilderResponsiveOrConstantModel.fromMapValue(
        map['fontSize'],
        (v) => v as double,
      ),
      fontFamily:
          map['fontFamily'] != null ? map['fontFamily'] as String : null,
      lineHeight: PagebuilderResponsiveOrConstantModel.fromMapValue(
        map['lineHeight'],
        (v) => v as double,
      ),
      letterSpacing: PagebuilderResponsiveOrConstantModel.fromMapValue(
        map['letterSpacing'],
        (v) => v as double,
      ),
      color: map['color'] != null ? map['color'] as String : null,
      alignment: PagebuilderResponsiveOrConstantModel.fromMapValue(
            map['alignment'],
            (v) => v as String,
          ) ??
          const PagebuilderResponsiveOrConstantModel.constant("left"),
      textShadow: map['textShadow'] != null
          ? map['textShadow'] as Map<String, dynamic>
          : null,
    );
  }

  PageBuilderTextPropertiesModel copyWith({
    String? text,
    PagebuilderResponsiveOrConstantModel<double>? fontSize,
    String? fontFamily,
    PagebuilderResponsiveOrConstantModel<double>? lineHeight,
    PagebuilderResponsiveOrConstantModel<double>? letterSpacing,
    String? color,
    PagebuilderResponsiveOrConstantModel<String>? alignment,
    Map<String, dynamic>? textShadow,
  }) {
    return PageBuilderTextPropertiesModel(
      text: text ?? this.text,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      lineHeight: lineHeight ?? this.lineHeight,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      color: color ?? this.color,
      alignment: alignment ?? this.alignment,
      textShadow: textShadow ?? this.textShadow,
    );
  }

  PageBuilderTextProperties toDomain(PageBuilderGlobalStyles? globalStyles) {
    Color? resolvedColor;
    String? colorToken;
    if (color != null) {
      if (color!.startsWith('@')) {
        colorToken = color;
        resolvedColor = globalStyles?.resolveColorReference(color!);
      } else {
        resolvedColor = Color(ColorUtility.getHexIntFromString(color!));
        colorToken = null;
      }
    }

    String? resolvedFontFamily;
    String? fontToken;
    if (fontFamily != null) {
      if (fontFamily!.startsWith('@')) {
        fontToken = fontFamily;
        resolvedFontFamily = globalStyles?.resolveFontReference(fontFamily!);
        resolvedFontFamily ??= "Roboto";
      } else {
        resolvedFontFamily = fontFamily;
        fontToken = null;
      }
    }

    return PageBuilderTextProperties(
      text: text,
      fontSize: fontSize?.toDomain(),
      fontFamily: resolvedFontFamily,
      globalFontToken: fontToken,
      lineHeight: lineHeight?.toDomain(),
      letterSpacing: letterSpacing?.toDomain(),
      color: resolvedColor,
      globalColorToken: colorToken,
      alignment: _alignmentToDomain(alignment),
      textShadow: textShadow != null
          ? PageBuilderShadowModel.fromMap(textShadow!).toDomain(globalStyles)
          : null,
    );
  }

  PagebuilderResponsiveOrConstant<TextAlign>? _alignmentToDomain(
      PagebuilderResponsiveOrConstantModel<String>? alignmentModel) {
    if (alignmentModel == null) return null;

    if (alignmentModel.constantValue != null) {
      return PagebuilderResponsiveOrConstant.constant(
          getTextAlignFromString(alignmentModel.constantValue));
    }

    if (alignmentModel.responsiveValue != null) {
      return PagebuilderResponsiveOrConstant.responsive({
        if (alignmentModel.responsiveValue!["mobile"] != null)
          "mobile":
              getTextAlignFromString(alignmentModel.responsiveValue!["mobile"]),
        if (alignmentModel.responsiveValue!["tablet"] != null)
          "tablet":
              getTextAlignFromString(alignmentModel.responsiveValue!["tablet"]),
        if (alignmentModel.responsiveValue!["desktop"] != null)
          "desktop": getTextAlignFromString(
              alignmentModel.responsiveValue!["desktop"]),
      });
    }

    return null;
  }

  factory PageBuilderTextPropertiesModel.fromDomain(
      PageBuilderTextProperties properties) {
    final colorValue = properties.globalColorToken ??
        (properties.color != null
            ? ColorUtility.colorToHex(properties.color!)
            : null);

    final fontValue = properties.globalFontToken ?? properties.fontFamily;

    return PageBuilderTextPropertiesModel(
      text: properties.text,
      fontSize:
          PagebuilderResponsiveOrConstantModel.fromDomain(properties.fontSize),
      fontFamily: fontValue,
      lineHeight: PagebuilderResponsiveOrConstantModel.fromDomain(
          properties.lineHeight),
      letterSpacing: PagebuilderResponsiveOrConstantModel.fromDomain(
          properties.letterSpacing),
      color: colorValue,
      globalColorToken: properties.globalColorToken,
      alignment: _alignmentFromDomain(properties.alignment),
      textShadow: ShadowMapper.getMapFromShadow(properties.textShadow),
    );
  }

  static PagebuilderResponsiveOrConstantModel<String>? _alignmentFromDomain(
      PagebuilderResponsiveOrConstant<TextAlign>? alignment) {
    if (alignment == null) return null;

    if (alignment.constantValue != null) {
      return PagebuilderResponsiveOrConstantModel.constant(
          alignment.constantValue!.name);
    }

    if (alignment.responsiveValue != null) {
      return PagebuilderResponsiveOrConstantModel.responsive({
        if (alignment.responsiveValue!["mobile"] != null)
          "mobile": alignment.responsiveValue!["mobile"]!.name,
        if (alignment.responsiveValue!["tablet"] != null)
          "tablet": alignment.responsiveValue!["tablet"]!.name,
        if (alignment.responsiveValue!["desktop"] != null)
          "desktop": alignment.responsiveValue!["desktop"]!.name,
      });
    }

    return null;
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
        letterSpacing,
        color,
        alignment,
        textShadow,
      ];
}
