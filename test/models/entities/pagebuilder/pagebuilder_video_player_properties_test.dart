import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_video_player_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderVideoPlayerProperties_CopyWith", () {
    test("set height with copyWith should set height for resulting object", () {
      // Given
      final model = PagebuilderVideoPlayerProperties(
          link: "https://test.de",
          width: const PagebuilderResponsiveOrConstant.constant(500.0),
          height: const PagebuilderResponsiveOrConstant.constant(250.0));
      final expectedResult = PagebuilderVideoPlayerProperties(
          link: "https://test.de",
          width: const PagebuilderResponsiveOrConstant.constant(500.0),
          height: const PagebuilderResponsiveOrConstant.constant(300.0));
      // When
      final result = model.copyWith(
          height: const PagebuilderResponsiveOrConstant.constant(300.0));
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderVideoPlayerProperties_Props", () {
    test("check if value equality works", () {
      // Given
      final model = PagebuilderVideoPlayerProperties(
          link: "https://test.de",
          width: const PagebuilderResponsiveOrConstant.constant(500.0),
          height: const PagebuilderResponsiveOrConstant.constant(250.0));
      final model2 = PagebuilderVideoPlayerProperties(
          link: "https://test.de",
          width: const PagebuilderResponsiveOrConstant.constant(500.0),
          height: const PagebuilderResponsiveOrConstant.constant(250.0));
      // Then
      expect(model, model2);
    });
  });
}
