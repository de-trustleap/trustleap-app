// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_paint.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_gradient_model.dart';
import 'package:flutter/material.dart';

class PagebuilderPaintModel extends Equatable {
  final String? color;
  final Map<String, dynamic>? gradient;

  const PagebuilderPaintModel({
    this.color,
    this.gradient,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (color != null) map["color"] = color;
    if (gradient != null) map["gradient"] = gradient;
    return map;
  }

  factory PagebuilderPaintModel.fromMap(Map<String, dynamic> map) {
    return PagebuilderPaintModel(
      color: map["color"] != null ? map["color"] as String : null,
      gradient: map["gradient"] != null
          ? map["gradient"] as Map<String, dynamic>
          : null,
    );
  }

  PagebuilderPaintModel copyWith({
    String? color,
    Map<String, dynamic>? gradient,
  }) {
    return PagebuilderPaintModel(
      color: color ?? this.color,
      gradient: gradient ?? this.gradient,
    );
  }

  PagebuilderPaint toDomain(PageBuilderGlobalStyles? globalStyles) {
    if (color != null) {
      Color resolvedColor;
      String? token;

      if (color!.startsWith('@')) {
        token = color;
        final tokenColor = globalStyles?.resolveColorReference(color!);
        resolvedColor = tokenColor ?? Colors.transparent;
      } else {
        resolvedColor = Color(ColorUtility.getHexIntFromString(color!));
        token = null;
      }

      return PagebuilderPaint.color(resolvedColor, globalColorToken: token);
    } else if (gradient != null) {
      return PagebuilderPaint.gradient(
          PagebuilderGradientModel.fromMap(gradient!).toDomain(globalStyles));
    }

    return const PagebuilderPaint.color(Colors.transparent);
  }

  factory PagebuilderPaintModel.fromDomain(PagebuilderPaint paint) {
    if (paint.isColor) {
      final colorValue =
          paint.globalColorToken ?? ColorUtility.colorToHex(paint.color!);
      return PagebuilderPaintModel(
        color: colorValue,
        gradient: null,
      );
    } else if (paint.isGradient) {
      return PagebuilderPaintModel(
        color: null,
        gradient: PagebuilderGradientModel.fromDomain(paint.gradient!).toMap(),
      );
    }

    return const PagebuilderPaintModel(
      color: "00000000",
      gradient: null,
    );
  }

  @override
  List<Object?> get props => [color, gradient];
}
