import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_textfield_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderTextfieldProperties_CopyWith", () {
    test(
        "set minLines and textProperties with copyWith should set minLines and textProperties for resulting object",
        () {
      // Given
      final model = PageBuilderTextFieldProperties(
          width: 200.0,
          minLines: 1,
          maxLines: 1,
          isRequired: true,
          backgroundColor: null,
          borderColor: Colors.black,
          placeHolderTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: 16.0,
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: Colors.black,
              alignment: TextAlign.left,
              isBold: null,
              isItalic: true),
          textProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: 16.0,
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: Colors.black,
              alignment: TextAlign.left,
              isBold: null,
              isItalic: true));
      final expectedResult = PageBuilderTextFieldProperties(
          width: 200.0,
          minLines: 2,
          maxLines: 1,
          isRequired: true,
          backgroundColor: null,
          borderColor: Colors.black,
          placeHolderTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: 16.0,
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: Colors.black,
              alignment: TextAlign.left,
              isBold: null,
              isItalic: true),
          textProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: 16.0,
              fontFamily: "Poppins",
              lineHeight: 1.5,
              letterSpacing: null,
              textShadow: null,
              color: Colors.black,
              alignment: TextAlign.left,
              isBold: null,
              isItalic: true));
      // When
      final result = model.copyWith(
          minLines: 2,
          textProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: 16.0,
              fontFamily: "Poppins",
              lineHeight: 1.5,
              letterSpacing: null,
              textShadow: null,
              color: Colors.black,
              alignment: TextAlign.left,
              isBold: null,
              isItalic: true));
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderTextfieldProperties_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PageBuilderTextFieldProperties(
          width: 200.0,
          minLines: 1,
          maxLines: 1,
          isRequired: true,
          backgroundColor: null,
          borderColor: Colors.black,
          placeHolderTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: 16.0,
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: Colors.black,
              alignment: TextAlign.left,
              isBold: null,
              isItalic: true),
          textProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: 16.0,
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: Colors.black,
              alignment: TextAlign.left,
              isBold: null,
              isItalic: true));
      final properties2 = PageBuilderTextFieldProperties(
          width: 200.0,
          minLines: 1,
          maxLines: 1,
          isRequired: true,
          backgroundColor: null,
          borderColor: Colors.black,
          placeHolderTextProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: 16.0,
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: Colors.black,
              alignment: TextAlign.left,
              isBold: null,
              isItalic: true),
          textProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: 16.0,
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: Colors.black,
              alignment: TextAlign.left,
              isBold: null,
              isItalic: true));
      // Then
      expect(properties1, properties2);
    });
  });
}
