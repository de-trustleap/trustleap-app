import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_textfield_properties_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_textfield_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderTextfieldPropertiesModel_CopyWith", () {
    test(
        "set backgroundColor with copyWith should set backgroundColor for resulting object",
        () {
      // Given
      final model = PageBuilderTextFieldPropertiesModel(
          width: 200.0,
          minLines: 1,
          isRequired: false,
          backgroundColor: "ff000000",
          borderColor: null,
          placeHolderTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          textProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          });
      final expectedResult = PageBuilderTextFieldPropertiesModel(
          width: 200.0,
          minLines: 1,
          isRequired: false,
          backgroundColor: "fff00000",
          borderColor: null,
          placeHolderTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          textProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          });
      // When
      final result = model.copyWith(backgroundColor: "fff00000");
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderTextfieldPropertiesModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = PageBuilderTextFieldPropertiesModel(
          width: 200.0,
          minLines: 1,
          isRequired: false,
          backgroundColor: "ff000000",
          borderColor: null,
          placeHolderTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          textProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          });
      final expectedResult = {
        "width": 200.0,
        "minLines": 1,
        "isRequired": false,
        "backgroundColor": "ff000000",
        "placeHolderTextProperties": {
          "text": "Test",
          "fontSize": 14.0,
          "fontFamily": "Poppins"
        },
        "textProperties": {
          "text": "Test",
          "fontSize": 14.0,
          "fontFamily": "Poppins"
        }
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderTextfieldPropertiesModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "width": 200.0,
        "minLines": 1,
        "isRequired": false,
        "backgroundColor": "ff000000",
        "placeHolderTextProperties": {
          "text": "Test",
          "fontSize": 14.0,
          "fontFamily": "Poppins"
        },
        "textProperties": {
          "text": "Test",
          "fontSize": 14.0,
          "fontFamily": "Poppins"
        }
      };
      final expectedResult = PageBuilderTextFieldPropertiesModel(
          width: 200.0,
          minLines: 1,
          isRequired: false,
          backgroundColor: "ff000000",
          borderColor: null,
          placeHolderTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          textProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          });
      // When
      final result = PageBuilderTextFieldPropertiesModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderTextfieldPropertiesModel_ToDomain", () {
    test(
        "check if conversion from PagebuilderTextfieldPropertiesModel to PagebuilderTextfieldProperties works",
        () {
      // Given
      final model = PageBuilderTextFieldPropertiesModel(
          width: 200.0,
          minLines: 1,
          isRequired: false,
          backgroundColor: "ff000000",
          borderColor: null,
          placeHolderTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          },
          textProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins"
          });
      final expectedResult = PageBuilderTextFieldProperties(
          width: 200.0,
          minLines: 1,
          isRequired: false,
          backgroundColor: Colors.black,
          borderColor: null,
          placeHolderTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: 14.0,
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: null,
              alignment: TextAlign.left,
              isBold: null,
              isItalic: null),
          textProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: 14.0,
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
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

  group("PagebuilderTextfieldPropertiesModel_FromDomain", () {
    test(
        "check if conversion from PagebuilderTextfieldProperties to PagebuilderTextfieldPropertiesModel works",
        () {
      // Given
      final model = PageBuilderTextFieldProperties(
          width: 200.0,
          minLines: 1,
          isRequired: false,
          backgroundColor: Colors.black,
          borderColor: null,
          placeHolderTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: 14.0,
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: null,
              alignment: TextAlign.left,
              isBold: null,
              isItalic: null),
          textProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: 14.0,
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: null,
              alignment: TextAlign.left,
              isBold: null,
              isItalic: null));
      final expectedResult = PageBuilderTextFieldPropertiesModel(
          width: 200.0,
          minLines: 1,
          isRequired: false,
          backgroundColor: "ff000000",
          borderColor: null,
          placeHolderTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins",
            "alignment": "left"
          },
          textProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins",
            "alignment": "left"
          });
      // When
      final result = PageBuilderTextFieldPropertiesModel.fromDomain(model);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderTextfieldPropertiesModel_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PageBuilderTextFieldPropertiesModel(
          width: 200.0,
          minLines: 1,
          isRequired: false,
          backgroundColor: "ff000000",
          borderColor: null,
          placeHolderTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins",
            "alignment": "left"
          },
          textProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins",
            "alignment": "left"
          });
      final properties2 = PageBuilderTextFieldPropertiesModel(
          width: 200.0,
          minLines: 1,
          isRequired: false,
          backgroundColor: "ff000000",
          borderColor: null,
          placeHolderTextProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins",
            "alignment": "left"
          },
          textProperties: {
            "text": "Test",
            "fontSize": 14.0,
            "fontFamily": "Poppins",
            "alignment": "left"
          });
      // Then
      expect(properties1, properties2);
    });
  });
}
