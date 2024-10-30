import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_row_properties.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderRowProperties_CopyWith", () {
    test(
        "set equalHeights with copyWith should set equalHeights for resulting object",
        () {
      // Given
      final model = PagebuilderRowProperties(
          equalHeights: true,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end);
      final expectedResult = PagebuilderRowProperties(
          equalHeights: false,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end);
      // When
      final result = model.copyWith(equalHeights: false);
      // Then
      expect(result, expectedResult);
    });
  });

    group("PagebuilderRowProperties_Props", () {
    test(
        "check if value equality works",
        () {
      // Given
      final properties1 = PagebuilderRowProperties(
          equalHeights: true,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end);
      final properties2 = PagebuilderRowProperties(
          equalHeights: true,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end);
      // Then
      expect(properties1, properties2);
    });
  });
}
