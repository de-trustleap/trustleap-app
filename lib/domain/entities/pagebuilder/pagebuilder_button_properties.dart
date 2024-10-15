// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:flutter/material.dart';

class PageBuilderButtonProperties extends Equatable
    implements PageBuilderProperties {
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? backgroundColor;
  final PageBuilderTextProperties? textProperties;

  const PageBuilderButtonProperties({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.backgroundColor,
    required this.textProperties,
  });

  PageBuilderButtonProperties copyWith({
    double? width,
    double? height,
    double? borderRadius,
    Color? backgroundColor,
    PageBuilderTextProperties? textProperties,
  }) {
    return PageBuilderButtonProperties(
      width: width ?? this.width,
      height: height ?? this.height,
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textProperties: textProperties ?? this.textProperties,
    );
  }

  @override
  List<Object?> get props =>
      [width, height, borderRadius, backgroundColor, textProperties];
}
