import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_icon_properties.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderIconProperties_CopyWith", () {
    test("set size with copyWith should set size for resulting object", () {
      // Given
      final model = PageBuilderIconProperties(
          code: "35A", size: 24.0, color: Colors.black);
      final expectedResult = PageBuilderIconProperties(
          code: "35A", size: 30.0, color: Colors.black);
      // When
      final result = model.copyWith(size: 30.0);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderIconProperties_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PageBuilderIconProperties(
          code: "35A", size: 24.0, color: Colors.black);
      final properties2 = PageBuilderIconProperties(
          code: "35A", size: 24.0, color: Colors.black);
      // Then
      expect(properties1, properties2);
    });
  });
}
