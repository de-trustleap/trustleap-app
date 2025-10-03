import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_text_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_responsive_or_constant_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderTextPropertiesModel_CopyWith", () {
    test(
        "set lineHeight with copyWith should set lineHeight for resulting object",
        () {
      // Given
      final model = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"),
          isBold: null,
          isItalic: null);
      final expectedResult = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.2),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"),
          isBold: null,
          isItalic: null);
      // When
      final result = model.copyWith(lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.2));
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderTextPropertiesModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"),
          isBold: null,
          isItalic: null);
      final expectedResult = {
        "text": "Test",
        "fontSize": 20.0,
        "fontFamily": "Poppins",
        "lineHeight": 1.5,
        "color": "FF000000",
        "alignment": "center"
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderTextPropertiesModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "text": "Test",
        "fontSize": 20.0,
        "fontFamily": "Poppins",
        "lineHeight": 1.5,
        "color": "FF000000",
        "alignment": "center"
      };
      final expectedResult = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"),
          isBold: null,
          isItalic: null);
      // When
      final result = PageBuilderTextPropertiesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderTextPropertiesModel_ToDomain", () {
    test(
        "check if conversion from PagebuilderTextPropertiesModel to PagebuilderTextProperties works",
        () {
      // Given
      final model = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"),
          isBold: null,
          isItalic: null);
      final expectedResult = PageBuilderTextProperties(
          text: "Test",
          fontSize: const PagebuilderResponsiveOrConstant.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: const PagebuilderResponsiveOrConstant.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: Colors.black,
          alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.center),
          isBold: null,
          isItalic: null);
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderTextPropertiesModel_FromDomain", () {
    test(
        "check if conversion from PagebuilderTextProperties to PagebuilderTextPropertiesModel works",
        () {
      // Given
      final model = PageBuilderTextProperties(
          text: "Test",
          fontSize: const PagebuilderResponsiveOrConstant.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: const PagebuilderResponsiveOrConstant.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: Colors.black,
          alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.center),
          isBold: null,
          isItalic: null);
      final expectedResult = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"),
          isBold: null,
          isItalic: null);
      // When
      final result = PageBuilderTextPropertiesModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderTextPropertiesModel_GetTextAlignFromString", () {
    test("check if returns correct text align from string", () {
      // Given
      final model = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"),
          isBold: null,
          isItalic: null);
      final alignment = "right";
      final expectedResult = TextAlign.right;
      // When
      final result = model.getTextAlignFromString(alignment);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderTextPropertiesModel_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"),
          isBold: null,
          isItalic: null);
      final properties2 = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"),
          isBold: null,
          isItalic: null);
      // Then
      expect(properties1, properties2);
    });
  });

  group("PagebuilderTextPropertiesModel_Responsive", () {
    test("should handle responsive fontSize in toMap", () {
      // Given
      final model = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.responsive({
            "mobile": 14.0,
            "tablet": 16.0,
            "desktop": 20.0
          }),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"),
          isBold: null,
          isItalic: null);
      final expectedResult = {
        "text": "Test",
        "fontSize": {
          "mobile": 14.0,
          "tablet": 16.0,
          "desktop": 20.0
        },
        "fontFamily": "Poppins",
        "lineHeight": 1.5,
        "color": "FF000000",
        "alignment": "center"
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });

    test("should handle responsive fontSize in fromMap", () {
      // Given
      final map = {
        "text": "Test",
        "fontSize": {
          "mobile": 14.0,
          "tablet": 16.0,
          "desktop": 20.0
        },
        "fontFamily": "Poppins",
        "lineHeight": 1.5,
        "color": "FF000000",
        "alignment": "center"
      };
      final expectedResult = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.responsive({
            "mobile": 14.0,
            "tablet": 16.0,
            "desktop": 20.0
          }),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"),
          isBold: null,
          isItalic: null);
      // When
      final result = PageBuilderTextPropertiesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });

    test("should handle responsive alignment in toDomain", () {
      // Given
      final model = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.responsive({
            "mobile": "left",
            "tablet": "center",
            "desktop": "right"
          }),
          isBold: null,
          isItalic: null);
      final expectedResult = PageBuilderTextProperties(
          text: "Test",
          fontSize: const PagebuilderResponsiveOrConstant.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: const PagebuilderResponsiveOrConstant.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: Colors.black,
          alignment: const PagebuilderResponsiveOrConstant.responsive({
            "mobile": TextAlign.left,
            "tablet": TextAlign.center,
            "desktop": TextAlign.right
          }),
          isBold: null,
          isItalic: null);
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });

    test("should handle responsive alignment in fromDomain", () {
      // Given
      final model = PageBuilderTextProperties(
          text: "Test",
          fontSize: const PagebuilderResponsiveOrConstant.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: const PagebuilderResponsiveOrConstant.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: Colors.black,
          alignment: const PagebuilderResponsiveOrConstant.responsive({
            "mobile": TextAlign.left,
            "tablet": TextAlign.center,
            "desktop": TextAlign.right
          }),
          isBold: null,
          isItalic: null);
      final expectedResult = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.constant(20.0),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.constant(1.5),
          letterSpacing: null,
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.responsive({
            "mobile": "left",
            "tablet": "center",
            "desktop": "right"
          }),
          isBold: null,
          isItalic: null);
      // When
      final result = PageBuilderTextPropertiesModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });

    test("should handle mixed responsive and constant values", () {
      // Given
      final model = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: PagebuilderResponsiveOrConstantModel.responsive({
            "mobile": 12.0,
            "tablet": 14.0,
            "desktop": 16.0
          }),
          fontFamily: "Poppins",
          lineHeight: PagebuilderResponsiveOrConstantModel.responsive({
            "mobile": 1.2,
            "tablet": 1.4,
            "desktop": 1.6
          }),
          letterSpacing: PagebuilderResponsiveOrConstantModel.constant(0.5),
          textShadow: null,
          color: "FF000000",
          alignment: PagebuilderResponsiveOrConstantModel.constant("center"),
          isBold: true,
          isItalic: false);

      // When - convert to map and back
      final map = model.toMap();
      final result = PageBuilderTextPropertiesModel.fromMap(map);

      // Then
      expect(result, model);
    });
  });
}
