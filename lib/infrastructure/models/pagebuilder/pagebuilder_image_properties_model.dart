// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/infrastructure/models/model_helper/boxfit_mapper.dart';
import 'package:flutter/material.dart';

class PageBuilderImagePropertiesModel extends Equatable
    implements PageBuilderProperties {
  final String? url;
  final double? borderRadius;
  final double? width;
  final double? height;
  final String? contentMode;
  final String? overlayColor;
  final bool? showPromoterImage;
  final String? newImageBase64;

  const PageBuilderImagePropertiesModel(
      {required this.url,
      required this.borderRadius,
      required this.width,
      required this.height,
      required this.contentMode,
      required this.overlayColor,
      required this.showPromoterImage,
      required this.newImageBase64});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (url != null) map['url'] = url;
    if (borderRadius != null) map['borderRadius'] = borderRadius;
    if (width != null) map['width'] = width;
    if (height != null) map['height'] = height;
    if (contentMode != null) map['contentMode'] = contentMode;
    if (overlayColor != null) map['overlayColor'] = overlayColor;
    if (showPromoterImage != null) map['showPromoterImage'] = showPromoterImage;
    if (newImageBase64 != null) map['newImageBase64'] = newImageBase64;
    return map;
  }

  factory PageBuilderImagePropertiesModel.fromMap(Map<String, dynamic> map) {
    return PageBuilderImagePropertiesModel(
        url: map['url'] != null ? map['url'] as String : null,
        borderRadius:
            map['borderRadius'] != null ? map['borderRadius'] as double : null,
        width: map['width'] != null ? map['width'] as double : null,
        height: map['height'] != null ? map['height'] as double : null,
        contentMode:
            map['contentMode'] != null ? map['contentMode'] as String : null,
        overlayColor:
            map['overlayColor'] != null ? map['overlayColor'] as String : null,
        showPromoterImage: map['showPromoterImage'] != null
            ? map['showPromoterImage'] as bool
            : null,
        newImageBase64: map['newImageBase64'] != null
            ? map['newImageBase64'] as String
            : null);
  }

  PageBuilderImagePropertiesModel copyWith(
      {String? url,
      double? borderRadius,
      double? width,
      double? height,
      String? contentMode,
      String? overlayColor,
      bool? showPromoterImage,
      String? newImageBase64}) {
    return PageBuilderImagePropertiesModel(
        url: url ?? this.url,
        borderRadius: borderRadius ?? this.borderRadius,
        width: width ?? this.width,
        height: height ?? this.height,
        contentMode: contentMode ?? this.contentMode,
        overlayColor: overlayColor ?? this.overlayColor,
        showPromoterImage: showPromoterImage ?? this.showPromoterImage,
        newImageBase64: newImageBase64 ?? this.newImageBase64);
  }

  PageBuilderImageProperties toDomain() {
    return PageBuilderImageProperties(
        url: url,
        borderRadius: borderRadius,
        width: width,
        height: height,
        contentMode: BoxFitMapper.getBoxFitFromString(contentMode),
        overlayColor: overlayColor != null
            ? Color(ColorUtility.getHexIntFromString(overlayColor!))
            : null,
        showPromoterImage: showPromoterImage);
  }

  factory PageBuilderImagePropertiesModel.fromDomain(
      PageBuilderImageProperties properties) {
    return PageBuilderImagePropertiesModel(
        url: properties.url,
        borderRadius: properties.borderRadius,
        width: properties.width,
        height: properties.height,
        contentMode: BoxFitMapper.getStringFromBoxFit(properties.contentMode),
        overlayColor: properties.overlayColor != null
            ? ColorUtility.colorToHex(properties.overlayColor!)
            : null,
        showPromoterImage: properties.showPromoterImage,
        newImageBase64: properties.localImage != null
            ? base64Encode(properties.localImage!)
            : null);
  }

  @override
  List<Object?> get props => [
        url,
        borderRadius,
        width,
        height,
        contentMode,
        overlayColor,
        showPromoterImage,
        newImageBase64
      ];
}
