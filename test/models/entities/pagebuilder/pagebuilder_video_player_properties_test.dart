import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_video_player_properties.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderVideoPlayerProperties_CopyWith", () {
    test("set height with copyWith should set height for resulting object", () {
      // Given
      final model = PagebuilderVideoPlayerProperties(
          link: "https://test.de", width: 500, height: 250);
      final expectedResult = PagebuilderVideoPlayerProperties(
          link: "https://test.de", width: 500, height: 300);
      // When
      final result = model.copyWith(height: 300);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderVideoPlayerProperties_Props", () {
    test("check if value equality works", () {
      // Given
      final model = PagebuilderVideoPlayerProperties(
          link: "https://test.de", width: 500, height: 250);
      final model2 = PagebuilderVideoPlayerProperties(
          link: "https://test.de", width: 500, height: 250);
      // Then
      expect(model, model2);
    });
  });
}
