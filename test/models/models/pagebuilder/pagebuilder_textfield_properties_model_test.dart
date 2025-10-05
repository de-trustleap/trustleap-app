import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_textfield_properties_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_responsive_or_constant_model.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_textfield_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderTextfieldPropertiesModel_CopyWith", () {
    test(
        "set backgroundColor with copyWith should set backgroundColor for resulting object",
        () {
      // Given
      const model = PageBuilderTextFieldPropertiesModel(
          width: PagebuilderResponsiveOrConstantModel.constant(200.0),
          minLines: 1,
          maxLines: 1,
          isRequired: false,
          backgroundColor: "FF000000",
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
      const expectedResult = PageBuilderTextFieldPropertiesModel(
          width: PagebuilderResponsiveOrConstantModel.constant(200.0),
          minLines: 1,
          maxLines: 1,
          isRequired: false,
          backgroundColor: "FFf00000",
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
      final result = model.copyWith(backgroundColor: "FFf00000");
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderTextfieldPropertiesModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      const model = PageBuilderTextFieldPropertiesModel(
          width: PagebuilderResponsiveOrConstantModel.constant(200.0),
          minLines: 1,
          maxLines: 1,
          isRequired: false,
          backgroundColor: "FF000000",
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
        "maxLines": 1,
        "isRequired": false,
        "backgroundColor": "FF000000",
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
        "maxLines": 1,
        "isRequired": false,
        "backgroundColor": "FF000000",
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
      const expectedResult = PageBuilderTextFieldPropertiesModel(
          width: PagebuilderResponsiveOrConstantModel.constant(200.0),
          minLines: 1,
          maxLines: 1,
          isRequired: false,
          backgroundColor: "FF000000",
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
      const model = PageBuilderTextFieldPropertiesModel(
          width: PagebuilderResponsiveOrConstantModel.constant(200.0),
          minLines: 1,
          maxLines: 1,
          isRequired: false,
          backgroundColor: "FF000000",
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
      const expectedResult = PageBuilderTextFieldProperties(
          width: PagebuilderResponsiveOrConstant.constant(200.0),
          minLines: 1,
          maxLines: 1,
          isRequired: false,
          backgroundColor: Colors.black,
          borderColor: null,
          placeHolderTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(14.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: null,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left),
              isBold: null,
              isItalic: null),
          textProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(14.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: null,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left),
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
      const model = PageBuilderTextFieldProperties(
          width: PagebuilderResponsiveOrConstant.constant(200.0),
          minLines: 1,
          maxLines: 1,
          isRequired: false,
          backgroundColor: Colors.black,
          borderColor: null,
          placeHolderTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(14.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: null,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left),
              isBold: null,
              isItalic: null),
          textProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: const PagebuilderResponsiveOrConstant.constant(14.0),
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: null,
              alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left),
              isBold: null,
              isItalic: null));
      const expectedResult = PageBuilderTextFieldPropertiesModel(
          width: PagebuilderResponsiveOrConstantModel.constant(200.0),
          minLines: 1,
          maxLines: 1,
          isRequired: false,
          backgroundColor: "FF000000",
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
      const properties1 = PageBuilderTextFieldPropertiesModel(
          width: PagebuilderResponsiveOrConstantModel.constant(200.0),
          minLines: 1,
          maxLines: 1,
          isRequired: false,
          backgroundColor: "FF000000",
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
      const properties2 = PageBuilderTextFieldPropertiesModel(
          width: PagebuilderResponsiveOrConstantModel.constant(200.0),
          minLines: 1,
          maxLines: 1,
          isRequired: false,
          backgroundColor: "FF000000",
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
