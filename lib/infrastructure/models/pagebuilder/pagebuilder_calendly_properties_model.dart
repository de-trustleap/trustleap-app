import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_calendly_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';

class PagebuilderCalendlyPropertiesModel extends Equatable
    implements PageBuilderProperties {
  final double? width;
  final double? height;
  final double? borderRadius;
  final String? calendlyEventUrl;
  final String? eventTypeName;

  const PagebuilderCalendlyPropertiesModel({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.calendlyEventUrl,
    required this.eventTypeName,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (width != null) map['width'] = width;
    if (height != null) map['height'] = height;
    if (borderRadius != null) map['borderRadius'] = borderRadius;
    if (calendlyEventUrl != null) map['calendlyEventUrl'] = calendlyEventUrl;
    if (eventTypeName != null) map['eventTypeName'] = eventTypeName;
    return map;
  }

  factory PagebuilderCalendlyPropertiesModel.fromMap(Map<String, dynamic> map) {
    return PagebuilderCalendlyPropertiesModel(
      width: map['width'] != null ? map['width'] as double : null,
      height: map['height'] != null ? map['height'] as double : null,
      borderRadius: map['borderRadius'] != null ? map['borderRadius'] as double : null,
      calendlyEventUrl: map['calendlyEventUrl'] != null ? map['calendlyEventUrl'] as String : null,
      eventTypeName: map['eventTypeName'] != null ? map['eventTypeName'] as String : null,
    );
  }

  PagebuilderCalendlyPropertiesModel copyWith({
    double? width,
    double? height,
    double? borderRadius,
    String? calendlyEventUrl,
    String? eventTypeName,
  }) {
    return PagebuilderCalendlyPropertiesModel(
      width: width ?? this.width,
      height: height ?? this.height,
      borderRadius: borderRadius ?? this.borderRadius,
      calendlyEventUrl: calendlyEventUrl ?? this.calendlyEventUrl,
      eventTypeName: eventTypeName ?? this.eventTypeName,
    );
  }

  PagebuilderCalendlyProperties toDomain() {
    return PagebuilderCalendlyProperties(
      width: width,
      height: height,
      borderRadius: borderRadius,
      calendlyEventUrl: calendlyEventUrl,
      eventTypeName: eventTypeName,
    );
  }

  factory PagebuilderCalendlyPropertiesModel.fromDomain(
      PagebuilderCalendlyProperties properties) {
    return PagebuilderCalendlyPropertiesModel(
      width: properties.width,
      height: properties.height,
      borderRadius: properties.borderRadius,
      calendlyEventUrl: properties.calendlyEventUrl,
      eventTypeName: properties.eventTypeName,
    );
  }

  @override
  List<Object?> get props => [width, height, borderRadius, calendlyEventUrl, eventTypeName];
}
