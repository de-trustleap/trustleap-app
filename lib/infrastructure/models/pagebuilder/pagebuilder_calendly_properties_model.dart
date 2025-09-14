import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_calendly_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/infrastructure/models/model_helper/shadow_mapper.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_shadow_model.dart';
import 'package:flutter/material.dart';

class PagebuilderCalendlyPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final double? width;
  final double? height;
  final double? borderRadius;
  final String? calendlyEventURL;
  final String? eventTypeName;
  final String? textColor;
  final String? backgroundColor;
  final String? primaryColor;
  final bool? hideEventTypeDetails;
  final Map<String, dynamic>? shadow;

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
      required this.shadow});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (width != null) map['width'] = width;
    if (height != null) map['height'] = height;
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
    return map;
  }

  factory PagebuilderCalendlyPropertiesModel.fromMap(Map<String, dynamic> map) {
    return PagebuilderCalendlyPropertiesModel(
        width: map['width'] != null ? map['width'] as double : null,
        height: map['height'] != null ? map['height'] as double : null,
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
            : null);
  }

  PagebuilderCalendlyPropertiesModel copyWith(
      {double? width,
      double? height,
      double? borderRadius,
      String? calendlyEventURL,
      String? eventTypeName,
      String? textColor,
      String? backgroundColor,
      String? primaryColor,
      bool? hideEventTypeDetails,
      Map<String, dynamic>? shadow}) {
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
        shadow: shadow ?? this.shadow);
  }

  PagebuilderCalendlyProperties toDomain() {
    return PagebuilderCalendlyProperties(
        width: width,
        height: height,
        borderRadius: borderRadius,
        calendlyEventURL: calendlyEventURL,
        eventTypeName: eventTypeName,
        textColor: textColor != null
            ? Color(ColorUtility.getHexIntFromString(textColor!))
            : null,
        backgroundColor: backgroundColor != null
            ? Color(ColorUtility.getHexIntFromString(backgroundColor!))
            : null,
        primaryColor: primaryColor != null
            ? Color(ColorUtility.getHexIntFromString(primaryColor!))
            : null,
        hideEventTypeDetails: hideEventTypeDetails,
        shadow: shadow != null
            ? PageBuilderShadowModel.fromMap(shadow!).toDomain()
            : null);
  }

  factory PagebuilderCalendlyPropertiesModel.fromDomain(
      PagebuilderCalendlyProperties properties) {
    return PagebuilderCalendlyPropertiesModel(
        width: properties.width,
        height: properties.height,
        borderRadius: properties.borderRadius,
        calendlyEventURL: properties.calendlyEventURL,
        eventTypeName: properties.eventTypeName,
        textColor: properties.textColor != null
            ? ColorUtility.colorToHex(properties.textColor!)
            : null,
        backgroundColor: properties.backgroundColor != null
            ? ColorUtility.colorToHex(properties.backgroundColor!)
            : null,
        primaryColor: properties.primaryColor != null
            ? ColorUtility.colorToHex(properties.primaryColor!)
            : null,
        hideEventTypeDetails: properties.hideEventTypeDetails,
        shadow: ShadowMapper.getMapFromShadow(properties.shadow));
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
        shadow
      ];
}
