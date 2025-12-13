import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_calendly_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/infrastructure/models/model_helper/shadow_mapper.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_responsive_or_constant_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_shadow_model.dart';
import 'package:flutter/material.dart';

class PagebuilderCalendlyPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final PagebuilderResponsiveOrConstantModel<double>? width;
  final PagebuilderResponsiveOrConstantModel<double>? height;
  final double? borderRadius;
  final String? calendlyEventURL;
  final String? eventTypeName;
  final String? textColor;
  final String? backgroundColor;
  final String? primaryColor;
  final bool? hideEventTypeDetails;
  final Map<String, dynamic>? shadow;
  final bool? useIntrinsicHeight;

  const PagebuilderCalendlyPropertiesModel(
      {required this.width,
      required this.height,
      required this.borderRadius,
      required this.calendlyEventURL,
      required this.eventTypeName,
      required this.textColor,
      required this.backgroundColor,
      required this.primaryColor,
      required this.hideEventTypeDetails,
      required this.shadow,
      required this.useIntrinsicHeight});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (width != null) map['width'] = width!.toMapValue();
    if (height != null) map['height'] = height!.toMapValue();
    if (borderRadius != null) map['borderRadius'] = borderRadius;
    if (calendlyEventURL != null) map['calendlyEventURL'] = calendlyEventURL;
    if (eventTypeName != null) map['eventTypeName'] = eventTypeName;
    if (textColor != null) map['textColor'] = textColor;
    if (backgroundColor != null) map['backgroundColor'] = backgroundColor;
    if (primaryColor != null) map['primaryColor'] = primaryColor;
    if (hideEventTypeDetails != null) {
      map['hideEventTypeDetails'] = hideEventTypeDetails;
    }
    if (shadow != null) map['shadow'] = shadow;
    if (useIntrinsicHeight != null) {
      map['useIntrinsicHeight'] = useIntrinsicHeight;
    }
    return map;
  }

  factory PagebuilderCalendlyPropertiesModel.fromMap(Map<String, dynamic> map) {
    return PagebuilderCalendlyPropertiesModel(
        width: PagebuilderResponsiveOrConstantModel.fromMapValue(
            map['width'], (v) => v as double),
        height: PagebuilderResponsiveOrConstantModel.fromMapValue(
            map['height'], (v) => v as double),
        borderRadius:
            map['borderRadius'] != null ? map['borderRadius'] as double : null,
        calendlyEventURL: map['calendlyEventURL'] != null
            ? map['calendlyEventURL'] as String
            : null,
        eventTypeName: map['eventTypeName'] != null
            ? map['eventTypeName'] as String
            : null,
        textColor: map['textColor'] != null ? map['textColor'] as String : null,
        backgroundColor: map['backgroundColor'] != null
            ? map['backgroundColor'] as String
            : null,
        primaryColor:
            map['primaryColor'] != null ? map['primaryColor'] as String : null,
        hideEventTypeDetails: map['hideEventTypeDetails'] != null
            ? map['hideEventTypeDetails'] as bool
            : null,
        shadow: map['shadow'] != null
            ? map['shadow'] as Map<String, dynamic>
            : null,
        useIntrinsicHeight: map['useIntrinsicHeight'] != null
            ? map['useIntrinsicHeight'] as bool
            : null);
  }

  PagebuilderCalendlyPropertiesModel copyWith(
      {PagebuilderResponsiveOrConstantModel<double>? width,
      PagebuilderResponsiveOrConstantModel<double>? height,
      double? borderRadius,
      String? calendlyEventURL,
      String? eventTypeName,
      String? textColor,
      String? backgroundColor,
      String? primaryColor,
      bool? hideEventTypeDetails,
      Map<String, dynamic>? shadow,
      bool? useIntrinsicHeight}) {
    return PagebuilderCalendlyPropertiesModel(
        width: width ?? this.width,
        height: height ?? this.height,
        borderRadius: borderRadius ?? this.borderRadius,
        calendlyEventURL: calendlyEventURL ?? this.calendlyEventURL,
        eventTypeName: eventTypeName ?? this.eventTypeName,
        textColor: textColor ?? this.textColor,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        primaryColor: primaryColor ?? this.primaryColor,
        hideEventTypeDetails: hideEventTypeDetails ?? this.hideEventTypeDetails,
        shadow: shadow ?? this.shadow,
        useIntrinsicHeight: useIntrinsicHeight ?? this.useIntrinsicHeight);
  }

  PagebuilderCalendlyProperties toDomain(
      PageBuilderGlobalStyles? globalStyles) {
    Color? resolvedTextColor;
    String? textColorToken;
    Color? resolvedBackgroundColor;
    String? backgroundColorToken;
    Color? resolvedPrimaryColor;
    String? primaryColorToken;

    if (textColor != null) {
      if (textColor!.startsWith('@')) {
        textColorToken = textColor;
        final tokenColor = globalStyles?.resolveColorReference(textColor!);
        resolvedTextColor = tokenColor ?? Colors.transparent;
      } else {
        resolvedTextColor = Color(ColorUtility.getHexIntFromString(textColor!));
        textColorToken = null;
      }
    }

    if (backgroundColor != null) {
      if (backgroundColor!.startsWith('@')) {
        backgroundColorToken = backgroundColor;
        final tokenColor =
            globalStyles?.resolveColorReference(backgroundColor!);
        resolvedBackgroundColor = tokenColor ?? Colors.transparent;
      } else {
        resolvedBackgroundColor =
            Color(ColorUtility.getHexIntFromString(backgroundColor!));
        backgroundColorToken = null;
      }
    }

    if (primaryColor != null) {
      if (primaryColor!.startsWith('@')) {
        primaryColorToken = primaryColor;
        final tokenColor = globalStyles?.resolveColorReference(primaryColor!);
        resolvedPrimaryColor = tokenColor ?? Colors.transparent;
      } else {
        resolvedPrimaryColor =
            Color(ColorUtility.getHexIntFromString(primaryColor!));
        primaryColorToken = null;
      }
    }

    return PagebuilderCalendlyProperties(
        width: width?.toDomain(),
        height: height?.toDomain(),
        borderRadius: borderRadius,
        calendlyEventURL: calendlyEventURL,
        eventTypeName: eventTypeName,
        textColor: resolvedTextColor,
        textColorToken: textColorToken,
        backgroundColor: resolvedBackgroundColor,
        backgroundColorToken: backgroundColorToken,
        primaryColor: resolvedPrimaryColor,
        primaryColorToken: primaryColorToken,
        hideEventTypeDetails: hideEventTypeDetails,
        shadow: shadow != null
            ? PageBuilderShadowModel.fromMap(shadow!).toDomain(globalStyles)
            : null,
        useIntrinsicHeight: useIntrinsicHeight);
  }

  factory PagebuilderCalendlyPropertiesModel.fromDomain(
      PagebuilderCalendlyProperties properties) {
    return PagebuilderCalendlyPropertiesModel(
        width:
            PagebuilderResponsiveOrConstantModel.fromDomain(properties.width),
        height:
            PagebuilderResponsiveOrConstantModel.fromDomain(properties.height),
        borderRadius: properties.borderRadius,
        calendlyEventURL: properties.calendlyEventURL,
        eventTypeName: properties.eventTypeName,
        textColor: properties.textColorToken ??
            (properties.textColor != null
                ? ColorUtility.colorToHex(properties.textColor!)
                : null),
        backgroundColor: properties.backgroundColorToken ??
            (properties.backgroundColor != null
                ? ColorUtility.colorToHex(properties.backgroundColor!)
                : null),
        primaryColor: properties.primaryColorToken ??
            (properties.primaryColor != null
                ? ColorUtility.colorToHex(properties.primaryColor!)
                : null),
        hideEventTypeDetails: properties.hideEventTypeDetails,
        shadow: ShadowMapper.getMapFromShadow(properties.shadow),
        useIntrinsicHeight: properties.useIntrinsicHeight);
  }

  @override
  List<Object?> get props => [
        width,
        height,
        borderRadius,
        calendlyEventURL,
        eventTypeName,
        textColor,
        backgroundColor,
        primaryColor,
        hideEventTypeDetails,
        shadow,
        useIntrinsicHeight
      ];
}
