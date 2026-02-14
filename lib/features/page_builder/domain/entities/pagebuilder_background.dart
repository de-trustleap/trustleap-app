// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_paint.dart';

class PagebuilderBackground extends Equatable {
  final PagebuilderPaint? backgroundPaint;
  final PageBuilderImageProperties? imageProperties;
  final PagebuilderPaint? overlayPaint;

  const PagebuilderBackground(
      {required this.backgroundPaint,
      required this.imageProperties,
      required this.overlayPaint});

  PagebuilderBackground copyWith(
      {PagebuilderPaint? backgroundPaint,
      PageBuilderImageProperties? imageProperties,
      PagebuilderPaint? overlayPaint,
      bool setImagePropertiesNull = false}) {
    return PagebuilderBackground(
        backgroundPaint: backgroundPaint ?? this.backgroundPaint,
        imageProperties: setImagePropertiesNull
            ? null
            : (imageProperties ?? this.imageProperties),
        overlayPaint: overlayPaint ?? this.overlayPaint);
  }

  PagebuilderBackground deepCopy() {
    return PagebuilderBackground(
      backgroundPaint: backgroundPaint?.copyWith(),
      imageProperties: imageProperties?.deepCopy(),
      overlayPaint: overlayPaint?.copyWith(),
    );
  }

  @override
  List<Object?> get props => [backgroundPaint, imageProperties, overlayPaint];
}
