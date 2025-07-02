import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_textfield_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_shadow.dart';
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

  group("PageBuilderTextFieldProperties_DeepCopy", () {
    test("should create independent copy with all properties", () {
      // Given
      const placeholderTextShadow = PageBuilderShadow(
        color: Color(0x40000000),
        spreadRadius: 0.5,
        blurRadius: 2.0,
        offset: Offset(1.0, 1.0),
      );
      const placeholderTextProperties = PageBuilderTextProperties(
        text: "Enter your text",
        fontSize: 14.0,
        fontFamily: "Arial",
        lineHeight: 1.2,
        letterSpacing: 0.0,
        color: Color(0xFF757575),
        alignment: TextAlign.left,
        textShadow: placeholderTextShadow,
        isBold: false,
        isItalic: true,
      );
      const textShadow = PageBuilderShadow(
        color: Color(0x80000000),
        spreadRadius: 1.0,
        blurRadius: 4.0,
        offset: Offset(2.0, 2.0),
      );
      const textProperties = PageBuilderTextProperties(
        text: "User input",
        fontSize: 16.0,
        fontFamily: "Roboto",
        lineHeight: 1.4,
        letterSpacing: 0.2,
        color: Color(0xFF212121),
        alignment: TextAlign.left,
        textShadow: textShadow,
        isBold: false,
        isItalic: false,
      );
      const original = PageBuilderTextFieldProperties(
        width: 300.0,
        minLines: 1,
        maxLines: 3,
        isRequired: true,
        backgroundColor: Color(0xFFF5F5F5),
        borderColor: Color(0xFF2196F3),
        placeHolderTextProperties: placeholderTextProperties,
        textProperties: textProperties,
      );
      // When
      final copy = original.deepCopy();
      // Then
      expect(copy, isNot(same(original)));
      expect(copy.width, equals(original.width));
      expect(copy.minLines, equals(original.minLines));
      expect(copy.maxLines, equals(original.maxLines));
      expect(copy.isRequired, equals(original.isRequired));
      expect(copy.backgroundColor, equals(original.backgroundColor));
      expect(copy.borderColor, equals(original.borderColor));
      expect(copy.placeHolderTextProperties,
          equals(original.placeHolderTextProperties));
      expect(copy.textProperties, equals(original.textProperties));
      expect(copy, equals(original));
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
