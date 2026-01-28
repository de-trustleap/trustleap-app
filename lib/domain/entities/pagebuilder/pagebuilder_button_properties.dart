// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_border.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_paint.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';

class PageBuilderButtonProperties extends Equatable
    implements PageBuilderProperties {
  final PagebuilderResponsiveOrConstant<double>? width;
  final PagebuilderResponsiveOrConstant<double>? height;
  final PagebuilderBorder? border;
  final PagebuilderPaint? backgroundPaint;
  final PageBuilderTextProperties? textProperties;

  const PageBuilderButtonProperties({
    required this.width,
    required this.height,
    required this.border,
    required this.backgroundPaint,
    required this.textProperties,
  });

  PageBuilderButtonProperties copyWith({
    PagebuilderResponsiveOrConstant<double>? width,
    PagebuilderResponsiveOrConstant<double>? height,
    PagebuilderBorder? border,
    PagebuilderPaint? backgroundPaint,
    PageBuilderTextProperties? textProperties,
    bool removeWidth = false,
  }) {
    return PageBuilderButtonProperties(
      width: removeWidth ? null : (width ?? this.width),
      height: height ?? this.height,
      border: border ?? this.border,
      backgroundPaint: backgroundPaint ?? this.backgroundPaint,
      textProperties: textProperties ?? this.textProperties,
    );
  }

  PageBuilderButtonProperties deepCopy() {
    return PageBuilderButtonProperties(
      width: width?.deepCopy(),
      height: height?.deepCopy(),
      border: border?.deepCopy(),
      backgroundPaint: backgroundPaint?.deepCopy(),
      textProperties: textProperties?.deepCopy(),
    );
  }

  @override
  List<Object?> get props =>
      [width, height, border, backgroundPaint, textProperties];
}
