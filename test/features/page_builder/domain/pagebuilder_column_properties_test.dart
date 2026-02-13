import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_column_properties.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderColumnProperties_CopyWith", () {
    test(
        "set mainAxisAlignment with copyWith should set mainAxisAlignment for resulting object",
        () {
      // Given
      final model = PagebuilderColumnProperties(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center);
      final expectedResult = PagebuilderColumnProperties(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center);
      // When
      final result = model.copyWith(mainAxisAlignment: MainAxisAlignment.end);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderColumnProperties deepCopy", () {
    test("should create independent copy with all properties", () {
      // Given
      const original = PagebuilderColumnProperties(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
      );
      // When
      final copy = original.deepCopy();
      // Then
      expect(copy, isNot(same(original)));
      expect(copy.mainAxisAlignment, equals(original.mainAxisAlignment));
      expect(copy.crossAxisAlignment, equals(original.crossAxisAlignment));
      expect(copy, equals(original));
    });
  });

  group("PagebuilderColumnProperties_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PagebuilderColumnProperties(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center);
      final properties2 = PagebuilderColumnProperties(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center);
      // Then
      expect(properties1, properties2);
    });
  });
}
