// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_icon_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:flutter/material.dart';

class PageBuilderIconPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final String? code;
  final double? size;
  final String? color;

  const PageBuilderIconPropertiesModel({
    required this.code,
    required this.size,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (code != null) map['code'] = code;
    if (size != null) map['size'] = size;
    if (color != null) map['color'] = color;
    return map;
  }

  factory PageBuilderIconPropertiesModel.fromMap(Map<String, dynamic> map) {
    return PageBuilderIconPropertiesModel(
        code: map['code'] != null ? map['code'] as String : null,
        size: map['size'] != null ? map['size'] as double : null,
        color: map['color'] != null ? map['color'] as String : null);
  }

  PageBuilderIconPropertiesModel copyWith({
    String? code,
    double? size,
    String? color,
  }) {
    return PageBuilderIconPropertiesModel(
      code: code ?? this.code,
      size: size ?? this.size,
      color: color ?? this.color,
    );
  }

  PageBuilderIconProperties toDomain() {
    return PageBuilderIconProperties(
        code: code,
        size: size,
        color: color != null
            ? Color(ColorUtility.getHexIntFromString(color!))
            : null);
  }

  factory PageBuilderIconPropertiesModel.fromDomain(
      PageBuilderIconProperties properties) {
    return PageBuilderIconPropertiesModel(
        code: properties.code,
        size: properties.size,
        color: properties.color != null
            ? ColorUtility.colorToHex(properties.color!)
            : null);
  }

  @override
  List<Object?> get props => [code, size, color];
}
