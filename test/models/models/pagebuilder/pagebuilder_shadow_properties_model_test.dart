import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_shadow_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_shadow.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderShadowModel_CopyWith", () {
    test(
        "set blurRadius with copyWith should set blurRadius for resulting object",
        () {
      // Given
      final model = PageBuilderShadowModel(
          color: "ff000000",
          spreadRadius: 2.0,
          blurRadius: 2.0,
          offset: {"y": 5.0, "x": 2.0});
      final expectedResult = PageBuilderShadowModel(
          color: "ff000000",
          spreadRadius: 2.0,
          blurRadius: 5.0,
          offset: {"y": 5.0, "x": 2.0});
      // When
      final result = model.copyWith(blurRadius: 5.0);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderShadowModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = PageBuilderShadowModel(
          color: "ff000000",
          spreadRadius: 2.0,
          blurRadius: 2.0,
          offset: {"y": 5.0, "x": 2.0});
      final expectedResult = {
        "color": "ff000000",
        "spreadRadius": 2.0,
        "blurRadius": 2.0,
        "offset": {"y": 5.0, "x": 2.0}
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderShadowModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "color": "ff000000",
        "spreadRadius": 2.0,
        "blurRadius": 2.0,
        "offset": {"y": 5.0, "x": 2.0}
      };
      final expectedResult = PageBuilderShadowModel(
          color: "ff000000",
          spreadRadius: 2.0,
          blurRadius: 2.0,
          offset: {"y": 5.0, "x": 2.0});
      // When
      final result = PageBuilderShadowModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderShadowModel_ToDomain", () {
    test(
        "check if conversion from PagebuilderShadowModel to PagebuilderShadow works",
        () {
      // Given
      final model = PageBuilderShadowModel(
          color: "ff000000",
          spreadRadius: 2.0,
          blurRadius: 2.0,
          offset: {"y": 5.0, "x": 2.0});
      final expectedResult = PageBuilderShadow(
          color: Colors.black,
          spreadRadius: 2.0,
          blurRadius: 2.0,
          offset: Offset(2.0, 5.0));
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderShadowModel_FromDomain", () {
    test(
        "check if conversion from PagebuilderShadow to PagebuilderShadowModel works",
        () {
      // Given
      final model = PageBuilderShadow(
          color: Colors.black,
          spreadRadius: 2.0,
          blurRadius: 2.0,
          offset: Offset(2.0, 5.0));
      final expectedResult = PageBuilderShadowModel(
          color: "ff000000",
          spreadRadius: 2.0,
          blurRadius: 2.0,
          offset: {"y": 5.0, "x": 2.0});
      // When
      final result = PageBuilderShadowModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderShadowModel_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PageBuilderShadowModel(
          color: "ff000000",
          spreadRadius: 2.0,
          blurRadius: 2.0,
          offset: {"y": 5.0, "x": 2.0});
      final properties2 = PageBuilderShadowModel(
          color: "ff000000",
          spreadRadius: 2.0,
          blurRadius: 2.0,
          offset: {"y": 5.0, "x": 2.0});
      // Then
      expect(properties1, properties2);
    });
  });
}
