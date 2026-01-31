import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_border_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_paint_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_responsive_or_constant_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_spacing_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_text_properties_model.dart';

class PageBuilderButtonPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final PagebuilderResponsiveOrConstantModel<String>? sizeMode;
  final PagebuilderResponsiveOrConstantModel<double>? width;
  final PagebuilderResponsiveOrConstantModel<double>? height;
  final PagebuilderResponsiveOrConstantModel<double>? minWidthPercent;
  final Map<String, dynamic>? contentPadding;
  final Map<String, dynamic>? border;
  final Map<String, dynamic>? backgroundPaint;
  final Map<String, dynamic>? textProperties;

  const PageBuilderButtonPropertiesModel({
    required this.sizeMode,
    required this.width,
    required this.height,
    required this.minWidthPercent,
    required this.contentPadding,
    required this.border,
    required this.backgroundPaint,
    required this.textProperties,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (sizeMode != null) map['sizeMode'] = sizeMode!.toMapValue();
    if (width != null) map['width'] = width!.toMapValue();
    if (height != null) map['height'] = height!.toMapValue();
    if (minWidthPercent != null) {
      map['minWidthPercent'] = minWidthPercent!.toMapValue();
    }
    if (contentPadding != null) map['contentPadding'] = contentPadding;
    if (border != null) map['border'] = border;
    if (backgroundPaint != null) map['backgroundPaint'] = backgroundPaint;
    if (textProperties != null) map['textProperties'] = textProperties;
    return map;
  }

  factory PageBuilderButtonPropertiesModel.fromMap(Map<String, dynamic> map) {
    return PageBuilderButtonPropertiesModel(
        sizeMode: PagebuilderResponsiveOrConstantModel.fromMapValue(
            map['sizeMode'], (v) => v as String),
        width: PagebuilderResponsiveOrConstantModel.fromMapValue(
            map['width'], (v) => v as double),
        height: PagebuilderResponsiveOrConstantModel.fromMapValue(
            map['height'], (v) => v as double),
        minWidthPercent: PagebuilderResponsiveOrConstantModel.fromMapValue(
            map['minWidthPercent'], (v) => v as double),
        contentPadding: map['contentPadding'] != null
            ? map['contentPadding'] as Map<String, dynamic>
            : null,
        border: map['border'] != null
            ? map['border'] as Map<String, dynamic>
            : null,
        backgroundPaint: map['backgroundPaint'] != null
            ? map['backgroundPaint'] as Map<String, dynamic>
            : null,
        textProperties: map['textProperties'] != null
            ? map['textProperties'] as Map<String, dynamic>
            : null);
  }

  PageBuilderButtonPropertiesModel copyWith({
    PagebuilderResponsiveOrConstantModel<String>? sizeMode,
    PagebuilderResponsiveOrConstantModel<double>? width,
    PagebuilderResponsiveOrConstantModel<double>? height,
    PagebuilderResponsiveOrConstantModel<double>? minWidthPercent,
    Map<String, dynamic>? contentPadding,
    Map<String, dynamic>? border,
    Map<String, dynamic>? backgroundPaint,
    Map<String, dynamic>? textProperties,
  }) {
    return PageBuilderButtonPropertiesModel(
      sizeMode: sizeMode ?? this.sizeMode,
      width: width ?? this.width,
      height: height ?? this.height,
      minWidthPercent: minWidthPercent ?? this.minWidthPercent,
      contentPadding: contentPadding ?? this.contentPadding,
      border: border ?? this.border,
      backgroundPaint: backgroundPaint ?? this.backgroundPaint,
      textProperties: textProperties ?? this.textProperties,
    );
  }

  static PagebuilderButtonSizeMode _sizeModeFromString(String value) {
    switch (value) {
      case 'minWidth':
        return PagebuilderButtonSizeMode.minWidth;
      case 'fixed':
        return PagebuilderButtonSizeMode.fixed;
      default:
        return PagebuilderButtonSizeMode.auto;
    }
  }

  static String _sizeModeToString(PagebuilderButtonSizeMode mode) {
    return mode.name;
  }

  static PagebuilderResponsiveOrConstant<PagebuilderButtonSizeMode>?
      _sizeModeToDomain(
          PagebuilderResponsiveOrConstantModel<String>? model) {
    if (model == null) return null;
    if (model.constantValue != null) {
      return PagebuilderResponsiveOrConstant.constant(
          _sizeModeFromString(model.constantValue!));
    }
    if (model.responsiveValue != null) {
      return PagebuilderResponsiveOrConstant.responsive(
          model.responsiveValue!.map(
              (key, value) => MapEntry(key, _sizeModeFromString(value))));
    }
    return null;
  }

  static PagebuilderResponsiveOrConstantModel<String>? _sizeModeFromDomain(
      PagebuilderResponsiveOrConstant<PagebuilderButtonSizeMode>? value) {
    if (value == null) return null;
    if (value.constantValue != null) {
      return PagebuilderResponsiveOrConstantModel.constant(
          _sizeModeToString(value.constantValue!));
    }
    if (value.responsiveValue != null) {
      return PagebuilderResponsiveOrConstantModel.responsive(
          value.responsiveValue!.map(
              (key, value) => MapEntry(key, _sizeModeToString(value))));
    }
    return null;
  }

  PageBuilderButtonProperties toDomain(PageBuilderGlobalStyles? globalStyles) {
    return PageBuilderButtonProperties(
        sizeMode: _sizeModeToDomain(sizeMode),
        width: width?.toDomain(),
        height: height?.toDomain(),
        minWidthPercent: minWidthPercent?.toDomain(),
        contentPadding: contentPadding != null
            ? PageBuilderSpacingModel.fromMap(contentPadding).toDomain()
            : null,
        border: border != null
            ? PagebuilderBorderModel.fromMap(border!).toDomain(globalStyles)
            : null,
        backgroundPaint: backgroundPaint != null
            ? PagebuilderPaintModel.fromMap(backgroundPaint!).toDomain(globalStyles)
            : null,
        textProperties: textProperties != null
            ? PageBuilderTextPropertiesModel.fromMap(textProperties!).toDomain(globalStyles)
            : null);
  }

  factory PageBuilderButtonPropertiesModel.fromDomain(
      PageBuilderButtonProperties properties) {
    return PageBuilderButtonPropertiesModel(
        sizeMode: _sizeModeFromDomain(properties.sizeMode),
        width: PagebuilderResponsiveOrConstantModel.fromDomain(
            properties.width),
        height: PagebuilderResponsiveOrConstantModel.fromDomain(
            properties.height),
        minWidthPercent: PagebuilderResponsiveOrConstantModel.fromDomain(
            properties.minWidthPercent),
        contentPadding: properties.contentPadding != null
            ? PageBuilderSpacingModel.fromDomain(properties.contentPadding)
                .toMap()
            : null,
        border: properties.border != null
            ? PagebuilderBorderModel.fromDomain(properties.border!).toMap()
            : null,
        backgroundPaint: properties.backgroundPaint != null
            ? PagebuilderPaintModel.fromDomain(properties.backgroundPaint!)
                .toMap()
            : null,
        textProperties: properties.textProperties != null
            ? PageBuilderTextPropertiesModel.fromDomain(
                    properties.textProperties!)
                .toMap()
            : null);
  }

  @override
  List<Object?> get props =>
      [sizeMode, width, height, minWidthPercent, contentPadding, border, backgroundPaint, textProperties];
}
