// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:flutter/material.dart';

class PageBuilderTextFieldProperties extends Equatable
    implements PageBuilderProperties {
  final double? width;
  final int? minLines;
  final int? maxLines;
  final bool? isRequired;
  final Color? backgroundColor;
  final Color? borderColor;
  final PageBuilderTextProperties? placeHolderTextProperties;
  final PageBuilderTextProperties? textProperties;

  const PageBuilderTextFieldProperties({
    required this.width,
    required this.minLines,
    required this.maxLines,
    required this.isRequired,
    required this.backgroundColor,
    required this.borderColor,
    required this.placeHolderTextProperties,
    required this.textProperties,
  });

  PageBuilderTextFieldProperties copyWith(
      {double? width,
      int? minLines,
      int? maxLines,
      bool? isRequired,
      Color? backgroundColor,
      Color? borderColor,
      PageBuilderTextProperties? placeHolderTextProperties,
      PageBuilderTextProperties? textProperties}) {
    return PageBuilderTextFieldProperties(
      width: width ?? this.width,
      minLines: minLines ?? this.minLines,
      maxLines: maxLines ?? this.maxLines,
      isRequired: isRequired ?? this.isRequired,
      borderColor: borderColor ?? this.borderColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      placeHolderTextProperties:
          placeHolderTextProperties ?? this.placeHolderTextProperties,
      textProperties: textProperties ?? this.textProperties,
    );
  }

  @override
  List<Object?> get props => [
        width,
        minLines,
        maxLines,
        isRequired,
        backgroundColor,
        borderColor,
        placeHolderTextProperties,
        textProperties
      ];
}
