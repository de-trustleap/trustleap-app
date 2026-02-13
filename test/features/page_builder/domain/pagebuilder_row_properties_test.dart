import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_row_properties.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderRowProperties_CopyWith", () {
    test(
        "set equalHeights with copyWith should set equalHeights for resulting object",
        () {
      // Given
      const model = PagebuilderRowProperties(
          equalHeights: true,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          switchToColumnFor: null);
      final expectedResult = PagebuilderRowProperties(
          equalHeights: false,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          switchToColumnFor: null);
      // When
      final result = model.copyWith(equalHeights: false);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderRowProperties deepCopy", () {
    test("should create independent copy with all properties", () {
      // Given
      const original = PagebuilderRowProperties(
        equalHeights: true,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        switchToColumnFor: null,
      );
      // When
      final copy = original.deepCopy();
      // Then
      expect(copy, isNot(same(original)));
      expect(copy.equalHeights, equals(original.equalHeights));
      expect(copy.mainAxisAlignment, equals(original.mainAxisAlignment));
      expect(copy.crossAxisAlignment, equals(original.crossAxisAlignment));
      expect(copy, equals(original));
    });
  });

  group("PagebuilderRowProperties_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PagebuilderRowProperties(
          equalHeights: true,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          switchToColumnFor: null);
      final properties2 = PagebuilderRowProperties(
          equalHeights: true,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          switchToColumnFor: null);
      // Then
      expect(properties1, properties2);
    });
  });
}
