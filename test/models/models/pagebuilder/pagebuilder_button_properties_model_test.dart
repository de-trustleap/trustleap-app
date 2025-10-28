import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_button_properties_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:flutter/material.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_paint.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_responsive_or_constant_model.dart';

void main() {
  group("PagebuilderButtonPropertiesModel_CopyWith", () {
    test("set height with copyWith should set height for resulting object", () {
      // Given
      final model = PageBuilderButtonPropertiesModel(
          width: const PagebuilderResponsiveOrConstantModel.constant(200.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(60.0),
          borderRadius: 12.0,
          backgroundPaint: null,
          textProperties: {"text": "Test", "fontSize": 16.0});
      final expectedResult = PageBuilderButtonPropertiesModel(
          width: const PagebuilderResponsiveOrConstantModel.constant(200.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(80.0),
          borderRadius: 12.0,
          backgroundPaint: null,
          textProperties: {"text": "Test", "fontSize": 16.0});
      // When
      final result = model.copyWith(height: const PagebuilderResponsiveOrConstantModel.constant(80.0));
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderButtonPropertiesModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = PageBuilderButtonPropertiesModel(
          width: const PagebuilderResponsiveOrConstantModel.constant(200.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(60.0),
          borderRadius: 12.0,
          backgroundPaint: {"color": "FFFFFFFF"},
          textProperties: {"text": "Test", "fontSize": 16.0});
      final expectedResult = {
        "width": 200.0,
        "height": 60.0,
        "borderRadius": 12,
        "backgroundPaint": {"color": "FFFFFFFF"},
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
        "backgroundPaint": {"color": "FFFFFFFF"},
        "textProperties": {"text": "Test", "fontSize": 16.0}
      };
      final expectedResult = PageBuilderButtonPropertiesModel(
          width: const PagebuilderResponsiveOrConstantModel.constant(200.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(60.0),
          borderRadius: 12.0,
          backgroundPaint: {"color": "FFFFFFFF"},
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
          width: const PagebuilderResponsiveOrConstantModel.constant(200.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(60.0),
          borderRadius: 12.0,
          backgroundPaint: {"color": "FFFFFFFF"},
          textProperties: {"text": "Test", "fontSize": 16.0});
      final expectedResult = PageBuilderButtonProperties(
          width: const PagebuilderResponsiveOrConstant.constant(200.0),
          height: const PagebuilderResponsiveOrConstant.constant(60.0),
          borderRadius: 12,
          backgroundPaint: const PagebuilderPaint.color(Colors.white),
          textProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
              fontFamily: null,
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: null,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)));
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderButtonPropertiesModel_FromDomain", () {
    test(
        "check if conversion from PagebuilderButtonProperties to PagebuilderButtonPropertiesModel works",
        () {
      // Given
      final model = PageBuilderButtonProperties(
          width: const PagebuilderResponsiveOrConstant.constant(200.0),
          height: const PagebuilderResponsiveOrConstant.constant(60.0),
          borderRadius: 12,
          backgroundPaint: const PagebuilderPaint.color(Colors.white),
          textProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
              fontFamily: null,
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: null,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left)));
      final expectedResult = PageBuilderButtonPropertiesModel(
          width: const PagebuilderResponsiveOrConstantModel.constant(200.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(60.0),
          borderRadius: 12.0,
          backgroundPaint: {"color": "FFFFFFFF"},
          textProperties: {
            "text": "Test",
            "fontSize": 16.0,
            "alignment": "left"
          });
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
          width: const PagebuilderResponsiveOrConstantModel.constant(200.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(60.0),
          borderRadius: 12.0,
          backgroundPaint: {"color": "FFFFFFFF"},
          textProperties: {
            "text": "Test",
            "fontSize": 16.0,
            "alignment": "left"
          });
      final properties2 = PageBuilderButtonPropertiesModel(
          width: const PagebuilderResponsiveOrConstantModel.constant(200.0),
          height: const PagebuilderResponsiveOrConstantModel.constant(60.0),
          borderRadius: 12.0,
          backgroundPaint: {"color": "FFFFFFFF"},
          textProperties: {
            "text": "Test",
            "fontSize": 16.0,
            "alignment": "left"
          });
      // Then
      expect(properties1, properties2);
    });
  });
}
