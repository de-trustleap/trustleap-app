// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';

class PageBuilderImagePropertiesModel extends Equatable
    implements PageBuilderProperties {
  final String? url;
  final double? borderRadius;
  final double? width;
  final double? height;
  final String? newImageBase64;

  const PageBuilderImagePropertiesModel(
      {required this.url,
      required this.borderRadius,
      required this.width,
      required this.height,
      required this.newImageBase64});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (url != null) map['url'] = url;
    if (borderRadius != null) map['borderRadius'] = borderRadius;
    if (width != null) map['width'] = width;
    if (height != null) map['height'] = height;
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
        newImageBase64: map['newImageBase64'] != null
            ? map['newImageBase64'] as String
            : null);
  }

  PageBuilderImagePropertiesModel copyWith(
      {String? url,
      double? borderRadius,
      double? width,
      double? height,
      String? newImageBase64}) {
    return PageBuilderImagePropertiesModel(
        url: url ?? this.url,
        borderRadius: borderRadius ?? this.borderRadius,
        width: width ?? this.width,
        height: height ?? this.height,
        newImageBase64: newImageBase64 ?? this.newImageBase64);
  }

  PageBuilderImageProperties toDomain() {
    return PageBuilderImageProperties(
        url: url, borderRadius: borderRadius, width: width, height: height);
  }

  factory PageBuilderImagePropertiesModel.fromDomain(
      PageBuilderImageProperties properties) {
    return PageBuilderImagePropertiesModel(
        url: properties.url,
        borderRadius: properties.borderRadius,
        width: properties.width,
        height: properties.height,
        newImageBase64: properties.localImage != null
            ? base64Encode(properties.localImage!)
            : null);
  }

  @override
  List<Object?> get props => [url, borderRadius, width, height, newImageBase64];
}
