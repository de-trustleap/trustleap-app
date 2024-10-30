import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_button_properties_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderButtonPropertiesModel_CopyWith", () {
    test("set height with copyWith should set height for resulting object", () {
      // Given
      final model = PageBuilderButtonPropertiesModel(
          width: 200.0,
          height: 60.0,
          borderRadius: 12.0,
          backgroundColor: null,
          textProperties: {"text": "Test", "fontSize": 16.0});
      final expectedResult = PageBuilderButtonPropertiesModel(
          width: 200.0,
          height: 80.0,
          borderRadius: 12.0,
          backgroundColor: null,
          textProperties: {"text": "Test", "fontSize": 16.0});
      // When
      final result = model.copyWith(height: 80.0);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderButtonPropertiesModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = PageBuilderButtonPropertiesModel(
          width: 200.0,
          height: 60.0,
          borderRadius: 12.0,
          backgroundColor: "ffffffff",
          textProperties: {"text": "Test", "fontSize": 16.0});
      final expectedResult = {
        "width": 200,
        "height": 60,
        "borderRadius": 12,
        "backgroundColor": "ffffffff",
        "textProperties": {"text": "Test", "fontSize": 16.0}
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderButtonPropertiesModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "width": 200.0,
        "height": 60.0,
        "borderRadius": 12.0,
        "backgroundColor": "ffffffff",
        "textProperties": {"text": "Test", "fontSize": 16.0}
      };
      final expectedResult = PageBuilderButtonPropertiesModel(
          width: 200.0,
          height: 60.0,
          borderRadius: 12.0,
          backgroundColor: "ffffffff",
          textProperties: {"text": "Test", "fontSize": 16.0});
      // When
      final result = PageBuilderButtonPropertiesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderButtonPropertiesModel_ToDomain", () {
    test(
        "check if conversion from PagebuilderButtonPropertiesModel to PagebuilderButtonProperties works",
        () {
      // Given
      final model = PageBuilderButtonPropertiesModel(
          width: 200.0,
          height: 60.0,
          borderRadius: 12.0,
          backgroundColor: "ffffffff",
          textProperties: {"text": "Test", "fontSize": 16.0});
      final expectedResult = PageBuilderButtonProperties(
          width: 200,
          height: 60,
          borderRadius: 12,
          backgroundColor: Colors.white,
          textProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: 16,
              fontFamily: null,
              lineHeight: null,
              color: null,
              alignment: TextAlign.left,
              isBold: null,
              isItalic: null));
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderButtonPropertiesModel_FromDomain", () {
    test("check if conversion from PagebuilderButtonProperties to PagebuilderButtonPropertiesModel works", () {
      // Given
      final model = PageBuilderButtonProperties(
          width: 200,
          height: 60,
          borderRadius: 12,
          backgroundColor: Colors.white,
          textProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: 16,
              fontFamily: null,
              lineHeight: null,
              color: null,
              alignment: TextAlign.left,
              isBold: null,
              isItalic: null));
      final expectedResult = PageBuilderButtonPropertiesModel(
          width: 200.0,
          height: 60.0,
          borderRadius: 12.0,
          backgroundColor: "ffffffff",
          textProperties: {"text": "Test", "fontSize": 16.0, "alignment": "left"});
      // When
      final result = PageBuilderButtonPropertiesModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderButtonPropertiesModel_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PageBuilderButtonPropertiesModel(
          width: 200.0,
          height: 60.0,
          borderRadius: 12.0,
          backgroundColor: "ffffffff",
          textProperties: {"text": "Test", "fontSize": 16.0, "alignment": "left"});
      final properties2 = PageBuilderButtonPropertiesModel(
          width: 200.0,
          height: 60.0,
          borderRadius: 12.0,
          backgroundColor: "ffffffff",
          textProperties: {"text": "Test", "fontSize": 16.0, "alignment": "left"});
      // Then
      expect(properties1, properties2);
    });
  });
}
