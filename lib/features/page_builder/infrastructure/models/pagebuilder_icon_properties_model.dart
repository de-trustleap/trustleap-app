// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_icon_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_responsive_or_constant_model.dart';
import 'package:flutter/material.dart';

class PageBuilderIconPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final String? code;
  final PagebuilderResponsiveOrConstantModel<double>? size;
  final String? color;

  const PageBuilderIconPropertiesModel({
    required this.code,
    required this.size,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (code != null) map['code'] = code;
    if (size != null) map['size'] = size!.toMapValue();
    if (color != null) map['color'] = color;
    return map;
  }

  factory PageBuilderIconPropertiesModel.fromMap(Map<String, dynamic> map) {
    return PageBuilderIconPropertiesModel(
        code: map['code'] != null ? map['code'] as String : null,
        size: PagebuilderResponsiveOrConstantModel.fromMapValue(
            map['size'], (v) => v as double),
        color: map['color'] != null ? map['color'] as String : null);
  }

  PageBuilderIconPropertiesModel copyWith({
    String? code,
    PagebuilderResponsiveOrConstantModel<double>? size,
    String? color,
  }) {
    return PageBuilderIconPropertiesModel(
      code: code ?? this.code,
      size: size ?? this.size,
      color: color ?? this.color,
    );
  }

  PageBuilderIconProperties toDomain(PageBuilderGlobalStyles? globalStyles) {
    Color? resolvedColor;
    String? token;
    if (color != null) {
      if (color!.startsWith('@')) {
        token = color;
        resolvedColor = globalStyles?.resolveColorReference(color!);
      } else {
        resolvedColor = Color(ColorUtility.getHexIntFromString(color!));
        token = null;
      }
    }

    return PageBuilderIconProperties(
        code: code,
        size: size?.toDomain(),
        color: resolvedColor,
        globalColorToken: token);
  }

  factory PageBuilderIconPropertiesModel.fromDomain(
      PageBuilderIconProperties properties) {
    final colorValue = properties.globalColorToken ??
        (properties.color != null
            ? ColorUtility.colorToHex(properties.color!)
            : null);

    return PageBuilderIconPropertiesModel(
        code: properties.code,
        size: PagebuilderResponsiveOrConstantModel.fromDomain(properties.size),
        color: colorValue);
  }

  @override
  List<Object?> get props => [code, size, color];
}
