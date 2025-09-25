import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_paint_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_text_properties_model.dart';

class PageBuilderButtonPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final double? width;
  final double? height;
  final double? borderRadius;
  final Map<String, dynamic>? backgroundPaint;
  final Map<String, dynamic>? textProperties;

  const PageBuilderButtonPropertiesModel({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.backgroundPaint,
    required this.textProperties,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (width != null) map['width'] = width;
    if (height != null) map['height'] = height;
    if (borderRadius != null) map['borderRadius'] = borderRadius;
    if (backgroundPaint != null) map['backgroundPaint'] = backgroundPaint;
    if (textProperties != null) map['textProperties'] = textProperties;
    return map;
  }

  factory PageBuilderButtonPropertiesModel.fromMap(Map<String, dynamic> map) {
    return PageBuilderButtonPropertiesModel(
        width: map['width'] != null ? map['width'] as double : null,
        height: map['height'] != null ? map['height'] as double : null,
        borderRadius:
            map['borderRadius'] != null ? map['borderRadius'] as double : null,
        backgroundPaint: map['backgroundPaint'] != null
            ? map['backgroundPaint'] as Map<String, dynamic>
            : null,
        textProperties: map['textProperties'] != null
            ? map['textProperties'] as Map<String, dynamic>
            : null);
  }

  PageBuilderButtonPropertiesModel copyWith({
    double? width,
    double? height,
    double? borderRadius,
    Map<String, dynamic>? backgroundPaint,
    Map<String, dynamic>? textProperties,
  }) {
    return PageBuilderButtonPropertiesModel(
      width: width ?? this.width,
      height: height ?? this.height,
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundPaint: backgroundPaint ?? this.backgroundPaint,
      textProperties: textProperties ?? this.textProperties,
    );
  }

  PageBuilderButtonProperties toDomain() {
    return PageBuilderButtonProperties(
        width: width,
        height: height,
        borderRadius: borderRadius,
        backgroundPaint: backgroundPaint != null
            ? PagebuilderPaintModel.fromMap(backgroundPaint!).toDomain()
            : null,
        textProperties: textProperties != null
            ? PageBuilderTextPropertiesModel.fromMap(textProperties!).toDomain()
            : null);
  }

  factory PageBuilderButtonPropertiesModel.fromDomain(
      PageBuilderButtonProperties properties) {
    return PageBuilderButtonPropertiesModel(
        width: properties.width,
        height: properties.height,
        borderRadius: properties.borderRadius,
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
      [width, height, borderRadius, backgroundPaint, textProperties];
}
