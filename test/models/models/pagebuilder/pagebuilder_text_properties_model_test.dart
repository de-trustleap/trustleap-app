import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_text_properties_model.dart';
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
          fontSize: 20.0,
          fontFamily: "Poppins",
          lineHeight: 1.5,
          letterSpacing: null,
          textShadow: null,
          color: "ff000000",
          alignment: "center",
          isBold: null,
          isItalic: null);
      final expectedResult = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: 20.0,
          fontFamily: "Poppins",
          lineHeight: 1.2,
          letterSpacing: null,
          textShadow: null,
          color: "ff000000",
          alignment: "center",
          isBold: null,
          isItalic: null);
      // When
      final result = model.copyWith(lineHeight: 1.2);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderTextPropertiesModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: 20.0,
          fontFamily: "Poppins",
          lineHeight: 1.5,
          letterSpacing: null,
          textShadow: null,
          color: "ff000000",
          alignment: "center",
          isBold: null,
          isItalic: null);
      final expectedResult = {
        "text": "Test",
        "fontSize": 20.0,
        "fontFamily": "Poppins",
        "lineHeight": 1.5,
        "color": "ff000000",
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
        "color": "ff000000",
        "alignment": "center"
      };
      final expectedResult = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: 20.0,
          fontFamily: "Poppins",
          lineHeight: 1.5,
          letterSpacing: null,
          textShadow: null,
          color: "ff000000",
          alignment: "center",
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
          fontSize: 20.0,
          fontFamily: "Poppins",
          lineHeight: 1.5,
          letterSpacing: null,
          textShadow: null,
          color: "ff000000",
          alignment: "center",
          isBold: null,
          isItalic: null);
      final expectedResult = PageBuilderTextProperties(
          text: "Test",
          fontSize: 20.0,
          fontFamily: "Poppins",
          lineHeight: 1.5,
          letterSpacing: null,
          textShadow: null,
          color: Colors.black,
          alignment: TextAlign.center,
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
          fontSize: 20.0,
          fontFamily: "Poppins",
          lineHeight: 1.5,
          letterSpacing: null,
          textShadow: null,
          color: Colors.black,
          alignment: TextAlign.center,
          isBold: null,
          isItalic: null);
      final expectedResult = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: 20.0,
          fontFamily: "Poppins",
          lineHeight: 1.5,
          letterSpacing: null,
          textShadow: null,
          color: "ff000000",
          alignment: "center",
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
          fontSize: 20.0,
          fontFamily: "Poppins",
          lineHeight: 1.5,
          letterSpacing: null,
          textShadow: null,
          color: "ff000000",
          alignment: "center",
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
          fontSize: 20.0,
          fontFamily: "Poppins",
          lineHeight: 1.5,
          letterSpacing: null,
          textShadow: null,
          color: "ff000000",
          alignment: "center",
          isBold: null,
          isItalic: null);
      final properties2 = PageBuilderTextPropertiesModel(
          text: "Test",
          fontSize: 20.0,
          fontFamily: "Poppins",
          lineHeight: 1.5,
          letterSpacing: null,
          textShadow: null,
          color: "ff000000",
          alignment: "center",
          isBold: null,
          isItalic: null);
      // Then
      expect(properties1, properties2);
    });
  });
}
