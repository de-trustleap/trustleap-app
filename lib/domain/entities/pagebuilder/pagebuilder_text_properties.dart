// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';

class PageBuilderTextProperties extends Equatable
    implements PageBuilderProperties {
  final String? text;
  final double? fontSize;
  final Color? color;
  final TextAlign? alignment;

  const PageBuilderTextProperties({
    required this.text,
    required this.fontSize,
    required this.color,
    required this.alignment
  });

  PageBuilderTextProperties copyWith({
    String? text,
    double? fontSize,
    Color? color,
    TextAlign? alignment
  }) {
    return PageBuilderTextProperties(
      text: text ?? this.text,
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
      alignment: alignment ?? this.alignment
    );
  }

  @override
  List<Object?> get props => [text, fontSize, color, alignment];
}
