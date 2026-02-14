// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_background.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_image_properties_model.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_paint_model.dart';

class PagebuilderBackgroundModel extends Equatable {
  final Map<String, dynamic>? backgroundPaint;
  final Map<String, dynamic>? imageProperties;
  final Map<String, dynamic>? overlayPaint;

  const PagebuilderBackgroundModel(
      {required this.backgroundPaint,
      required this.imageProperties,
      required this.overlayPaint});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (backgroundPaint != null) map["backgroundPaint"] = backgroundPaint;
    if (imageProperties != null) map["imageProperties"] = imageProperties;
    if (overlayPaint != null) map["overlayPaint"] = overlayPaint;
    return map;
  }

  factory PagebuilderBackgroundModel.fromMap(Map<String, dynamic> map) {
    return PagebuilderBackgroundModel(
        backgroundPaint: map["backgroundPaint"] != null
            ? map["backgroundPaint"] as Map<String, dynamic>
            : null,
        imageProperties: map["imageProperties"] != null
            ? map["imageProperties"] as Map<String, dynamic>
            : null,
        overlayPaint: map["overlayPaint"] != null
            ? map["overlayPaint"] as Map<String, dynamic>
            : null);
  }

  PagebuilderBackgroundModel copyWith(
      {Map<String, dynamic>? backgroundPaint,
      Map<String, dynamic>? imageProperties,
      Map<String, dynamic>? overlayPaint}) {
    return PagebuilderBackgroundModel(
        backgroundPaint: backgroundPaint ?? this.backgroundPaint,
        imageProperties: imageProperties ?? this.imageProperties,
        overlayPaint: overlayPaint ?? this.overlayPaint);
  }

  PagebuilderBackground toDomain(PageBuilderGlobalStyles? globalStyles) {
    return PagebuilderBackground(
        backgroundPaint: backgroundPaint != null
            ? PagebuilderPaintModel.fromMap(backgroundPaint!).toDomain(globalStyles)
            : null,
        imageProperties: imageProperties != null
            ? PageBuilderImagePropertiesModel.fromMap(imageProperties!)
                .toDomain(globalStyles)
            : null,
        overlayPaint: overlayPaint != null
            ? PagebuilderPaintModel.fromMap(overlayPaint!).toDomain(globalStyles)
            : null);
  }

  factory PagebuilderBackgroundModel.fromDomain(
      PagebuilderBackground properties) {
    return PagebuilderBackgroundModel(
        backgroundPaint: properties.backgroundPaint != null
            ? PagebuilderPaintModel.fromDomain(properties.backgroundPaint!)
                .toMap()
            : null,
        imageProperties: properties.imageProperties != null
            ? PageBuilderImagePropertiesModel.fromDomain(
                    properties.imageProperties!)
                .toMap()
            : null,
        overlayPaint: properties.overlayPaint != null
            ? PagebuilderPaintModel.fromDomain(properties.overlayPaint!)
                .toMap()
            : null);
  }

  @override
  List<Object?> get props => [backgroundPaint, imageProperties, overlayPaint];
}
