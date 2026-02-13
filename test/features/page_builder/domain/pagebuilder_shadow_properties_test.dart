import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_shadow.dart';
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

  group("PageBuilderShadow_DeepCopy", () {
    test("should create independent copy with all properties", () {
      // Given
      const original = PageBuilderShadow(
        color: Color(0xFF000000),
        spreadRadius: 2.0,
        blurRadius: 8.0,
        offset: Offset(4.0, 4.0),
      );
      // When
      final copy = original.deepCopy();
      // Then
      expect(copy, isNot(same(original)));
      expect(copy.color, equals(original.color));
      expect(copy.spreadRadius, equals(original.spreadRadius));
      expect(copy.blurRadius, equals(original.blurRadius));
      expect(copy.offset, equals(original.offset));
      expect(copy, equals(original));
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
