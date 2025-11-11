import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_border.dart';
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

  PagebuilderBorder toDomain() {
    return PagebuilderBorder(
      width: width,
      radius: radius,
      color: color != null
          ? Color(ColorUtility.getHexIntFromString(color!))
          : null,
    );
  }

  factory PagebuilderBorderModel.fromDomain(PagebuilderBorder border) {
    return PagebuilderBorderModel(
      width: border.width,
      radius: border.radius,
      color:
          border.color != null ? ColorUtility.colorToHex(border.color!) : null,
    );
  }

  @override
  List<Object?> get props => [width, radius, color];
}
