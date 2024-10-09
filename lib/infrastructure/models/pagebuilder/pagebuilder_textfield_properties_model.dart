import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_textfield_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_text_properties_model.dart';

class PageBuilderTextFieldPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final double? width;
  final int? maxLines;
  final bool? isRequired;
  final Map<String, dynamic>? placeHolderTextProperties;
  final Map<String, dynamic>? textProperties;

  const PageBuilderTextFieldPropertiesModel({
    required this.width,
    required this.maxLines,
    required this.isRequired,
    required this.placeHolderTextProperties,
    required this.textProperties,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (width != null) map['width'] = width;
    if (maxLines != null) map['maxLines'] = maxLines;
    if (isRequired != null) map['isRequired'] = isRequired;
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
        maxLines: map['maxLines'] != null ? map['maxLines'] as int : null,
        isRequired:
            map['isRequired'] != null ? map['isRequired'] as bool : null,
        placeHolderTextProperties: map['placeHolderTextProperties'] != null
            ? map['placeHolderTextProperties'] as Map<String, dynamic>
            : null,
        textProperties: map['textProperties'] != null
            ? map['textProperties'] as Map<String, dynamic>
            : null);
  }

  PageBuilderTextFieldPropertiesModel copyWith({
    double? width,
    int? maxLines,
    bool? isRequired,
    Map<String, dynamic>? placeHolderTextProperties,
    Map<String, dynamic>? textProperties,
  }) {
    return PageBuilderTextFieldPropertiesModel(
      width: width ?? this.width,
      maxLines: maxLines ?? this.maxLines,
      isRequired: isRequired ?? this.isRequired,
      placeHolderTextProperties:
          placeHolderTextProperties ?? this.placeHolderTextProperties,
      textProperties: textProperties ?? this.textProperties,
    );
  }

  PageBuilderTextFieldProperties toDomain() {
    return PageBuilderTextFieldProperties(
        width: width,
        maxLines: maxLines,
        isRequired: isRequired,
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
        maxLines: properties.maxLines,
        isRequired: properties.isRequired,
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
      [width, maxLines, isRequired, placeHolderTextProperties, textProperties];
}
