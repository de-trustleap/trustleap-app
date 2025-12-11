// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_shadow.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:flutter/material.dart';

class PageBuilderTextProperties extends Equatable
    implements PageBuilderProperties {
  final String? text;
  final PagebuilderResponsiveOrConstant<double>? fontSize;
  final String? fontFamily;
  final PagebuilderResponsiveOrConstant<double>? lineHeight;
  final PagebuilderResponsiveOrConstant<double>? letterSpacing;
  final Color? color;
  final String? globalColorToken;
  final PagebuilderResponsiveOrConstant<TextAlign>? alignment;
  final PageBuilderShadow? textShadow;

  const PageBuilderTextProperties({
    required this.text,
    required this.fontSize,
    required this.fontFamily,
    required this.lineHeight,
    required this.letterSpacing,
    required this.color,
    this.globalColorToken,
    required this.alignment,
    required this.textShadow,
  });

  PageBuilderTextProperties copyWith({
    String? text,
    PagebuilderResponsiveOrConstant<double>? fontSize,
    String? fontFamily,
    PagebuilderResponsiveOrConstant<double>? lineHeight,
    PagebuilderResponsiveOrConstant<double>? letterSpacing,
    Color? color,
    String? globalColorToken,
    PagebuilderResponsiveOrConstant<TextAlign>? alignment,
    PageBuilderShadow? textShadow,
  }) {
    return PageBuilderTextProperties(
      text: text ?? this.text,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      lineHeight: lineHeight ?? this.lineHeight,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      color: color ?? this.color,
      globalColorToken: globalColorToken ?? this.globalColorToken,
      alignment: alignment ?? this.alignment,
      textShadow: textShadow ?? this.textShadow,
    );
  }

  PageBuilderTextProperties deepCopy() {
    return PageBuilderTextProperties(
      text: text,
      fontSize: fontSize,
      fontFamily: fontFamily,
      lineHeight: lineHeight,
      letterSpacing: letterSpacing,
      color: color != null ? Color(color!.toARGB32()) : null,
      globalColorToken: globalColorToken,
      alignment: alignment,
      textShadow: textShadow?.deepCopy(),
    );
  }

  @override
  List<Object?> get props => [
        text,
        fontSize,
        fontFamily,
        lineHeight,
        letterSpacing,
        color,
        globalColorToken,
        alignment,
        textShadow,
      ];
}
