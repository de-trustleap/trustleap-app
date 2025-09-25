import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_button_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_anchor_button_properties_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_anchor_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderAnchorButtonPropertiesModel_CopyWith", () {
    test(
        "set sectionID with copyWith should set sectionID for resulting object",
        () {
      // Given
      final model = PagebuilderAnchorButtonPropertiesModel(
          sectionID: "1",
          buttonProperties: {
            "width": 200,
            "height": 200,
            "borderRadius": 12.0,
            "textProperties": {"text": "Test", "fontSize": 16.0}
          });
      final expectedResult = PagebuilderAnchorButtonPropertiesModel(
          sectionID: "2",
          buttonProperties: {
            "width": 200,
            "height": 200,
            "borderRadius": 12.0,
            "textProperties": {"text": "Test", "fontSize": 16.0}
          });
      // When
      final result = model.copyWith(sectionID: "2");
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderAnchorButtonPropertiesModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = PagebuilderAnchorButtonPropertiesModel(
          sectionID: "1",
          buttonProperties: {
            "width": 200,
            "height": 200,
            "borderRadius": 12.0,
            "textProperties": {"text": "Test", "fontSize": 16.0}
          });
      final expectedResult = {
        "sectionID": "1",
        "buttonProperties": {
          "width": 200,
          "height": 200,
          "borderRadius": 12.0,
          "textProperties": {"text": "Test", "fontSize": 16.0}
        }
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderAnchorButtonPropertiesModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "sectionID": "1",
        "buttonProperties": {
          "width": 200.0,
          "height": 200.0,
          "borderRadius": 12.0,
          "textProperties": {"text": "Test", "fontSize": 16.0}
        }
      };
      final expectedResult = PagebuilderAnchorButtonPropertiesModel(
          sectionID: "1",
          buttonProperties: {
            "width": 200.0,
            "height": 200.0,
            "borderRadius": 12.0,
            "textProperties": {"text": "Test", "fontSize": 16.0}
          });
      // When
      final result = PagebuilderAnchorButtonPropertiesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderAnchorButtonPropertiesModel_ToDomain", () {
    test(
        "check if conversion from PagebuilderAnchorButtonPropertiesModel to PagebuilderAnchorButtonProperties works",
        () {
      // Given
      final model = PagebuilderAnchorButtonPropertiesModel(
          sectionID: "1",
          buttonProperties: {
            "width": 200.0,
            "height": 200.0,
            "borderRadius": 12.0,
            "textProperties": {"text": "Test", "fontSize": 16.0}
          });
      final expectedResult = PagebuilderAnchorButtonProperties(
          sectionID: "1",
          buttonProperties: PageBuilderButtonProperties(
              width: 200.0,
              height: 200.0,
              borderRadius: 12.0,
              backgroundPaint: null,
              textProperties: PageBuilderTextProperties(
                  text: "Test",
                  fontSize: 16.0,
                  fontFamily: null,
                  lineHeight: null,
                  letterSpacing: null,
                  textShadow: null,
                  color: null,
                  alignment: TextAlign.left,
                  isBold: null,
                  isItalic: null)));
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderAnchorButtonPropertiesModel_FromDomain", () {
    test(
        "check if conversion from PagebuilderAnchorButtonProperties to PagebuilderAnchorButtonPropertiesModel works",
        () {
      // Given
      final model = PagebuilderAnchorButtonProperties(
          sectionID: "1",
          buttonProperties: PageBuilderButtonProperties(
              width: 200.0,
              height: 200.0,
              borderRadius: 12.0,
              backgroundPaint: null,
              textProperties: PageBuilderTextProperties(
                  text: "Test",
                  fontSize: 16.0,
                  fontFamily: null,
                  lineHeight: null,
                  letterSpacing: null,
                  textShadow: null,
                  color: null,
                  alignment: null,
                  isBold: null,
                  isItalic: null)));
      final expectedResult = PagebuilderAnchorButtonPropertiesModel(
          sectionID: "1",
          buttonProperties: {
            "width": 200.0,
            "height": 200.0,
            "borderRadius": 12.0,
            "textProperties": {"text": "Test", "fontSize": 16.0}
          });
      // When
      final result = PagebuilderAnchorButtonPropertiesModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderAnchorButtonPropertiesModel_Props", () {
    test("check if value equality works", () {
      // Given
      final model = PagebuilderAnchorButtonPropertiesModel(
          sectionID: "1",
          buttonProperties: {
            "width": 200.0,
            "height": 200.0,
            "borderRadius": 12.0,
            "textProperties": {"text": "Test", "fontSize": 16.0}
          });
      final model2 = PagebuilderAnchorButtonPropertiesModel(
          sectionID: "1",
          buttonProperties: {
            "width": 200.0,
            "height": 200.0,
            "borderRadius": 12.0,
            "textProperties": {"text": "Test", "fontSize": 16.0}
          });
      // Then
      expect(model, model2);
    });
  });
}
