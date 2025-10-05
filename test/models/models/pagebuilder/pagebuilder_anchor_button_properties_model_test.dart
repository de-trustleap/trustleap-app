import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_button_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_anchor_button_properties_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_anchor_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_responsive_or_constant_model.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderAnchorButtonPropertiesModel_CopyWith", () {
    test(
        "set sectionName with copyWith should set sectionName for resulting object",
        () {
      // Given
      final model = PagebuilderAnchorButtonPropertiesModel(
          sectionName: "1",
          buttonProperties: {
            "width": 200,
            "height": 200,
            "borderRadius": 12.0,
            "textProperties": {"text": "Test", "fontSize": 16.0}
          });
      final expectedResult = PagebuilderAnchorButtonPropertiesModel(
          sectionName: "2",
          buttonProperties: {
            "width": 200,
            "height": 200,
            "borderRadius": 12.0,
            "textProperties": {"text": "Test", "fontSize": 16.0}
          });
      // When
      final result = model.copyWith(sectionName: "2");
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderAnchorButtonPropertiesModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = PagebuilderAnchorButtonPropertiesModel(
          sectionName: "1",
          buttonProperties: {
            "width": 200,
            "height": 200,
            "borderRadius": 12.0,
            "textProperties": {"text": "Test", "fontSize": 16.0}
          });
      final expectedResult = {
        "sectionName": "1",
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
        "sectionName": "1",
        "buttonProperties": {
          "width": 200.0,
          "height": 200.0,
          "borderRadius": 12.0,
          "textProperties": {"text": "Test", "fontSize": 16.0}
        }
      };
      final expectedResult = PagebuilderAnchorButtonPropertiesModel(
          sectionName: "1",
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
          sectionName: "1",
          buttonProperties: {
            "width": 200.0,
            "height": 200.0,
            "borderRadius": 12.0,
            "textProperties": {"text": "Test", "fontSize": 16.0}
          });
      final expectedResult = PagebuilderAnchorButtonProperties(
          sectionName: "1",
          buttonProperties: PageBuilderButtonProperties(
              width: const PagebuilderResponsiveOrConstant.constant(200.0),
              height: const PagebuilderResponsiveOrConstant.constant(200.0),
              borderRadius: 12.0,
              backgroundPaint: null,
              textProperties: PageBuilderTextProperties(
                  text: "Test",
                  fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
                  fontFamily: null,
                  lineHeight: null,
                  letterSpacing: null,
                  textShadow: null,
                  color: null,
                  alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left),
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
          sectionName: "1",
          buttonProperties: PageBuilderButtonProperties(
              width: const PagebuilderResponsiveOrConstant.constant(200.0),
              height: const PagebuilderResponsiveOrConstant.constant(200.0),
              borderRadius: 12.0,
              backgroundPaint: null,
              textProperties: PageBuilderTextProperties(
                  text: "Test",
                  fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
                  fontFamily: null,
                  lineHeight: null,
                  letterSpacing: null,
                  textShadow: null,
                  color: null,
                  alignment: null,
                  isBold: null,
                  isItalic: null)));
      final expectedResult = PagebuilderAnchorButtonPropertiesModel(
          sectionName: "1",
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
          sectionName: "1",
          buttonProperties: {
            "width": 200.0,
            "height": 200.0,
            "borderRadius": 12.0,
            "textProperties": {"text": "Test", "fontSize": 16.0}
          });
      final model2 = PagebuilderAnchorButtonPropertiesModel(
          sectionName: "1",
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
