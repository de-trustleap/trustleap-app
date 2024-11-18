import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
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
