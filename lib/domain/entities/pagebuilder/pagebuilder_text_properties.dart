// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:flutter/material.dart';

class PageBuilderTextProperties extends Equatable
    implements PageBuilderProperties {
  final String? text;
  final double? fontSize;
  final String? fontFamily;
  final double? lineHeight;
  final Color? color;
  final TextAlign? alignment;
  final bool? isBold;
  final bool? isItalic;

  const PageBuilderTextProperties(
      {required this.text,
      required this.fontSize,
      required this.fontFamily,
      required this.lineHeight,
      required this.color,
      required this.alignment,
      required this.isBold,
      required this.isItalic});

  PageBuilderTextProperties copyWith(
      {String? text,
      double? fontSize,
      String? fontFamily,
      double? lineHeight,
      Color? color,
      TextAlign? alignment,
      bool? isBold,
      bool? isItalic}) {
    return PageBuilderTextProperties(
        text: text ?? this.text,
        fontSize: fontSize ?? this.fontSize,
        fontFamily: fontFamily ?? this.fontFamily,
        lineHeight: lineHeight ?? this.lineHeight,
        color: color ?? this.color,
        alignment: alignment ?? this.alignment,
        isBold: isBold ?? this.isBold,
        isItalic: isItalic ?? this.isItalic);
  }

  @override
  List<Object?> get props => [
        text,
        fontSize,
        fontFamily,
        lineHeight,
        color,
        alignment,
        isBold,
        isItalic
      ];
}
