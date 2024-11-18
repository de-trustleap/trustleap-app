// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_shadow.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:flutter/material.dart';

class PageBuilderTextProperties extends Equatable
    implements PageBuilderProperties {
  final String? text;
  final double? fontSize;
  final String? fontFamily;
  final double? lineHeight;
  final double? letterSpacing;
  final Color? color;
  final TextAlign? alignment;
  final PageBuilderShadow? textShadow;
  final bool? isBold;
  final bool? isItalic;

  const PageBuilderTextProperties(
      {required this.text,
      required this.fontSize,
      required this.fontFamily,
      required this.lineHeight,
      required this.letterSpacing,
      required this.color,
      required this.alignment,
      required this.textShadow,
      required this.isBold,
      required this.isItalic});

  PageBuilderTextProperties copyWith(
      {String? text,
      double? fontSize,
      String? fontFamily,
      double? lineHeight,
      double? letterSpacing,
      Color? color,
      TextAlign? alignment,
      PageBuilderShadow? textShadow,
      bool? isBold,
      bool? isItalic}) {
    return PageBuilderTextProperties(
        text: text ?? this.text,
        fontSize: fontSize ?? this.fontSize,
        fontFamily: fontFamily ?? this.fontFamily,
        lineHeight: lineHeight ?? this.lineHeight,
        letterSpacing: letterSpacing ?? this.letterSpacing,
        color: color ?? this.color,
        alignment: alignment ?? this.alignment,
        textShadow: textShadow ?? this.textShadow,
        isBold: isBold ?? this.isBold,
        isItalic: isItalic ?? this.isItalic);
  }

  @override
  List<Object?> get props => [
        text,
        fontSize,
        fontFamily,
        lineHeight,
        letterSpacing,
        color,
        alignment,
        textShadow,
        isBold,
        isItalic
      ];
}
