// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/infrastructure/models/model_helper/boxfit_mapper.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_border_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_paint_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_responsive_or_constant_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_shadow_model.dart';
import 'package:flutter/material.dart';

class PageBuilderImagePropertiesModel extends Equatable
    implements PageBuilderProperties {
  final String? url;
  final Map<String, dynamic>? border;
  final PagebuilderResponsiveOrConstantModel<double>? width;
  final PagebuilderResponsiveOrConstantModel<double>? height;
  final PagebuilderResponsiveOrConstantModel<String>? contentMode;
  final Map<String, dynamic>? overlayPaint;
  final Map<String, dynamic>? shadow;
  final bool? showPromoterImage;
  final String? newImageBase64;

  const PageBuilderImagePropertiesModel(
      {required this.url,
      required this.border,
      required this.width,
      required this.height,
      required this.contentMode,
      required this.overlayPaint,
      required this.shadow,
      required this.showPromoterImage,
      required this.newImageBase64});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (url != null) map['url'] = url;
    if (border != null) map['border'] = border;
    if (width != null) map['width'] = width!.toMapValue();
    if (height != null) map['height'] = height!.toMapValue();
    if (contentMode != null) map['contentMode'] = contentMode!.toMapValue();
    if (overlayPaint != null) map['overlayPaint'] = overlayPaint;
    if (shadow != null) map['shadow'] = shadow;
    if (showPromoterImage != null) map['showPromoterImage'] = showPromoterImage;
    if (newImageBase64 != null) map['newImageBase64'] = newImageBase64;
    return map;
  }

  factory PageBuilderImagePropertiesModel.fromMap(Map<String, dynamic> map) {
    return PageBuilderImagePropertiesModel(
        url: map['url'] != null ? map['url'] as String : null,
        border: map['border'] != null
            ? map['border'] as Map<String, dynamic>
            : null,
        width: PagebuilderResponsiveOrConstantModel.fromMapValue(
          map['width'],
          (v) => v as double,
        ),
        height: PagebuilderResponsiveOrConstantModel.fromMapValue(
          map['height'],
          (v) => v as double,
        ),
        contentMode: PagebuilderResponsiveOrConstantModel.fromMapValue(
          map['contentMode'],
          (v) => v as String,
        ),
        overlayPaint: map['overlayPaint'] != null
            ? map['overlayPaint'] as Map<String, dynamic>
            : null,
        shadow: map['shadow'] != null
            ? map['shadow'] as Map<String, dynamic>
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
      Map<String, dynamic>? border,
      PagebuilderResponsiveOrConstantModel<double>? width,
      PagebuilderResponsiveOrConstantModel<double>? height,
      PagebuilderResponsiveOrConstantModel<String>? contentMode,
      Map<String, dynamic>? overlayPaint,
      Map<String, dynamic>? shadow,
      bool? showPromoterImage,
      String? newImageBase64}) {
    return PageBuilderImagePropertiesModel(
        url: url ?? this.url,
        border: border ?? this.border,
        width: width ?? this.width,
        height: height ?? this.height,
        contentMode: contentMode ?? this.contentMode,
        overlayPaint: overlayPaint ?? this.overlayPaint,
        shadow: shadow ?? this.shadow,
        showPromoterImage: showPromoterImage ?? this.showPromoterImage,
        newImageBase64: newImageBase64 ?? this.newImageBase64);
  }

  PageBuilderImageProperties toDomain(PageBuilderGlobalStyles? globalStyles) {
    return PageBuilderImageProperties(
        url: url,
        border: border != null
            ? PagebuilderBorderModel.fromMap(border!).toDomain(globalStyles)
            : null,
        width: width?.toDomain(),
        height: height?.toDomain(),
        contentMode: _contentModeToDomain(contentMode),
        overlayPaint: overlayPaint != null
            ? PagebuilderPaintModel.fromMap(overlayPaint!).toDomain(globalStyles)
            : null,
        shadow: shadow != null
            ? PageBuilderShadowModel.fromMap(shadow!).toDomain()
            : null,
        showPromoterImage: showPromoterImage);
  }

  PagebuilderResponsiveOrConstant<BoxFit>? _contentModeToDomain(
      PagebuilderResponsiveOrConstantModel<String>? contentModeModel) {
    if (contentModeModel == null) return null;

    if (contentModeModel.constantValue != null) {
      final boxFit =
          BoxFitMapper.getBoxFitFromString(contentModeModel.constantValue);
      return boxFit != null
          ? PagebuilderResponsiveOrConstant.constant(boxFit)
          : null;
    }

    if (contentModeModel.responsiveValue != null) {
      final Map<String, BoxFit> mappedValues = {};

      if (contentModeModel.responsiveValue!["mobile"] != null) {
        final value = BoxFitMapper.getBoxFitFromString(
            contentModeModel.responsiveValue!["mobile"]);
        if (value != null) mappedValues["mobile"] = value;
      }

      if (contentModeModel.responsiveValue!["tablet"] != null) {
        final value = BoxFitMapper.getBoxFitFromString(
            contentModeModel.responsiveValue!["tablet"]);
        if (value != null) mappedValues["tablet"] = value;
      }

      if (contentModeModel.responsiveValue!["desktop"] != null) {
        final value = BoxFitMapper.getBoxFitFromString(
            contentModeModel.responsiveValue!["desktop"]);
        if (value != null) mappedValues["desktop"] = value;
      }

      return mappedValues.isNotEmpty
          ? PagebuilderResponsiveOrConstant.responsive(mappedValues)
          : null;
    }

    return null;
  }

  factory PageBuilderImagePropertiesModel.fromDomain(
      PageBuilderImageProperties properties) {
    return PageBuilderImagePropertiesModel(
        url: properties.url,
        border: properties.border != null
            ? PagebuilderBorderModel.fromDomain(properties.border!).toMap()
            : null,
        width: PagebuilderResponsiveOrConstantModel.fromDomain(properties.width),
        height:
            PagebuilderResponsiveOrConstantModel.fromDomain(properties.height),
        contentMode: _contentModeFromDomain(properties.contentMode),
        overlayPaint: properties.overlayPaint != null
            ? PagebuilderPaintModel.fromDomain(properties.overlayPaint!).toMap()
            : null,
        shadow: properties.shadow != null
            ? PageBuilderShadowModel.fromDomain(properties.shadow!).toMap()
            : null,
        showPromoterImage: properties.showPromoterImage,
        newImageBase64: properties.localImage != null
            ? base64Encode(properties.localImage!)
            : null);
  }

  static PagebuilderResponsiveOrConstantModel<String>? _contentModeFromDomain(
      PagebuilderResponsiveOrConstant<BoxFit>? contentMode) {
    if (contentMode == null) return null;

    if (contentMode.constantValue != null) {
      final stringValue =
          BoxFitMapper.getStringFromBoxFit(contentMode.constantValue);
      return stringValue != null
          ? PagebuilderResponsiveOrConstantModel.constant(stringValue)
          : null;
    }

    if (contentMode.responsiveValue != null) {
      final Map<String, String> mappedValues = {};

      if (contentMode.responsiveValue!["mobile"] != null) {
        final value = BoxFitMapper.getStringFromBoxFit(
            contentMode.responsiveValue!["mobile"]);
        if (value != null) mappedValues["mobile"] = value;
      }

      if (contentMode.responsiveValue!["tablet"] != null) {
        final value = BoxFitMapper.getStringFromBoxFit(
            contentMode.responsiveValue!["tablet"]);
        if (value != null) mappedValues["tablet"] = value;
      }

      if (contentMode.responsiveValue!["desktop"] != null) {
        final value = BoxFitMapper.getStringFromBoxFit(
            contentMode.responsiveValue!["desktop"]);
        if (value != null) mappedValues["desktop"] = value;
      }

      return mappedValues.isNotEmpty
          ? PagebuilderResponsiveOrConstantModel.responsive(mappedValues)
          : null;
    }

    return null;
  }

  @override
  List<Object?> get props => [
        url,
        border,
        width,
        height,
        contentMode,
        overlayPaint,
        shadow,
        showPromoterImage,
        newImageBase64
      ];
}
