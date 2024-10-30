import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_shadow.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderShadow_CopyWith", () {
    test(
        "set spreadRadius and offset with copyWith should set spreadRadius and offset for resulting object",
        () {
      // Given
      final model = PageBuilderShadow(
          color: Colors.black,
          spreadRadius: 2.0,
          blurRadius: 2.0,
          offset: Offset(2.0, 5.0));
      final expectedResult = PageBuilderShadow(
          color: Colors.black,
          spreadRadius: 3.0,
          blurRadius: 2.0,
          offset: Offset(3.0, 5.0));
      // When
      final result =
          model.copyWith(spreadRadius: 3.0, offset: Offset(3.0, 5.0));
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderShadow_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PageBuilderShadow(
          color: Colors.black,
          spreadRadius: 2.0,
          blurRadius: 2.0,
          offset: Offset(2.0, 5.0));
      final properties2 = PageBuilderShadow(
          color: Colors.black,
          spreadRadius: 2.0,
          blurRadius: 2.0,
          offset: Offset(2.0, 5.0));
      // Then
      expect(properties1, properties2);
    });
  });
}
