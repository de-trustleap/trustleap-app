import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_shadow.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:flutter/material.dart';

class PagebuilderCalendlyProperties extends Equatable
    implements PageBuilderProperties {
  final double? width;
  final double? height;
  final double? borderRadius;
  final String? calendlyEventURL;
  final String? eventTypeName;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? primaryColor;
  final bool? hideEventTypeDetails;
  final PageBuilderShadow? shadow;
  final bool? useIntrinsicHeight;

  const PagebuilderCalendlyProperties(
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

  PagebuilderCalendlyProperties copyWith(
      {double? width,
      double? height,
      double? borderRadius,
      String? calendlyEventURL,
      String? eventTypeName,
      Color? textColor,
      Color? backgroundColor,
      Color? primaryColor,
      bool? hideEventTypeDetails,
      PageBuilderShadow? shadow,
      bool? useIntrinsicHeight}) {
    return PagebuilderCalendlyProperties(
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
