import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_height_properties.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_responsive_or_constant_model.dart';

class PageBuilderHeightPropertiesModel extends Equatable {
  final PagebuilderResponsiveOrConstantModel<int>? height;

  const PageBuilderHeightPropertiesModel({
    required this.height,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (height != null) map['height'] = height!.toMapValue();
    return map;
  }

  factory PageBuilderHeightPropertiesModel.fromMap(Map<String, dynamic> map) {
    return PageBuilderHeightPropertiesModel(
      height: map['height'] != null
          ? PagebuilderResponsiveOrConstantModel.fromMapValue(
              map['height'], (v) => v as int)
          : null,
    );
  }

  PageBuilderHeightProperties toDomain() {
    return PageBuilderHeightProperties(
      height: height?.toDomain(),
    );
  }

  factory PageBuilderHeightPropertiesModel.fromDomain(
      PageBuilderHeightProperties properties) {
    return PageBuilderHeightPropertiesModel(
      height: properties.height != null
          ? PagebuilderResponsiveOrConstantModel.fromDomain(
              properties.height!)
          : null,
    );
  }

  @override
  List<Object?> get props => [height];
}
