import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_container_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_border.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_shadow.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderContainerProperties_CopyWith", () {
    test(
        "set border with copyWith should set border for resulting object",
        () {
      // Given
      final model = PageBuilderContainerProperties(
          border: const PagebuilderBorder(radius: 12.0, width: null, color: null),
          shadow: PageBuilderShadow(
              color: Colors.black,
              spreadRadius: 1.0,
              blurRadius: 1.0,
              offset: Offset(1, 2)),
          width: null,
          height: null);
      final expectedResult = PageBuilderContainerProperties(
          border: const PagebuilderBorder(radius: 8.0, width: null, color: null),
          shadow: PageBuilderShadow(
              color: Colors.black,
              spreadRadius: 1.0,
              blurRadius: 1.0,
              offset: Offset(1, 2)),
          width: null,
          height: null);
      // When
      final result = model.copyWith(border: const PagebuilderBorder(radius: 8.0, width: null, color: null));
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderContainerProperties_DeepCopy", () {
    test("should create independent copy with all properties", () {
      // Given
      const shadow = PageBuilderShadow(
        color: Color(0xFF000000),
        spreadRadius: 2.0,
        blurRadius: 8.0,
        offset: Offset(4.0, 4.0),
      );

      const original = PageBuilderContainerProperties(
        border: const PagebuilderBorder(radius: 12.0, width: null, color: null),
        shadow: shadow,
        width: null,
        height: null,
      );
      // When
      final copy = original.deepCopy();
      // Then
      expect(copy, isNot(same(original)));
      expect(copy.border?.radius, equals(original.border?.radius));
      expect(copy.shadow, equals(original.shadow));
      expect(copy.shadow, isNot(same(original.shadow)));
      expect(copy, equals(original));
    });
  });

  group("PagebuilderContainerProperties_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PageBuilderContainerProperties(
          border: const PagebuilderBorder(radius: 12.0, width: null, color: null),
          shadow: PageBuilderShadow(
              color: Colors.black,
              spreadRadius: 1.0,
              blurRadius: 1.0,
              offset: Offset(1, 2)),
          width: null,
          height: null);
      final properties2 = PageBuilderContainerProperties(
          border: const PagebuilderBorder(radius: 12.0, width: null, color: null),
          shadow: PageBuilderShadow(
              color: Colors.black,
              spreadRadius: 1.0,
              blurRadius: 1.0,
              offset: Offset(1, 2)),
          width: null,
          height: null);
      // Then
      expect(properties1, properties2);
    });
  });
}
