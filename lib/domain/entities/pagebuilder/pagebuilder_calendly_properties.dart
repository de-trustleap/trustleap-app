import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';

class PagebuilderCalendlyProperties extends Equatable
    implements PageBuilderProperties {
  final double? width;
  final double? height;
  final double? borderRadius;

  const PagebuilderCalendlyProperties(
      {required this.width, required this.height, required this.borderRadius});

  PagebuilderCalendlyProperties copyWith({
    double? width,
    double? height,
    double? borderRadius,
  }) {
    return PagebuilderCalendlyProperties(
      width: width ?? this.width,
      height: height ?? this.height,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  List<Object?> get props => [width, height, borderRadius];
}


// TODO: MODELS IMPLEMENTIEREN
// TODO: WIDGET IMPLEMENTIEREN
// TODO: NEUES JSON ERSTELLEN UND TESTEN
// TODO: EDIT LANDINGPAGE FÜR CALENDLY IMPLEMENTIEREN