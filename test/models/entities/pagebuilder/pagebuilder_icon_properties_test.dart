import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_icon_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderIconProperties_CopyWith", () {
    test("set size with copyWith should set size for resulting object", () {
      // Given
      const model = PageBuilderIconProperties(
          code: "35A",
          size: PagebuilderResponsiveOrConstant.constant(24.0),
          color: Colors.black);
      const expectedResult = PageBuilderIconProperties(
          code: "35A",
          size: PagebuilderResponsiveOrConstant.constant(30.0),
          color: Colors.black);
      // When
      final result = model.copyWith(
          size: const PagebuilderResponsiveOrConstant.constant(30.0));
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderIconProperties_DeepCopy", () {
    test("should create independent copy with all properties", () {
      // Given
      const original = PageBuilderIconProperties(
        code: "e87c",
        size: PagebuilderResponsiveOrConstant.constant(24.0),
        color: Color(0xFF2196F3),
      );
      // When
      final copy = original.deepCopy();
      // Then
      expect(copy, isNot(same(original)));
      expect(copy.code, equals(original.code));
      expect(copy.size, equals(original.size));
      expect(copy.color, equals(original.color));
      expect(copy, equals(original));
    });
  });

  group("PagebuilderIconProperties_Props", () {
    test("check if value equality works", () {
      // Given
      const properties1 = PageBuilderIconProperties(
          code: "35A",
          size: PagebuilderResponsiveOrConstant.constant(24.0),
          color: Colors.black);
      const properties2 = PageBuilderIconProperties(
          code: "35A",
          size: PagebuilderResponsiveOrConstant.constant(24.0),
          color: Colors.black);
      // Then
      expect(properties1, properties2);
    });
  });
}
