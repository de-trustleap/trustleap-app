import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:flutter/material.dart';
import "dart:typed_data";
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_paint.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';

void main() {
  group("PagebuilderImageProperties_CopyWith", () {
    test("set width with copyWith should set width for resulting object", () {
      // Given
      final model = PageBuilderImageProperties(
          url: "https://test.de",
          borderRadius: 30.0,
          width: const PagebuilderResponsiveOrConstant.constant(200.0),
          height: const PagebuilderResponsiveOrConstant.constant(200.0),
          contentMode: const PagebuilderResponsiveOrConstant.constant(BoxFit.cover),
          overlayPaint: null,
          showPromoterImage: false);
      final expectedResult = PageBuilderImageProperties(
          url: "https://test.de",
          borderRadius: 30.0,
          width: const PagebuilderResponsiveOrConstant.constant(250.0),
          height: const PagebuilderResponsiveOrConstant.constant(200.0),
          contentMode: const PagebuilderResponsiveOrConstant.constant(BoxFit.cover),
          overlayPaint: null,
          showPromoterImage: false);
      // When
      final result = model.copyWith(width: const PagebuilderResponsiveOrConstant.constant(250.0));
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderImageProperties_DeepCopy", () {
    test("should create independent copy with all properties", () {
      // Given
      final localImageData = Uint8List.fromList([1, 2, 3, 4, 5]);
      final original = PageBuilderImageProperties(
        url: "https://example.com/image.jpg",
        borderRadius: 12.0,
        width: const PagebuilderResponsiveOrConstant.constant(300.0),
        height: const PagebuilderResponsiveOrConstant.constant(200.0),
        contentMode: const PagebuilderResponsiveOrConstant.constant(BoxFit.cover),
        overlayPaint: const PagebuilderPaint.color(Color(0x80000000)),
        localImage: localImageData,
        hasChanged: true,
        showPromoterImage: false,
      );
      // When
      final copy = original.deepCopy();
      // Then
      expect(copy, isNot(same(original)));
      expect(copy.url, equals(original.url));
      expect(copy.borderRadius, equals(original.borderRadius));
      expect(copy.width, equals(original.width));
      expect(copy.height, equals(original.height));
      expect(copy.contentMode, equals(original.contentMode));
      expect(copy.overlayPaint?.color, equals(original.overlayPaint?.color));
      expect(copy.localImage, equals(original.localImage));
      expect(copy.hasChanged, equals(original.hasChanged));
      expect(copy, equals(original));
    });
  });

  group("PagebuilderImageProperties_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PageBuilderImageProperties(
          url: "https://test.de",
          borderRadius: 30.0,
          width: const PagebuilderResponsiveOrConstant.constant(200.0),
          height: const PagebuilderResponsiveOrConstant.constant(200.0),
          contentMode: const PagebuilderResponsiveOrConstant.constant(BoxFit.cover),
          overlayPaint: null,
          showPromoterImage: false);
      final properties2 = PageBuilderImageProperties(
          url: "https://test.de",
          borderRadius: 30.0,
          width: const PagebuilderResponsiveOrConstant.constant(200.0),
          height: const PagebuilderResponsiveOrConstant.constant(200.0),
          contentMode: const PagebuilderResponsiveOrConstant.constant(BoxFit.cover),
          overlayPaint: null,
          showPromoterImage: false);
      // Then
      expect(properties1, properties2);
    });
  });
}
