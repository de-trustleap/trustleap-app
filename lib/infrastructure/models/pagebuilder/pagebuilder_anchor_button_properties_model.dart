import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_anchor_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_button_properties_model.dart';

class PagebuilderAnchorButtonPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final String? sectionName;
  final Map<String, dynamic>? buttonProperties;

  const PagebuilderAnchorButtonPropertiesModel({
    required this.sectionName,
    required this.buttonProperties,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (sectionName != null) map['sectionName'] = sectionName;
    if (buttonProperties != null) map['buttonProperties'] = buttonProperties;
    return map;
  }

  factory PagebuilderAnchorButtonPropertiesModel.fromMap(
      Map<String, dynamic> map) {
    return PagebuilderAnchorButtonPropertiesModel(
        sectionName:
            map['sectionName'] != null ? map['sectionName'] as String : null,
        buttonProperties: map['buttonProperties'] != null
            ? map['buttonProperties'] as Map<String, dynamic>
            : null);
  }

  PagebuilderAnchorButtonPropertiesModel copyWith({
    String? sectionName,
    Map<String, dynamic>? buttonProperties,
  }) {
    return PagebuilderAnchorButtonPropertiesModel(
      sectionName: sectionName ?? this.sectionName,
      buttonProperties: buttonProperties ?? this.buttonProperties,
    );
  }

  PagebuilderAnchorButtonProperties toDomain() {
    return PagebuilderAnchorButtonProperties(
        sectionName: sectionName,
        buttonProperties: buttonProperties != null
            ? PageBuilderButtonPropertiesModel.fromMap(buttonProperties!)
                .toDomain()
            : null);
  }

  factory PagebuilderAnchorButtonPropertiesModel.fromDomain(
      PagebuilderAnchorButtonProperties properties) {
    return PagebuilderAnchorButtonPropertiesModel(
        sectionName: properties.sectionName,
        buttonProperties: properties.buttonProperties != null
            ? PageBuilderButtonPropertiesModel.fromDomain(
                    properties.buttonProperties!)
                .toMap()
            : null);
  }

  @override
  List<Object?> get props => [sectionName, buttonProperties];
}
