import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_spacing.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:flutter/material.dart';

void main() {
  group("PageBuilderSpacing_CopyWith", () {
    test(
        "set top and bottom with copyWith should set top and bottom for resulting object",
        () {
      // Given
      final model =
          const PageBuilderSpacing(top: PagebuilderResponsiveOrConstant.constant(16.0), bottom: PagebuilderResponsiveOrConstant.constant(16.0), left: PagebuilderResponsiveOrConstant.constant(16.0), right: PagebuilderResponsiveOrConstant.constant(16.0));
      final expectedResult =
          const PageBuilderSpacing(top: PagebuilderResponsiveOrConstant.constant(20.0), bottom: PagebuilderResponsiveOrConstant.constant(20.0), left: PagebuilderResponsiveOrConstant.constant(16.0), right: PagebuilderResponsiveOrConstant.constant(16.0));
      // When
      final result = model.copyWith(top: const PagebuilderResponsiveOrConstant.constant(20.0), bottom: const PagebuilderResponsiveOrConstant.constant(20.0));
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderSpacing_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 =
          const PageBuilderSpacing(top: PagebuilderResponsiveOrConstant.constant(16.0), bottom: PagebuilderResponsiveOrConstant.constant(16.0), left: PagebuilderResponsiveOrConstant.constant(16.0), right: PagebuilderResponsiveOrConstant.constant(16.0));
      final properties2 =
          const PageBuilderSpacing(top: PagebuilderResponsiveOrConstant.constant(16.0), bottom: PagebuilderResponsiveOrConstant.constant(16.0), left: PagebuilderResponsiveOrConstant.constant(16.0), right: PagebuilderResponsiveOrConstant.constant(16.0));
      // Then
      expect(properties1, properties2);
    });
  });
}
