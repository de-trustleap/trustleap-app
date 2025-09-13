// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_shadow.dart';
import 'package:flutter/material.dart';

class PageBuilderShadowModel extends Equatable {
  final String? color;
  final double? spreadRadius;
  final double? blurRadius;
  final Map<String, dynamic>? offset;

  const PageBuilderShadowModel({
    required this.color,
    required this.spreadRadius,
    required this.blurRadius,
    required this.offset,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (color != null) map['color'] = color;
    if (spreadRadius != null) map['spreadRadius'] = spreadRadius;
    if (blurRadius != null) map['blurRadius'] = blurRadius;
    if (offset != null) map['offset'] = offset;

    return map;
  }

  factory PageBuilderShadowModel.fromMap(Map<String, dynamic> map) {
    return PageBuilderShadowModel(
        color: map['color'] != null ? map['color'] as String : null,
        spreadRadius:
            map['spreadRadius'] != null ? map['spreadRadius'] as double : null,
        blurRadius:
            map['blurRadius'] != null ? map['blurRadius'] as double : null,
        offset: map['offset'] != null
            ? map['offset'] as Map<String, dynamic>
            : null);
  }

  PageBuilderShadowModel copyWith({
    String? color,
    double? spreadRadius,
    double? blurRadius,
    Map<String, dynamic>? offset,
  }) {
    return PageBuilderShadowModel(
      color: color ?? this.color,
      spreadRadius: spreadRadius ?? this.spreadRadius,
      blurRadius: blurRadius ?? this.blurRadius,
      offset: offset ?? this.offset,
    );
  }

  PageBuilderShadow toDomain() {
    return PageBuilderShadow(
        color: color != null
            ? Color(ColorUtility.getHexIntFromString(color!))
            : null,
        spreadRadius: spreadRadius,
        blurRadius: blurRadius,
        offset: _mapToOffset(offset));
  }

  factory PageBuilderShadowModel.fromDomain(PageBuilderShadow shadow) {
    return PageBuilderShadowModel(
        color: shadow.color != null
            ? ColorUtility.colorToHex(shadow.color!)
            : null,
        spreadRadius: shadow.spreadRadius,
        blurRadius: shadow.blurRadius,
        offset: _offsetToMap(shadow.offset));
  }

  Offset? _mapToOffset(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final x = map['x'];
    final y = map['y'];
    if (x == null && y == null) {
      return null;
    }
    if (x is num && y is num) {
      return Offset(x.toDouble(), y.toDouble());
    } else {
      return null;
    }
  }

  static Map<String, dynamic>? _offsetToMap(Offset? offset) {
    if (offset == null) {
      return null;
    } else {
      return {"x": offset.dx, "y": offset.dy};
    }
  }

  @override
  List<Object?> get props => [color, spreadRadius, blurRadius, offset];
}
