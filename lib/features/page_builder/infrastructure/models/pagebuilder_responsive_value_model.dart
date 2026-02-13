// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/responsive/pagebuilder_responsive_value.dart';
import 'package:flutter/material.dart';

class PagebuilderResponsiveValueModel<T> extends Equatable {
  final T? mobile;
  final T? tablet;
  final T? desktop;

  const PagebuilderResponsiveValueModel({
    this.mobile,
    this.tablet,
    this.desktop,
  });

  Map<String, dynamic>? toMap(dynamic Function(T) converter) {
    if (mobile == null && tablet == null && desktop == null) {
      return null;
    }

    Map<String, dynamic> map = {};
    if (mobile != null) map["mobile"] = converter(mobile as T);
    if (tablet != null) map["tablet"] = converter(tablet as T);
    if (desktop != null) map["desktop"] = converter(desktop as T);
    return map;
  }

  factory PagebuilderResponsiveValueModel.fromMap(
    Map<String, dynamic>? map,
    T? Function(dynamic) converter,
  ) {
    if (map == null) {
      return PagebuilderResponsiveValueModel<T>();
    }

    return PagebuilderResponsiveValueModel(
      mobile: map["mobile"] != null ? converter(map["mobile"]) : null,
      tablet: map["tablet"] != null ? converter(map["tablet"]) : null,
      desktop: map["desktop"] != null ? converter(map["desktop"]) : null,
    );
  }

  PagebuilderResponsiveValue<T> toDomain() {
    return PagebuilderResponsiveValue(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  factory PagebuilderResponsiveValueModel.fromDomain(
    PagebuilderResponsiveValue<T>? value,
  ) {
    if (value == null) {
      return PagebuilderResponsiveValueModel<T>();
    }

    return PagebuilderResponsiveValueModel(
      mobile: value.mobile,
      tablet: value.tablet,
      desktop: value.desktop,
    );
  }

  static Map<String, dynamic>? doubleToMap(
      PagebuilderResponsiveValue<double>? value) {
    if (value == null) return null;
    return PagebuilderResponsiveValueModel.fromDomain(value).toMap((v) => v);
  }

  static PagebuilderResponsiveValue<double>? doubleFromMap(
      Map<String, dynamic>? map) {
    if (map == null) return null;
    return PagebuilderResponsiveValueModel.fromMap(
      map,
      (v) => v as double,
    ).toDomain();
  }

  static Map<String, dynamic>? textAlignToMap(
      PagebuilderResponsiveValue<TextAlign>? value) {
    if (value == null) return null;
    return PagebuilderResponsiveValueModel.fromDomain(value)
        .toMap((v) => v.name);
  }

  static PagebuilderResponsiveValue<TextAlign>? textAlignFromMap(
      Map<String, dynamic>? map) {
    if (map == null) return null;
    return PagebuilderResponsiveValueModel.fromMap(
      map,
      (v) => TextAlign.values.firstWhere((e) => e.name == v),
    ).toDomain();
  }

  static Map<String, dynamic>? alignmentToMap(
      PagebuilderResponsiveValue<Alignment>? value) {
    if (value == null) return null;
    return PagebuilderResponsiveValueModel.fromDomain(value).toMap((v) {
      return {"x": v.x, "y": v.y};
    });
  }

  static PagebuilderResponsiveValue<Alignment>? alignmentFromMap(
      Map<String, dynamic>? map) {
    if (map == null) return null;
    return PagebuilderResponsiveValueModel.fromMap(
      map,
      (v) {
        final alignmentMap = v as Map<String, dynamic>;
        return Alignment(
          alignmentMap["x"] as double,
          alignmentMap["y"] as double,
        );
      },
    ).toDomain();
  }

  static Map<String, dynamic>? boolToMap(
      PagebuilderResponsiveValue<bool>? value) {
    if (value == null) return null;
    return PagebuilderResponsiveValueModel.fromDomain(value).toMap((v) => v);
  }

  static PagebuilderResponsiveValue<bool>? boolFromMap(
      Map<String, dynamic>? map) {
    if (map == null) return null;
    return PagebuilderResponsiveValueModel.fromMap(
      map,
      (v) => v as bool,
    ).toDomain();
  }

  @override
  List<Object?> get props => [mobile, tablet, desktop];
}
