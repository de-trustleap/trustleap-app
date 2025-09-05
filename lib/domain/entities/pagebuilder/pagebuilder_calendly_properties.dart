import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';

class PagebuilderCalendlyProperties extends Equatable
    implements PageBuilderProperties {
  final double? width;
  final double? height;
  final double? borderRadius;
  final String? calendlyEventURL;
  final String? eventTypeName;

  const PagebuilderCalendlyProperties({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.calendlyEventURL,
    required this.eventTypeName,
  });

  PagebuilderCalendlyProperties copyWith({
    double? width,
    double? height,
    double? borderRadius,
    String? calendlyEventURL,
    String? eventTypeName,
  }) {
    return PagebuilderCalendlyProperties(
      width: width ?? this.width,
      height: height ?? this.height,
      borderRadius: borderRadius ?? this.borderRadius,
      calendlyEventURL: calendlyEventURL ?? this.calendlyEventURL,
      eventTypeName: eventTypeName ?? this.eventTypeName,
    );
  }

  @override
  List<Object?> get props =>
      [width, height, borderRadius, calendlyEventURL, eventTypeName];
}
