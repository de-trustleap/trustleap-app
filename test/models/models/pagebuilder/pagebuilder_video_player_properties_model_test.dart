import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_video_player_properties_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_video_player_properties.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderVideoPlayerPropertiesModel_CopyWith", () {
    test("set link with copyWith should set link for resulting object", () {
      // Given
      final model = PagebuilderVideoPlayerPropertiesModel(
          width: 500, height: 250, link: "https://test.de");
      final expectedResult = PagebuilderVideoPlayerPropertiesModel(
          width: 500, height: 250, link: "https://test-neu.de");
      // When
      final result = model.copyWith(link: "https://test-neu.de");
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderVideoPlayerPropertiesModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = PagebuilderVideoPlayerPropertiesModel(
          width: 500, height: 250, link: "https://test.de");
      final expectedResult = {
        "width": 500,
        "height": 250,
        "link": "https://test.de"
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderVideoPlayerPropertiesModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {"width": 500.0, "height": 250.0, "link": "https://test.de"};
      final expectedResult = PagebuilderVideoPlayerPropertiesModel(
          width: 500, height: 250, link: "https://test.de");
      // When
      final result = PagebuilderVideoPlayerPropertiesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderVideoPlayerPropertiesModel_ToDomain", () {
    test(
        "check if conversion from PagebuilderVideoPlayerPropertiesModel to PagebuilderVideoPlayerProperties works",
        () {
      // Given
      final model = PagebuilderVideoPlayerPropertiesModel(
          width: 500, height: 250, link: "https://test.de");
      final expectedResult = PagebuilderVideoPlayerProperties(
          width: 500, height: 250, link: "https://test.de");
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderVideoPlayerPropertiesModel_FromDomain", () {
    test(
        "check if conversion from PagebuilderTextProperties to PagebuilderTextPropertiesModel works",
        () {
      // Given
      final model = PagebuilderVideoPlayerProperties(
          width: 500, height: 250, link: "https://test.de");
      final expectedResult = PagebuilderVideoPlayerPropertiesModel(
          width: 500, height: 250, link: "https://test.de");
      // When
      final result = PagebuilderVideoPlayerPropertiesModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderVideoPlayerPropertiesModel_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PagebuilderVideoPlayerPropertiesModel(
          width: 500, height: 250, link: "https://test.de");
      final properties2 = PagebuilderVideoPlayerPropertiesModel(
          width: 500, height: 250, link: "https://test.de");
      // Then
      expect(properties1, properties2);
    });
  });
}
