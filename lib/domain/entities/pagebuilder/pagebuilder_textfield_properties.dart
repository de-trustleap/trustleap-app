// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:flutter/material.dart';

class PageBuilderTextFieldProperties extends Equatable
    implements PageBuilderProperties {
  final PagebuilderResponsiveOrConstant<double>? width;
  final int? minLines;
  final int? maxLines;
  final bool? isRequired;
  final Color? backgroundColor;
  final String? globalBackgroundColorToken;
  final Color? borderColor;
  final String? globalBorderColorToken;
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
    this.globalBackgroundColorToken,
    this.globalBorderColorToken,
  });

  PageBuilderTextFieldProperties copyWith(
      {PagebuilderResponsiveOrConstant<double>? width,
      int? minLines,
      int? maxLines,
      bool? isRequired,
      Color? backgroundColor,
      String? globalBackgroundColorToken,
      Color? borderColor,
      String? globalBorderColorToken,
      PageBuilderTextProperties? placeHolderTextProperties,
      PageBuilderTextProperties? textProperties,
      bool setBackgroundColorNull = false,
      bool setGlobalBackgroundColorTokenNull = false,
      bool setBorderColorNull = false,
      bool setGlobalBorderColorTokenNull = false}) {
    return PageBuilderTextFieldProperties(
      width: width ?? this.width,
      minLines: minLines ?? this.minLines,
      maxLines: maxLines ?? this.maxLines,
      isRequired: isRequired ?? this.isRequired,
      backgroundColor: setBackgroundColorNull ? null : (backgroundColor ?? this.backgroundColor),
      globalBackgroundColorToken: setGlobalBackgroundColorTokenNull ? null : (globalBackgroundColorToken ?? this.globalBackgroundColorToken),
      borderColor: setBorderColorNull ? null : (borderColor ?? this.borderColor),
      globalBorderColorToken: setGlobalBorderColorTokenNull ? null : (globalBorderColorToken ?? this.globalBorderColorToken),
      placeHolderTextProperties:
          placeHolderTextProperties ?? this.placeHolderTextProperties,
      textProperties: textProperties ?? this.textProperties,
    );
  }

  PageBuilderTextFieldProperties deepCopy() {
    return PageBuilderTextFieldProperties(
      width: width,
      minLines: minLines,
      maxLines: maxLines,
      isRequired: isRequired,
      backgroundColor:
          backgroundColor != null ? Color(backgroundColor!.toARGB32()) : null,
      globalBackgroundColorToken: globalBackgroundColorToken,
      borderColor: borderColor != null ? Color(borderColor!.toARGB32()) : null,
      globalBorderColorToken: globalBorderColorToken,
      placeHolderTextProperties: placeHolderTextProperties?.deepCopy(),
      textProperties: textProperties?.deepCopy(),
    );
  }

  @override
  List<Object?> get props => [
        width,
        minLines,
        maxLines,
        isRequired,
        backgroundColor,
        globalBackgroundColorToken,
        borderColor,
        globalBorderColorToken,
        placeHolderTextProperties,
        textProperties
      ];
}
