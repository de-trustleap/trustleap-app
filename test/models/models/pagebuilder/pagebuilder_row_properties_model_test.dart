import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_row_properties_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_row_properties.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderRowPropertiesModel_CopyWith", () {
    test(
        "set crossAxisAlignment with copyWith should set crossAxisAlignment for resulting object",
        () {
      // Given
      final model = PagebuilderRowPropertiesModel(
          equalHeights: false,
          mainAxisAlignment: "center",
          crossAxisAlignment: "end");
      final expectedResult = PagebuilderRowPropertiesModel(
          equalHeights: false,
          mainAxisAlignment: "center",
          crossAxisAlignment: "start");
      // When
      final result = model.copyWith(crossAxisAlignment: "start");
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderRowPropertiesModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = PagebuilderRowPropertiesModel(
          equalHeights: false,
          mainAxisAlignment: "center",
          crossAxisAlignment: "end");
      final expectedResult = {
        "equalHeights": false,
        "mainAxisAlignment": "center",
        "crossAxisAlignment": "end"
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderRowPropertiesModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "equalHeights": false,
        "mainAxisAlignment": "center",
        "crossAxisAlignment": "end"
      };
      final expectedResult = PagebuilderRowPropertiesModel(
          equalHeights: false,
          mainAxisAlignment: "center",
          crossAxisAlignment: "end");
      // When
      final result = PagebuilderRowPropertiesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderRowPropertiesModel_ToDomain", () {
    test(
        "check if conversion from PagebuilderRowPropertiesModel to PagebuilderRowProperties works",
        () {
      // Given
      final model = PagebuilderRowPropertiesModel(
          equalHeights: false,
          mainAxisAlignment: "center",
          crossAxisAlignment: "end");
      final expectedResult = PagebuilderRowProperties(
          equalHeights: false,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end);
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderRowPropertiesModel_FromDomain", () {
    test(
        "check if conversion from PagebuilderRowProperties to PagebuilderRowPropertiesModel works",
        () {
      // Given
      final model = PagebuilderRowProperties(
          equalHeights: false,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end);
      final expectedResult = PagebuilderRowPropertiesModel(
          equalHeights: false,
          mainAxisAlignment: "center",
          crossAxisAlignment: "end");
      // When
      final result = PagebuilderRowPropertiesModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderRowPropertiesModel_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PagebuilderRowPropertiesModel(
          equalHeights: false,
          mainAxisAlignment: "center",
          crossAxisAlignment: "end");
      final properties2 = PagebuilderRowPropertiesModel(
          equalHeights: false,
          mainAxisAlignment: "center",
          crossAxisAlignment: "end");
      // Then
      expect(properties1, properties2);
    });
  });
}
