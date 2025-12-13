import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_shadow.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:flutter/material.dart';

class PagebuilderCalendlyProperties extends Equatable
    implements PageBuilderProperties {
  final PagebuilderResponsiveOrConstant<double>? width;
  final PagebuilderResponsiveOrConstant<double>? height;
  final double? borderRadius;
  final String? calendlyEventURL;
  final String? eventTypeName;
  final Color? textColor;
  final String? textColorToken;
  final Color? backgroundColor;
  final String? backgroundColorToken;
  final Color? primaryColor;
  final String? primaryColorToken;
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
      this.textColorToken,
      required this.backgroundColor,
      this.backgroundColorToken,
      required this.primaryColor,
      this.primaryColorToken,
      required this.hideEventTypeDetails,
      required this.shadow,
      required this.useIntrinsicHeight});

  PagebuilderCalendlyProperties copyWith(
      {PagebuilderResponsiveOrConstant<double>? width,
      PagebuilderResponsiveOrConstant<double>? height,
      double? borderRadius,
      String? calendlyEventURL,
      String? eventTypeName,
      Color? textColor,
      String? textColorToken,
      Color? backgroundColor,
      String? backgroundColorToken,
      Color? primaryColor,
      String? primaryColorToken,
      bool? hideEventTypeDetails,
      PageBuilderShadow? shadow,
      bool? useIntrinsicHeight,
      bool setTextColorTokenNull = false,
      bool setBackgroundColorTokenNull = false,
      bool setPrimaryColorTokenNull = false}) {
    return PagebuilderCalendlyProperties(
        width: width ?? this.width,
        height: height ?? this.height,
        borderRadius: borderRadius ?? this.borderRadius,
        calendlyEventURL: calendlyEventURL ?? this.calendlyEventURL,
        eventTypeName: eventTypeName ?? this.eventTypeName,
        textColor: textColor ?? this.textColor,
        textColorToken: setTextColorTokenNull ? null : (textColorToken ?? this.textColorToken),
        backgroundColor: backgroundColor ?? this.backgroundColor,
        backgroundColorToken: setBackgroundColorTokenNull ? null : (backgroundColorToken ?? this.backgroundColorToken),
        primaryColor: primaryColor ?? this.primaryColor,
        primaryColorToken: setPrimaryColorTokenNull ? null : (primaryColorToken ?? this.primaryColorToken),
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
        textColorToken,
        backgroundColor,
        backgroundColorToken,
        primaryColor,
        primaryColorToken,
        hideEventTypeDetails,
        shadow,
        useIntrinsicHeight
      ];
}
