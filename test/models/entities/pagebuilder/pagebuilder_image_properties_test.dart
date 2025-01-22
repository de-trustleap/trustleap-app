import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:flutter/material.dart';

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
