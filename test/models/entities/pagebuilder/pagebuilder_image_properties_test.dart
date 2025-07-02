import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:flutter/material.dart';
import "dart:typed_data";

void main() {
  group("PagebuilderImageProperties_CopyWith", () {
    test("set width with copyWith should set width for resulting object", () {
      // Given
      final model = PageBuilderImageProperties(
          url: "https://test.de",
          borderRadius: 30.0,
          width: 200.0,
          height: 200.0,
          contentMode: BoxFit.cover,
          overlayColor: null);
      final expectedResult = PageBuilderImageProperties(
          url: "https://test.de",
          borderRadius: 30.0,
          width: 250.0,
          height: 200.0,
          contentMode: BoxFit.cover,
          overlayColor: null);
      // When
      final result = model.copyWith(width: 250.0);
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
        width: 300.0,
        height: 200.0,
        contentMode: BoxFit.cover,
        overlayColor: const Color(0x80000000),
        localImage: localImageData,
        hasChanged: true,
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
      expect(copy.overlayColor, equals(original.overlayColor));
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
          width: 200.0,
          height: 200.0,
          contentMode: BoxFit.cover,
          overlayColor: null);
      final properties2 = PageBuilderImageProperties(
          url: "https://test.de",
          borderRadius: 30.0,
          width: 200.0,
          height: 200.0,
          contentMode: BoxFit.cover,
          overlayColor: null);
      // Then
      expect(properties1, properties2);
    });
  });
}
