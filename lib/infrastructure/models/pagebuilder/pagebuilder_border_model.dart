import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_border.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:flutter/material.dart';

class PagebuilderBorderModel extends Equatable {
  final double? width;
  final double? radius;
  final String? color;

  const PagebuilderBorderModel({
    required this.width,
    required this.radius,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (width != null) map['width'] = width;
    if (radius != null) map['radius'] = radius;
    if (color != null) map['color'] = color;

    return map;
  }

  factory PagebuilderBorderModel.fromMap(Map<String, dynamic> map) {
    return PagebuilderBorderModel(
      width: map['width'] != null ? map['width'] as double : null,
      radius: map['radius'] != null ? map['radius'] as double : null,
      color: map['color'] != null ? map['color'] as String : null,
    );
  }

  PagebuilderBorderModel copyWith({
    double? width,
    double? radius,
    String? color,
  }) {
    return PagebuilderBorderModel(
      width: width ?? this.width,
      radius: radius ?? this.radius,
      color: color ?? this.color,
    );
  }

  PagebuilderBorder toDomain(PageBuilderGlobalStyles? globalStyles) {
    Color? resolvedColor;
    String? token;

    if (color != null) {
      if (color!.startsWith('@')) {
        token = color;
        final tokenColor = globalStyles?.resolveColorReference(color!);
        resolvedColor = tokenColor ?? Colors.transparent;
      } else {
        resolvedColor = Color(ColorUtility.getHexIntFromString(color!));
        token = null;
      }
    }

    return PagebuilderBorder(
      width: width,
      radius: radius,
      color: resolvedColor,
      globalColorToken: token,
    );
  }

  factory PagebuilderBorderModel.fromDomain(PagebuilderBorder border) {
    final colorValue = border.color != null
        ? (border.globalColorToken ?? ColorUtility.colorToHex(border.color!))
        : null;

    return PagebuilderBorderModel(
      width: border.width,
      radius: border.radius,
      color: colorValue,
    );
  }

  @override
  List<Object?> get props => [width, radius, color];
}
