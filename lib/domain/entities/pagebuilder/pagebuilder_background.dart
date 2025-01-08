// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:flutter/material.dart';

class PagebuilderBackground extends Equatable {
  final Color? backgroundColor;
  final PageBuilderImageProperties? imageProperties;
  final Color? overlayColor;

  const PagebuilderBackground(
      {required this.backgroundColor,
      required this.imageProperties,
      required this.overlayColor});

  PagebuilderBackground copyWith(
      {Color? backgroundColor,
      PageBuilderImageProperties? imageProperties,
      Color? overlayColor,
      bool setImagePropertiesNull = false}) {
    return PagebuilderBackground(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        imageProperties: setImagePropertiesNull
            ? null
            : (imageProperties ?? this.imageProperties),
        overlayColor: overlayColor ?? this.overlayColor);
  }

  @override
  List<Object?> get props => [backgroundColor, imageProperties, overlayColor];
}
