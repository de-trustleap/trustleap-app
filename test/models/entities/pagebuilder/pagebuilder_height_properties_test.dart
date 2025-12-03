import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_height_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';

void main() {
  group("PageBuilderHeightProperties_CopyWith", () {
    test(
        "set height with copyWith should set height for resulting object",
        () {
      // Given
      const model = PageBuilderHeightProperties(
        height: PagebuilderResponsiveOrConstant.constant(40),
      );
      const expectedResult = PageBuilderHeightProperties(
        height: PagebuilderResponsiveOrConstant.constant(60),
      );
      // When
      final result = model.copyWith(
        height: const PagebuilderResponsiveOrConstant.constant(60),
      );
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderHeightProperties deepCopy", () {
    test("should create independent copy with all properties", () {
      // Given
      const original = PageBuilderHeightProperties(
        height: PagebuilderResponsiveOrConstant.constant(40),
      );
      // When
      final copy = original.deepCopy();
      // Then
      expect(copy, isNot(same(original)));
      expect(copy.height, equals(original.height));
      expect(copy, equals(original));
    });

    test("should handle null height", () {
      // Given
      const original = PageBuilderHeightProperties(
        height: null,
      );
      // When
      final copy = original.deepCopy();
      // Then
      expect(copy, isNot(same(original)));
      expect(copy.height, isNull);
      expect(copy, equals(original));
    });
  });

  group("PageBuilderHeightProperties_Props", () {
    test("check if value equality works", () {
      // Given
      const properties1 = PageBuilderHeightProperties(
        height: PagebuilderResponsiveOrConstant.constant(40),
      );
      const properties2 = PageBuilderHeightProperties(
        height: PagebuilderResponsiveOrConstant.constant(40),
      );
      // Then
      expect(properties1, properties2);
    });

    test("check if inequality works with different height", () {
      // Given
      const properties1 = PageBuilderHeightProperties(
        height: PagebuilderResponsiveOrConstant.constant(40),
      );
      const properties2 = PageBuilderHeightProperties(
        height: PagebuilderResponsiveOrConstant.constant(60),
      );
      // Then
      expect(properties1, isNot(equals(properties2)));
    });
  });
}
