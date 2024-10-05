// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:flutter/material.dart';

class PageBuilderTextProperties extends Equatable
    implements PageBuilderProperties {
  final String? text;
  final double? fontSize;
  final String? fontFamily;
  final Color? color;
  final TextAlign? alignment;

  const PageBuilderTextProperties(
      {required this.text,
      required this.fontSize,
      required this.fontFamily,
      required this.color,
      required this.alignment});

  PageBuilderTextProperties copyWith(
      {String? text,
      double? fontSize,
      String? fontFamily,
      Color? color,
      TextAlign? alignment}) {
    return PageBuilderTextProperties(
        text: text ?? this.text,
        fontSize: fontSize ?? this.fontSize,
        fontFamily: fontFamily ?? this.fontFamily,
        color: color ?? this.color,
        alignment: alignment ?? this.alignment);
  }

  @override
  List<Object?> get props => [text, fontSize, fontFamily, color, alignment];
}

//TODO: Font Family im Backend, line height front und backend, style front und backend.