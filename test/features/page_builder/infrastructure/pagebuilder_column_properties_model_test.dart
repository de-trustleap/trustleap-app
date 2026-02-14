import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_column_properties_model.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_column_properties.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderColumnPropertiesModel_CopyWith", () {
    test(
        "set mainAxisAlignment with copyWith should set mainAxisAlignment for resulting object",
        () {
      // Given
      final model = PagebuilderColumnPropertiesModel(
          mainAxisAlignment: "center", crossAxisAlignment: "center");
      final expectedResult = PagebuilderColumnPropertiesModel(
          mainAxisAlignment: "start", crossAxisAlignment: "center");
      // When
      final result = model.copyWith(mainAxisAlignment: "start");
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderColumnPropertiesModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = PagebuilderColumnPropertiesModel(
          mainAxisAlignment: "center", crossAxisAlignment: "center");
      final expectedResult = {
        "mainAxisAlignment": "center",
        "crossAxisAlignment": "center"
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderColumnPropertiesModel_FromMap", () {
    test("check if map is successfully converted to a model", () {
      // Given
      final map = {
        "mainAxisAlignment": "center",
        "crossAxisAlignment": "center"
      };
      final expectedResult = PagebuilderColumnPropertiesModel(
          mainAxisAlignment: "center", crossAxisAlignment: "center");
      // When
      final result = PagebuilderColumnPropertiesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderColumnPropertiesModel_ToDomain", () {
    test(
        "check if conversion from PagebuilderColumnPropertiesModel to PagebuilderColumnProperties works",
        () {
      // Given
      final model = PagebuilderColumnPropertiesModel(
          mainAxisAlignment: "center", crossAxisAlignment: "center");
      final expectedResult = PagebuilderColumnProperties(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center);
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderColumnPropertiesModel_FromDomain", () {
    test(
        "check if conversion from PagebuilderColumnProperties to PagebuilderColumnPropertiesModel works",
        () {
      // Given
      final model = PagebuilderColumnProperties(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center);
      final expectedResult = PagebuilderColumnPropertiesModel(
          mainAxisAlignment: "center", crossAxisAlignment: "center");
      // When
      final result = PagebuilderColumnPropertiesModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderColumnPropertiesModel_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PagebuilderColumnPropertiesModel(
          mainAxisAlignment: "center", crossAxisAlignment: "center");
      final properties2 = PagebuilderColumnPropertiesModel(
          mainAxisAlignment: "center", crossAxisAlignment: "center");
      // Then
      expect(properties1, properties2);
    });
  });
}
