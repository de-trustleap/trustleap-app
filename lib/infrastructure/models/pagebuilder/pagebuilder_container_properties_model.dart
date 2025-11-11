// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_container_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/infrastructure/models/model_helper/shadow_mapper.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_border_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_shadow_model.dart';

class PageBuilderContainerPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final Map<String, dynamic>? border;
  final Map<String, dynamic>? shadow;

  const PageBuilderContainerPropertiesModel({
    required this.border,
    required this.shadow,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (border != null) map['border'] = border;
    if (shadow != null) map['shadow'] = shadow;
    return map;
  }

  factory PageBuilderContainerPropertiesModel.fromMap(
      Map<String, dynamic> map) {
    return PageBuilderContainerPropertiesModel(
        border: map['border'] != null
            ? map['border'] as Map<String, dynamic>
            : null,
        shadow: map['shadow'] != null
            ? map['shadow'] as Map<String, dynamic>
            : null);
  }

  PageBuilderContainerPropertiesModel copyWith({
    Map<String, dynamic>? border,
    Map<String, dynamic>? shadow,
  }) {
    return PageBuilderContainerPropertiesModel(
      border: border ?? this.border,
      shadow: shadow ?? this.shadow,
    );
  }

  PageBuilderContainerProperties toDomain() {
    return PageBuilderContainerProperties(
        border: border != null
            ? PagebuilderBorderModel.fromMap(border!).toDomain()
            : null,
        shadow: shadow != null
            ? PageBuilderShadowModel.fromMap(shadow!).toDomain()
            : null);
  }

  factory PageBuilderContainerPropertiesModel.fromDomain(
      PageBuilderContainerProperties properties) {
    return PageBuilderContainerPropertiesModel(
        border: properties.border != null
            ? PagebuilderBorderModel.fromDomain(properties.border!).toMap()
            : null,
        shadow: ShadowMapper.getMapFromShadow(properties.shadow));
  }

  @override
  List<Object?> get props => [border, shadow];
}
