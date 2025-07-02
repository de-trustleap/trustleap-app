import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_container_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_shadow.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderContainerProperties_CopyWith", () {
    test(
        "set borderRadius with copyWith should set width and borderRadius for resulting object",
        () {
      // Given
      final model = PageBuilderContainerProperties(
          borderRadius: 12.0,
          shadow: PageBuilderShadow(
              color: Colors.black,
              spreadRadius: 1.0,
              blurRadius: 1.0,
              offset: Offset(1, 2)));
      final expectedResult = PageBuilderContainerProperties(
          borderRadius: 8.0,
          shadow: PageBuilderShadow(
              color: Colors.black,
              spreadRadius: 1.0,
              blurRadius: 1.0,
              offset: Offset(1, 2)));
      // When
      final result = model.copyWith(borderRadius: 8.0);
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
        borderRadius: 12.0,
        shadow: shadow,
      );
      // When
      final copy = original.deepCopy();
      // Then
      expect(copy, isNot(same(original)));
      expect(copy.borderRadius, equals(original.borderRadius));
      expect(copy.shadow, equals(original.shadow));
      expect(copy.shadow, isNot(same(original.shadow)));
      expect(copy, equals(original));
    });
  });

  group("PagebuilderContainerProperties_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PageBuilderContainerProperties(
          borderRadius: 12.0,
          shadow: PageBuilderShadow(
              color: Colors.black,
              spreadRadius: 1.0,
              blurRadius: 1.0,
              offset: Offset(1, 2)));
      final properties2 = PageBuilderContainerProperties(
          borderRadius: 12.0,
          shadow: PageBuilderShadow(
              color: Colors.black,
              spreadRadius: 1.0,
              blurRadius: 1.0,
              offset: Offset(1, 2)));
      // Then
      expect(properties1, properties2);
    });
  });
}
