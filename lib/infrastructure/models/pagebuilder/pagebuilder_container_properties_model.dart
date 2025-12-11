// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_container_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/infrastructure/models/model_helper/shadow_mapper.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_border_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_responsive_or_constant_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_shadow_model.dart';

class PageBuilderContainerPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final Map<String, dynamic>? border;
  final Map<String, dynamic>? shadow;
  final PagebuilderResponsiveOrConstantModel<double>? width;
  final PagebuilderResponsiveOrConstantModel<double>? height;

  const PageBuilderContainerPropertiesModel({
    required this.border,
    required this.shadow,
    required this.width,
    required this.height,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (border != null) map['border'] = border;
    if (shadow != null) map['shadow'] = shadow;
    if (width != null) map['width'] = width!.toMapValue();
    if (height != null) map['height'] = height!.toMapValue();
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
            : null,
        width: PagebuilderResponsiveOrConstantModel.fromMapValue(
          map['width'],
          (v) => v as double,
        ),
        height: PagebuilderResponsiveOrConstantModel.fromMapValue(
          map['height'],
          (v) => v as double,
        ));
  }

  PageBuilderContainerPropertiesModel copyWith({
    Map<String, dynamic>? border,
    Map<String, dynamic>? shadow,
    PagebuilderResponsiveOrConstantModel<double>? width,
    PagebuilderResponsiveOrConstantModel<double>? height,
  }) {
    return PageBuilderContainerPropertiesModel(
      border: border ?? this.border,
      shadow: shadow ?? this.shadow,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  PageBuilderContainerProperties toDomain(PageBuilderGlobalStyles? globalStyles) {
    return PageBuilderContainerProperties(
        border: border != null
            ? PagebuilderBorderModel.fromMap(border!).toDomain(globalStyles)
            : null,
        shadow: shadow != null
            ? PageBuilderShadowModel.fromMap(shadow!).toDomain()
            : null,
        width: width?.toDomain(),
        height: height?.toDomain());
  }

  factory PageBuilderContainerPropertiesModel.fromDomain(
      PageBuilderContainerProperties properties) {
    return PageBuilderContainerPropertiesModel(
        border: properties.border != null
            ? PagebuilderBorderModel.fromDomain(properties.border!).toMap()
            : null,
        shadow: ShadowMapper.getMapFromShadow(properties.shadow),
        width: PagebuilderResponsiveOrConstantModel.fromDomain(properties.width),
        height:
            PagebuilderResponsiveOrConstantModel.fromDomain(properties.height));
  }

  @override
  List<Object?> get props => [border, shadow, width, height];
}
