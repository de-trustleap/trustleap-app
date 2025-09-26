// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/infrastructure/models/model_helper/boxfit_mapper.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_paint_model.dart';

class PageBuilderImagePropertiesModel extends Equatable
    implements PageBuilderProperties {
  final String? url;
  final double? borderRadius;
  final double? width;
  final double? height;
  final String? contentMode;
  final Map<String, dynamic>? overlayPaint;
  final bool? showPromoterImage;
  final String? newImageBase64;

  const PageBuilderImagePropertiesModel(
      {required this.url,
      required this.borderRadius,
      required this.width,
      required this.height,
      required this.contentMode,
      required this.overlayPaint,
      required this.showPromoterImage,
      required this.newImageBase64});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (url != null) map['url'] = url;
    if (borderRadius != null) map['borderRadius'] = borderRadius;
    if (width != null) map['width'] = width;
    if (height != null) map['height'] = height;
    if (contentMode != null) map['contentMode'] = contentMode;
    if (overlayPaint != null) map['overlayPaint'] = overlayPaint;
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
        overlayPaint: map['overlayPaint'] != null
            ? map['overlayPaint'] as Map<String, dynamic>
            : null,
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
      Map<String, dynamic>? overlayPaint,
      bool? showPromoterImage,
      String? newImageBase64}) {
    return PageBuilderImagePropertiesModel(
        url: url ?? this.url,
        borderRadius: borderRadius ?? this.borderRadius,
        width: width ?? this.width,
        height: height ?? this.height,
        contentMode: contentMode ?? this.contentMode,
        overlayPaint: overlayPaint ?? this.overlayPaint,
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
        overlayPaint: overlayPaint != null
            ? PagebuilderPaintModel.fromMap(overlayPaint!).toDomain()
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
        overlayPaint: properties.overlayPaint != null
            ? PagebuilderPaintModel.fromDomain(properties.overlayPaint!).toMap()
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
        overlayPaint,
        showPromoterImage,
        newImageBase64
      ];
}
