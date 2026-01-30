// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_border.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_paint.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_spacing.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';

class PageBuilderButtonProperties extends Equatable
    implements PageBuilderProperties {
  final PagebuilderResponsiveOrConstant<double>? width;
  final PagebuilderResponsiveOrConstant<double>? height;
  final PagebuilderResponsiveOrConstant<double>? minWidthPercent;
  final PageBuilderSpacing? contentPadding;
  final PagebuilderBorder? border;
  final PagebuilderPaint? backgroundPaint;
  final PageBuilderTextProperties? textProperties;

  const PageBuilderButtonProperties({
    required this.width,
    required this.height,
    required this.minWidthPercent,
    required this.contentPadding,
    required this.border,
    required this.backgroundPaint,
    required this.textProperties,
  });

  PageBuilderButtonProperties copyWith({
    PagebuilderResponsiveOrConstant<double>? width,
    PagebuilderResponsiveOrConstant<double>? height,
    PagebuilderResponsiveOrConstant<double>? minWidthPercent,
    PageBuilderSpacing? contentPadding,
    PagebuilderBorder? border,
    PagebuilderPaint? backgroundPaint,
    PageBuilderTextProperties? textProperties,
    bool removeWidth = false,
    bool removeHeight = false,
    bool removeMinWidthPercent = false,
  }) {
    return PageBuilderButtonProperties(
      width: removeWidth ? null : (width ?? this.width),
      height: removeHeight ? null : (height ?? this.height),
      minWidthPercent: removeMinWidthPercent
          ? null
          : (minWidthPercent ?? this.minWidthPercent),
      contentPadding: contentPadding ?? this.contentPadding,
      border: border ?? this.border,
      backgroundPaint: backgroundPaint ?? this.backgroundPaint,
      textProperties: textProperties ?? this.textProperties,
    );
  }

  PageBuilderButtonProperties deepCopy() {
    return PageBuilderButtonProperties(
      width: width?.deepCopy(),
      height: height?.deepCopy(),
      minWidthPercent: minWidthPercent?.deepCopy(),
      contentPadding: contentPadding?.deepCopy(),
      border: border?.deepCopy(),
      backgroundPaint: backgroundPaint?.deepCopy(),
      textProperties: textProperties?.deepCopy(),
    );
  }

  @override
  List<Object?> get props => [
        width,
        height,
        minWidthPercent,
        contentPadding,
        border,
        backgroundPaint,
        textProperties,
      ];
}
