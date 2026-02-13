import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_anchor_button_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_button_properties_model.dart';

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

  PagebuilderAnchorButtonProperties toDomain(PageBuilderGlobalStyles? globalStyles) {
    return PagebuilderAnchorButtonProperties(
        sectionName: sectionName,
        buttonProperties: buttonProperties != null
            ? PageBuilderButtonPropertiesModel.fromMap(buttonProperties!)
                .toDomain(globalStyles)
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
