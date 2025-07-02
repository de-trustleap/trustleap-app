import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_shadow.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderTextProperties_CopyWith", () {
    test(
        "set text and fontSize with copyWith should set text and fontSize for resulting object",
        () {
      // Given
      final model = PageBuilderTextProperties(
          text: "Test",
          fontSize: 16.0,
          fontFamily: "Poppins",
          lineHeight: null,
          letterSpacing: null,
          textShadow: null,
          color: Colors.black,
          alignment: TextAlign.left,
          isBold: false,
          isItalic: null);
      final expectedResult = PageBuilderTextProperties(
          text: "Test2",
          fontSize: 18.0,
          fontFamily: "Poppins",
          lineHeight: null,
          letterSpacing: null,
          textShadow: null,
          color: Colors.black,
          alignment: TextAlign.left,
          isBold: false,
          isItalic: null);
      // When
      final result = model.copyWith(text: "Test2", fontSize: 18.0);
      // Then
      expect(result, expectedResult);
    });
  });

  group("PageBuilderTextProperties_DeepCopy", () {
    test("should create independent copy with all properties", () {
      // Given
      const textShadow = PageBuilderShadow(
        color: Color(0x80000000),
        spreadRadius: 1.0,
        blurRadius: 4.0,
        offset: Offset(2.0, 2.0),
      );
      const original = PageBuilderTextProperties(
        text: "Hello World",
        fontSize: 16.0,
        fontFamily: "Arial",
        lineHeight: 1.5,
        letterSpacing: 0.5,
        color: Color(0xFF2196F3),
        alignment: TextAlign.center,
        textShadow: textShadow,
        isBold: true,
        isItalic: false,
      );
      // When
      final copy = original.deepCopy();
      // Then
      expect(copy, isNot(same(original)));
      expect(copy.text, equals(original.text));
      expect(copy.fontSize, equals(original.fontSize));
      expect(copy.fontFamily, equals(original.fontFamily));
      expect(copy.lineHeight, equals(original.lineHeight));
      expect(copy.letterSpacing, equals(original.letterSpacing));
      expect(copy.color, equals(original.color));
      expect(copy.alignment, equals(original.alignment));
      expect(copy.textShadow, equals(original.textShadow));
      expect(copy.isBold, equals(original.isBold));
      expect(copy.isItalic, equals(original.isItalic));
      expect(copy, equals(original));
    });
  });

  group("PagebuilderTextProperties_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PageBuilderTextProperties(
          text: "Test",
          fontSize: 16.0,
          fontFamily: "Poppins",
          lineHeight: null,
          letterSpacing: null,
          textShadow: null,
          color: Colors.black,
          alignment: TextAlign.left,
          isBold: false,
          isItalic: null);
      final properties2 = PageBuilderTextProperties(
          text: "Test",
          fontSize: 16.0,
          fontFamily: "Poppins",
          lineHeight: null,
          letterSpacing: null,
          textShadow: null,
          color: Colors.black,
          alignment: TextAlign.left,
          isBold: false,
          isItalic: null);
      // Then
      expect(properties1, properties2);
    });
  });
}
