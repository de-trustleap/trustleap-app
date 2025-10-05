// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_paint.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';

class PageBuilderButtonProperties extends Equatable
    implements PageBuilderProperties {
  final PagebuilderResponsiveOrConstant<double>? width;
  final PagebuilderResponsiveOrConstant<double>? height;
  final double? borderRadius;
  final PagebuilderPaint? backgroundPaint;
  final PageBuilderTextProperties? textProperties;

  const PageBuilderButtonProperties({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.backgroundPaint,
    required this.textProperties,
  });

  PageBuilderButtonProperties copyWith({
    PagebuilderResponsiveOrConstant<double>? width,
    PagebuilderResponsiveOrConstant<double>? height,
    double? borderRadius,
    PagebuilderPaint? backgroundPaint,
    PageBuilderTextProperties? textProperties,
  }) {
    return PageBuilderButtonProperties(
      width: width ?? this.width,
      height: height ?? this.height,
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundPaint: backgroundPaint ?? this.backgroundPaint,
      textProperties: textProperties ?? this.textProperties,
    );
  }

  PageBuilderButtonProperties deepCopy() {
    return PageBuilderButtonProperties(
      width: width?.deepCopy(),
      height: height?.deepCopy(),
      borderRadius: borderRadius,
      backgroundPaint: backgroundPaint?.deepCopy(),
      textProperties: textProperties?.deepCopy(),
    );
  }

  @override
  List<Object?> get props =>
      [width, height, borderRadius, backgroundPaint, textProperties];
}
