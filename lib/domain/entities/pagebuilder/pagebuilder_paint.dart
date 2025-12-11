// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_gradient.dart';
import 'package:flutter/material.dart';

class PagebuilderPaint extends Equatable {
  final Color? color;
  final String? globalColorToken; // "@primary", "@secondary", etc. or null if not a token
  final PagebuilderGradient? gradient;

  const PagebuilderPaint({
    this.color,
    this.globalColorToken,
    this.gradient,
  });

  const PagebuilderPaint.color(this.color, {this.globalColorToken}) : gradient = null;
  const PagebuilderPaint.gradient(this.gradient) : color = null, globalColorToken = null;

  bool get isColor => color != null;
  bool get isGradient => gradient != null;

  PagebuilderPaint copyWith({
    Color? color,
    String? globalColorToken,
    PagebuilderGradient? gradient,
    bool setColorNull = false,
    bool setGlobalColorTokenNull = false,
    bool setGradientNull = false,
  }) {
    return PagebuilderPaint(
      color: setColorNull ? null : (color ?? this.color),
      globalColorToken: setGlobalColorTokenNull ? null : (globalColorToken ?? this.globalColorToken),
      gradient: setGradientNull ? null : (gradient ?? this.gradient),
    );
  }

  PagebuilderPaint deepCopy() {
    return PagebuilderPaint(
      color: color != null ? Color(color!.toARGB32()) : null,
      globalColorToken: globalColorToken,
      gradient: gradient?.deepCopy(),
    );
  }

  @override
  List<Object?> get props => [color, globalColorToken, gradient];
}
