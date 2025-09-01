import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_calendly_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';

class PagebuilderCalendlyPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final double? width;
  final double? height;
  final double? borderRadius;

  const PagebuilderCalendlyPropertiesModel(
      {required this.width, required this.height, required this.borderRadius});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (width != null) map['width'] = width;
    if (height != null) map['height'] = height;
    if (borderRadius != null) map['borderRadius'] = borderRadius;
    return map;
  }

  factory PagebuilderCalendlyPropertiesModel.fromMap(Map<String, dynamic> map) {
    return PagebuilderCalendlyPropertiesModel(
        width: map['width'] != null ? map['width'] as double : null,
        height: map['height'] != null ? map['height'] as double : null,
        borderRadius:
            map['borderRadius'] != null ? map['borderRadius'] as double : null);
  }

  PagebuilderCalendlyPropertiesModel copyWith(
      {double? width, double? height, double? borderRadius}) {
    return PagebuilderCalendlyPropertiesModel(
        width: width ?? this.width,
        height: height ?? this.height,
        borderRadius: borderRadius ?? this.borderRadius);
  }

  PagebuilderCalendlyProperties toDomain() {
    return PagebuilderCalendlyProperties(
        width: width, height: height, borderRadius: borderRadius);
  }

  factory PagebuilderCalendlyPropertiesModel.fromDomain(
      PagebuilderCalendlyProperties properties) {
    return PagebuilderCalendlyPropertiesModel(
        width: properties.width,
        height: properties.height,
        borderRadius: properties.borderRadius);
  }

  @override
  List<Object?> get props => [width, height, borderRadius];
}
