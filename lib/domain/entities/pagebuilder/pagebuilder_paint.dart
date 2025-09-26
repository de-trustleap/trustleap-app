// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_gradient.dart';
import 'package:flutter/material.dart';

class PagebuilderPaint extends Equatable {
  final Color? color;
  final PagebuilderGradient? gradient;

  const PagebuilderPaint({
    this.color,
    this.gradient,
  });

  const PagebuilderPaint.color(this.color) : gradient = null;
  const PagebuilderPaint.gradient(this.gradient) : color = null;

  bool get isColor => color != null;
  bool get isGradient => gradient != null;

  PagebuilderPaint copyWith({
    Color? color,
    PagebuilderGradient? gradient,
    bool setColorNull = false,
    bool setGradientNull = false,
  }) {
    return PagebuilderPaint(
      color: setColorNull ? null : (color ?? this.color),
      gradient: setGradientNull ? null : (gradient ?? this.gradient),
    );
  }

  PagebuilderPaint deepCopy() {
    return PagebuilderPaint(
      color: color != null ? Color(color!.toARGB32()) : null,
      gradient: gradient?.deepCopy(),
    );
  }

  @override
  List<Object?> get props => [color, gradient];
}
