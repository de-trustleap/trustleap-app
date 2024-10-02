// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_container_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_shadow.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_shadow_model.dart';

class PageBuilderContainerPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final double? borderRadius;
  final Map<String, dynamic>? shadow;

  const PageBuilderContainerPropertiesModel({
    required this.borderRadius,
    required this.shadow,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (borderRadius != null) map['borderRadius'] = borderRadius;
    if (shadow != null) map['shadow'] = shadow;
    return map;
  }

  factory PageBuilderContainerPropertiesModel.fromMap(
      Map<String, dynamic> map) {
    return PageBuilderContainerPropertiesModel(
        borderRadius:
            map['borderRadius'] != null ? map['borderRadius'] as double : null,
        shadow: map['shadow'] != null
            ? map['shadow'] as Map<String, dynamic>
            : null);
  }

  PageBuilderContainerPropertiesModel copyWith({
    double? borderRadius,
    Map<String, dynamic>? shadow,
  }) {
    return PageBuilderContainerPropertiesModel(
      borderRadius: borderRadius ?? this.borderRadius,
      shadow: shadow ?? this.shadow,
    );
  }

  PageBuilderContainerProperties toDomain() {
    return PageBuilderContainerProperties(
        borderRadius: borderRadius,
        shadow: shadow != null
            ? PageBuilderShadowModel.fromMap(shadow!).toDomain()
            : null);
  }

  factory PageBuilderContainerPropertiesModel.fromDomain(
      PageBuilderContainerProperties properties) {
    return PageBuilderContainerPropertiesModel(
        borderRadius: properties.borderRadius,
        shadow: _getMapFromShadow(properties.shadow));
  }

  static Map<String, dynamic>? _getMapFromShadow(PageBuilderShadow? shadow) {
    if (shadow == null) {
      return null;
    }
    final shadowModel = PageBuilderShadowModel.fromDomain(shadow);
    Map<String, dynamic> map = {};
    if (shadowModel.color != null) map['color'] = shadowModel.color;
    if (shadowModel.spreadRadius != null && shadowModel.spreadRadius != 0) {
      map['spreadRadius'] = shadowModel.spreadRadius;
    }
    if (shadowModel.blurRadius != null && shadowModel.blurRadius != 0) {
      map['blurRadius'] = shadowModel.blurRadius;
    }
    if (shadowModel.offset != null) map['offset'] = shadowModel.offset;
    if (map.isEmpty) {
      return null;
    } else {
      return map;
    }
  }

  @override
  List<Object?> get props => [borderRadius, shadow];
}
