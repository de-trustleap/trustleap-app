import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_textfield_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_text_properties_model.dart';

class PageBuilderTextFieldPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final double? width;
  final double? height;
  final Map<String, dynamic>? placeHolderTextProperties;
  final Map<String, dynamic>? textProperties;

  const PageBuilderTextFieldPropertiesModel({
    required this.width,
    required this.height,
    required this.placeHolderTextProperties,
    required this.textProperties,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (width != null) map['width'] = width;
    if (height != null) map['height'] = height;
    if (placeHolderTextProperties != null) {
      map['placeHolderTextProperties'] = placeHolderTextProperties;
    }
    if (textProperties != null) map['textProperties'] = textProperties;
    return map;
  }

  factory PageBuilderTextFieldPropertiesModel.fromMap(
      Map<String, dynamic> map) {
    return PageBuilderTextFieldPropertiesModel(
        width: map['width'] != null ? map['width'] as double : null,
        height: map['height'] != null ? map['height'] as double : null,
        placeHolderTextProperties: map['placeHolderTextProperties'] != null
            ? map['placeHolderTextProperties'] as Map<String, dynamic>
            : null,
        textProperties: map['textProperties'] != null
            ? map['textProperties'] as Map<String, dynamic>
            : null);
  }

  PageBuilderTextFieldPropertiesModel copyWith({
    double? width,
    double? height,
    Map<String, dynamic>? placeHolderTextProperties,
    Map<String, dynamic>? textProperties,
  }) {
    return PageBuilderTextFieldPropertiesModel(
      width: width ?? this.width,
      height: height ?? this.height,
      placeHolderTextProperties:
          placeHolderTextProperties ?? this.placeHolderTextProperties,
      textProperties: textProperties ?? this.textProperties,
    );
  }

  PageBuilderTextFieldProperties toDomain() {
    return PageBuilderTextFieldProperties(
        width: width,
        height: height,
        placeHolderTextProperties: placeHolderTextProperties != null
            ? PageBuilderTextPropertiesModel.fromMap(placeHolderTextProperties!)
                .toDomain()
            : null,
        textProperties: textProperties != null
            ? PageBuilderTextPropertiesModel.fromMap(textProperties!).toDomain()
            : null);
  }

  factory PageBuilderTextFieldPropertiesModel.fromDomain(
      PageBuilderTextFieldProperties properties) {
    return PageBuilderTextFieldPropertiesModel(
        width: properties.width,
        height: properties.height,
        placeHolderTextProperties: properties.placeHolderTextProperties != null
            ? PageBuilderTextPropertiesModel.fromDomain(
                    properties.placeHolderTextProperties!)
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
      [width, height, placeHolderTextProperties, textProperties];
}
