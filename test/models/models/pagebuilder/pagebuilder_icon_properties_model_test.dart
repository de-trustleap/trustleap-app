import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_icon_properties_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_icon_properties.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderIconPropertiesModel_CopyWith", () {
    test("set code with copyWith should set code for resulting object", () {
      // Given
      final model = PageBuilderIconPropertiesModel(
          code: "25A", size: 24.0, color: "FF000000");
      final expectedResult = PageBuilderIconPropertiesModel(
          code: "25B", size: 24.0, color: "FF000000");
      // When
      final result = model.copyWith(code: "25B");
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderIconPropertiesModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = PageBuilderIconPropertiesModel(
          code: "25A", size: 24.0, color: "FF000000");
      final expectedResult = {"code": "25A", "size": 24.0, "color": "FF000000"};
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderIconPropertiesModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {"code": "25A", "size": 24.0, "color": "FF000000"};
      final expectedResult = PageBuilderIconPropertiesModel(
          code: "25A", size: 24.0, color: "FF000000");
      // When
      final result = PageBuilderIconPropertiesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderIconPropertiesModel_ToDomain", () {
    test(
        "check if conversion from PagebuilderIconPropertiesModel to PagebuilderIconProperties works",
        () {
      // Given
      final model = PageBuilderIconPropertiesModel(
          code: "25A", size: 24.0, color: "FF000000");
      final expectedResult = PageBuilderIconProperties(
          code: "25A", size: 24.0, color: Colors.black);
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderIconPropertiesModel_FromDomain", () {
    test(
        "check if conversion from PagebuilderIconProperties to PagebuilderIconPropertiesModel works",
        () {
      // Given
      final model = PageBuilderIconProperties(
          code: "25A", size: 24.0, color: Colors.black);
      final expectedResult = PageBuilderIconPropertiesModel(
          code: "25A", size: 24.0, color: "FF000000");
      // When
      final result = PageBuilderIconPropertiesModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderIconPropertiesModel_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PageBuilderIconPropertiesModel(
          code: "25A", size: 24.0, color: "FF000000");
      final properties2 = PageBuilderIconPropertiesModel(
          code: "25A", size: 24.0, color: "FF000000");
      // Then
      expect(properties1, properties2);
    });
  });
}
