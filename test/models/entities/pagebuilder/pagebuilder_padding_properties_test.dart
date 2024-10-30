import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_padding.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderPadding_CopyWith", () {
    test("set top and bottom with copyWith should set top and bottom for resulting object", () {
      // Given
      final model = PageBuilderPadding(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0);
      final expectedResult = PageBuilderPadding(top: 20.0, bottom: 20.0, left: 16.0, right: 16.0);
      // When
      final result = model.copyWith(top: 20.0, bottom: 20.0);
      // Then
      expect(result, expectedResult);
    });
  });

    group("PagebuilderPadding_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PageBuilderPadding(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0);
      final properties2 = PageBuilderPadding(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0);
      // Then
      expect(properties1, properties2);
    });
  });
}