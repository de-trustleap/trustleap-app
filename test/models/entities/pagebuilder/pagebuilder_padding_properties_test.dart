import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_spacing.dart';
import 'package:flutter/material.dart';

void main() {
  group("PageBuilderSpacing_CopyWith", () {
    test(
        "set top and bottom with copyWith should set top and bottom for resulting object",
        () {
      // Given
      final model =
          PageBuilderSpacing(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0);
      final expectedResult =
          PageBuilderSpacing(top: 20.0, bottom: 20.0, left: 16.0, right: 16.0);
      // When
      final result = model.copyWith(top: 20.0, bottom: 20.0);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderSpacing_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 =
          PageBuilderSpacing(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0);
      final properties2 =
          PageBuilderSpacing(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0);
      // Then
      expect(properties1, properties2);
    });
  });
}
