// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';

class PagebuilderBackground extends Equatable {
  final Color? backgroundColor;
  final PageBuilderImageProperties? imageProperties;

  const PagebuilderBackground({
    required this.backgroundColor,
    required this.imageProperties,
  });

  PagebuilderBackground copyWith({
    Color? backgroundColor,
    PageBuilderImageProperties? imageProperties,
  }) {
    return PagebuilderBackground(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      imageProperties: imageProperties ?? this.imageProperties,
    );
  }

  @override
  List<Object?> get props => [backgroundColor, imageProperties];
}
