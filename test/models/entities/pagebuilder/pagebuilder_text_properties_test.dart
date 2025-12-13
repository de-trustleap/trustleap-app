import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_shadow.dart';
import 'package:flutter/material.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';

void main() {
  group("PagebuilderTextProperties_CopyWith", () {
    test(
        "set text and fontSize with copyWith should set text and fontSize for resulting object",
        () {
      // Given
      final model = PageBuilderTextProperties(
          text: "Test",
          fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
          fontFamily: "Poppins",
          lineHeight: null,
          letterSpacing: null,
          textShadow: null,
          color: Colors.black,
          alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left));
      final expectedResult = PageBuilderTextProperties(
          text: "Test2",
          fontSize: const PagebuilderResponsiveOrConstant.constant(18.0),
          fontFamily: "Poppins",
          lineHeight: null,
          letterSpacing: null,
          textShadow: null,
          color: Colors.black,
          alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left));
      // When
      final result = model.copyWith(text: "Test2", fontSize: const PagebuilderResponsiveOrConstant.constant(18.0));
      // Then
      expect(result, expectedResult);
    });

    test("should preserve globalFontToken and globalColorToken with copyWith", () {
      // Given
      final model = PageBuilderTextProperties(
          text: "Test",
          fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
          fontFamily: "Merriweather",
          globalFontToken: "@headline",
          lineHeight: null,
          letterSpacing: null,
          textShadow: null,
          color: Color(0xFFFF5722),
          globalColorToken: "@primary",
          alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left));
      // When
      final result = model.copyWith(text: "Updated");
      // Then
      expect(result.globalFontToken, "@headline");
      expect(result.globalColorToken, "@primary");
      expect(result.fontFamily, "Merriweather");
      expect(result.text, "Updated");
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
        fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
        fontFamily: "Arial",
        lineHeight: const PagebuilderResponsiveOrConstant.constant(1.5),
        letterSpacing: const PagebuilderResponsiveOrConstant.constant(0.5),
        color: Color(0xFF2196F3),
        alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.center),
        textShadow: textShadow,
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
      expect(copy, equals(original));
    });

    test("should preserve globalFontToken and globalColorToken in deepCopy", () {
      // Given
      const textShadow = PageBuilderShadow(
        color: Color(0x80000000),
        spreadRadius: 1.0,
        blurRadius: 4.0,
        offset: Offset(2.0, 2.0),
      );
      const original = PageBuilderTextProperties(
        text: "Hello World",
        fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
        fontFamily: "Merriweather",
        globalFontToken: "@headline",
        lineHeight: const PagebuilderResponsiveOrConstant.constant(1.5),
        letterSpacing: const PagebuilderResponsiveOrConstant.constant(0.5),
        color: Color(0xFF2196F3),
        globalColorToken: "@primary",
        alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.center),
        textShadow: textShadow,
      );
      // When
      final copy = original.deepCopy();
      // Then
      expect(copy.globalFontToken, "@headline");
      expect(copy.globalColorToken, "@primary");
      expect(copy.fontFamily, "Merriweather");
      expect(copy, equals(original));
    });
  });

  group("PagebuilderTextProperties_Props", () {
    test("check if value equality works", () {
      // Given
      final properties1 = PageBuilderTextProperties(
          text: "Test",
          fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
          fontFamily: "Poppins",
          lineHeight: null,
          letterSpacing: null,
          textShadow: null,
          color: Colors.black,
          alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left));
      final properties2 = PageBuilderTextProperties(
          text: "Test",
          fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
          fontFamily: "Poppins",
          lineHeight: null,
          letterSpacing: null,
          textShadow: null,
          color: Colors.black,
          alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left));
      // Then
      expect(properties1, properties2);
    });
  });
}
