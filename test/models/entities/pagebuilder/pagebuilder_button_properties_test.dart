import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_shadow.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderButtonProperties_CopyWith", () {
    test(
        "set width and borderRadius with copyWith should set width and borderRadius for resulting object",
        () {
      // Given
      final model = PageBuilderButtonProperties(
          width: 200.0,
          height: 50.0,
          borderRadius: 10.0,
          backgroundColor: Colors.white,
          textProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: 18.0,
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: null,
              alignment: null,
              isBold: null,
              isItalic: true));
      final expectedResult = PageBuilderButtonProperties(
          width: 400.0,
          height: 50.0,
          borderRadius: 12.0,
          backgroundColor: Colors.white,
          textProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: 18.0,
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: null,
              alignment: null,
              isBold: null,
              isItalic: true));
      // When
      final result = model.copyWith(width: 400.0, borderRadius: 12.0);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderButtonProperties DeepCopy", () {
    test("should create independent copy with all properties", () {
      // Given
      const textProperties = PageBuilderTextProperties(
        text: "Test Button",
        fontSize: 16.0,
        fontFamily: "Arial",
        lineHeight: 1.2,
        letterSpacing: 0.5,
        color: Colors.white,
        alignment: TextAlign.center,
        textShadow: PageBuilderShadow(
          color: Colors.black26,
          spreadRadius: 0.0,
          blurRadius: 2.0,
          offset: Offset(1.0, 1.0),
        ),
        isBold: true,
        isItalic: false,
      );

      const original = PageBuilderButtonProperties(
        width: 200.0,
        height: 50.0,
        borderRadius: 8.0,
        backgroundColor: Color(0xFF2196F3),
        textProperties: textProperties,
      );

      // When
      final copy = original.deepCopy();

      // Then
      expect(copy, isNot(same(original)));
      expect(copy.width, equals(original.width));
      expect(copy.height, equals(original.height));
      expect(copy.borderRadius, equals(original.borderRadius));
      expect(copy.backgroundColor, equals(original.backgroundColor));
      expect(copy.textProperties, equals(original.textProperties));
    });
  });

  group("PagebuilderButtonProperties_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PageBuilderButtonProperties(
          width: 200.0,
          height: 50.0,
          borderRadius: 10.0,
          backgroundColor: Colors.white,
          textProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: 18.0,
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: null,
              alignment: null,
              isBold: false,
              isItalic: true));
      final properties2 = PageBuilderButtonProperties(
          width: 200.0,
          height: 50.0,
          borderRadius: 10.0,
          backgroundColor: Colors.white,
          textProperties: PageBuilderTextProperties(
              text: "Test",
              fontSize: 18.0,
              fontFamily: "Poppins",
              lineHeight: null,
              letterSpacing: null,
              textShadow: null,
              color: null,
              alignment: null,
              isBold: false,
              isItalic: true));
      // Then
      expect(properties1, properties2);
    });
  });
}
