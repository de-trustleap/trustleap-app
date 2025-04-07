// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_background.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_image_properties_model.dart';
import 'package:flutter/material.dart';

class PagebuilderBackgroundModel extends Equatable {
  final String? backgroundColor;
  final Map<String, dynamic>? imageProperties;
  final String? overlayColor;

  const PagebuilderBackgroundModel(
      {required this.backgroundColor,
      required this.imageProperties,
      required this.overlayColor});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (backgroundColor != null) map['backgroundColor'] = backgroundColor;
    if (imageProperties != null) map['imageProperties'] = imageProperties;
    if (overlayColor != null) map['overlayColor'] = overlayColor;
    return map;
  }

  factory PagebuilderBackgroundModel.fromMap(Map<String, dynamic> map) {
    return PagebuilderBackgroundModel(
        backgroundColor: map['backgroundColor'] != null
            ? map['backgroundColor'] as String
            : null,
        imageProperties: map['imageProperties'] != null
            ? map['imageProperties'] as Map<String, dynamic>
            : null,
        overlayColor:
            map['overlayColor'] != null ? map['overlayColor'] as String : null);
  }

  PagebuilderBackgroundModel copyWith(
      {String? backgroundColor,
      Map<String, dynamic>? imageProperties,
      String? overlayColor}) {
    return PagebuilderBackgroundModel(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        imageProperties: imageProperties ?? this.imageProperties,
        overlayColor: overlayColor ?? this.overlayColor);
  }

  PagebuilderBackground toDomain() {
    return PagebuilderBackground(
        backgroundColor: backgroundColor != null
            ? Color(ColorUtility.getHexIntFromString(backgroundColor!))
            : null,
        imageProperties: imageProperties != null
            ? PageBuilderImagePropertiesModel.fromMap(imageProperties!)
                .toDomain()
            : null,
        overlayColor: overlayColor != null
            ? Color(ColorUtility.getHexIntFromString(overlayColor!))
            : null);
  }

  factory PagebuilderBackgroundModel.fromDomain(
      PagebuilderBackground properties) {
    return PagebuilderBackgroundModel(
        backgroundColor: properties.backgroundColor?.toARGB32() != null
            ? properties.backgroundColor!.toARGB32().toRadixString(16)
            : null,
        imageProperties: properties.imageProperties != null
            ? PageBuilderImagePropertiesModel.fromDomain(
                    properties.imageProperties!)
                .toMap()
            : null,
        overlayColor: properties.overlayColor?.toARGB32() != null
            ? properties.overlayColor!.toARGB32().toRadixString(16)
            : null);
  }

  @override
  List<Object?> get props => [backgroundColor, imageProperties, overlayColor];
}
