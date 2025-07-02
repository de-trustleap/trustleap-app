import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_anchor_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_button_properties_model.dart';

class PagebuilderAnchorButtonPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final String? sectionID;
  final Map<String, dynamic>? buttonProperties;

  const PagebuilderAnchorButtonPropertiesModel({
    required this.sectionID,
    required this.buttonProperties,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (sectionID != null) map['sectionID'] = sectionID;
    if (buttonProperties != null) map['buttonProperties'] = buttonProperties;
    return map;
  }

  factory PagebuilderAnchorButtonPropertiesModel.fromMap(
      Map<String, dynamic> map) {
    return PagebuilderAnchorButtonPropertiesModel(
        sectionID: map['sectionID'] != null ? map['sectionID'] as String : null,
        buttonProperties: map['buttonProperties'] != null
            ? map['buttonProperties'] as Map<String, dynamic>
            : null);
  }

  PagebuilderAnchorButtonPropertiesModel copyWith({
    String? sectionID,
    Map<String, dynamic>? buttonProperties,
  }) {
    return PagebuilderAnchorButtonPropertiesModel(
      sectionID: sectionID ?? this.sectionID,
      buttonProperties: buttonProperties ?? this.buttonProperties,
    );
  }

  PagebuilderAnchorButtonProperties toDomain() {
    return PagebuilderAnchorButtonProperties(
        sectionID: sectionID,
        buttonProperties: buttonProperties != null
            ? PageBuilderButtonPropertiesModel.fromMap(buttonProperties!)
                .toDomain()
            : null);
  }

  factory PagebuilderAnchorButtonPropertiesModel.fromDomain(
      PagebuilderAnchorButtonProperties properties) {
    return PagebuilderAnchorButtonPropertiesModel(
        sectionID: properties.sectionID,
        buttonProperties: properties.buttonProperties != null
            ? PageBuilderButtonPropertiesModel.fromDomain(
                    properties.buttonProperties!)
                .toMap()
            : null);
  }

  @override
  List<Object?> get props => [sectionID, buttonProperties];
}

// TODO: IMPLEMENT MODELS (FERTIG)
// TODO: TESTS FOR MODELS
// TODO: IMPLEMENT WIDGET
// TODO: PUT WIDGET INTO JSON
// TODO: IMPLEMENT CONFIG MENU
