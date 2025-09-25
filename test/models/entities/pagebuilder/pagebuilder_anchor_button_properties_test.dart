import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_anchor_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_shadow.dart';
import 'package:flutter/material.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_paint.dart';

void main() {
  group("PagebuilderAnchorButtonProperties_CopyWith", () {
    test(
        "set sectionID with copyWith should set sectionID for resulting object",
        () {
      // Given
      final model = PagebuilderAnchorButtonProperties(
          sectionID: "1",
          buttonProperties: PageBuilderButtonProperties(
              width: 200.0,
              height: 50.0,
              borderRadius: 10.0,
              backgroundPaint: const PagebuilderPaint.color(Colors.white),
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
                  isItalic: true)));
      final expectedResult = PagebuilderAnchorButtonProperties(
          sectionID: "2",
          buttonProperties: PageBuilderButtonProperties(
              width: 200.0,
              height: 50.0,
              borderRadius: 10.0,
              backgroundPaint: const PagebuilderPaint.color(Colors.white),
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
                  isItalic: true)));
      // When
      final result = model.copyWith(sectionID: "2");
      // Then
      expect(result, expectedResult);
    });
  });

  group("PagebuilderAnchorButtonProperties_DeepCopy", () {
    test('should create independent copies (mutation test)', () {
      // Given
      final originalTextShadow = PageBuilderShadow(
        color: Colors.red,
        spreadRadius: 2.0,
        blurRadius: 4.0,
        offset: Offset(2.0, 2.0),
      );

      final originalTextProperties = PageBuilderTextProperties(
        text: 'Original Text',
        fontSize: 14.0,
        fontFamily: 'Roboto',
        lineHeight: 1.2,
        letterSpacing: 0.3,
        color: Colors.black,
        alignment: TextAlign.left,
        textShadow: originalTextShadow,
        isBold: false,
        isItalic: true,
      );

      final originalButtonProperties = PageBuilderButtonProperties(
        width: 100.0,
        height: 40.0,
        borderRadius: 4.0,
        backgroundPaint: const PagebuilderPaint.color(Colors.green),
        textProperties: originalTextProperties,
      );

      final original = PagebuilderAnchorButtonProperties(
        sectionID: 'original-section',
        buttonProperties: originalButtonProperties,
      );

      // When
      final copy = original.deepCopy();

      final mutatedTextShadow = PageBuilderShadow(
        color: Colors.blue,
        spreadRadius: 5.0,
        blurRadius: 10.0,
        offset: Offset(5.0, 5.0),
      );

      final mutatedTextProperties = PageBuilderTextProperties(
        text: 'Mutated Text',
        fontSize: 20.0,
        fontFamily: 'Helvetica',
        lineHeight: 2.0,
        letterSpacing: 1.0,
        color: Colors.yellow,
        alignment: TextAlign.right,
        textShadow: mutatedTextShadow,
        isBold: true,
        isItalic: false,
      );

      final mutatedButtonProperties = PageBuilderButtonProperties(
        width: 300.0,
        height: 80.0,
        borderRadius: 16.0,
        backgroundPaint: const PagebuilderPaint.color(Colors.purple),
        textProperties: mutatedTextProperties,
      );

      final mutatedCopy = PagebuilderAnchorButtonProperties(
        sectionID: 'mutated-section',
        buttonProperties: mutatedButtonProperties,
      );

      // Then
      expect(original.sectionID, equals('original-section'));
      expect(original.buttonProperties?.width, equals(100.0));
      expect(original.buttonProperties?.height, equals(40.0));
      expect(original.buttonProperties?.borderRadius, equals(4.0));
      expect(original.buttonProperties?.backgroundPaint?.color, equals(Colors.green));
      expect(original.buttonProperties?.textProperties?.text,
          equals('Original Text'));
      expect(original.buttonProperties?.textProperties?.fontSize, equals(14.0));
      expect(original.buttonProperties?.textProperties?.color,
          equals(Colors.black));
      expect(original.buttonProperties?.textProperties?.textShadow?.color,
          equals(Colors.red));

      expect(mutatedCopy.sectionID, equals('mutated-section'));
      expect(mutatedCopy.buttonProperties?.width, equals(300.0));
      expect(mutatedCopy.buttonProperties?.textProperties?.text,
          equals('Mutated Text'));
      expect(mutatedCopy.buttonProperties?.textProperties?.textShadow?.color,
          equals(Colors.blue));
    });
  });

  group("PagebuilderAnchorButtonProperties_Props", () {
    test("check if value equality works", () {
      // When
      final model = PagebuilderAnchorButtonProperties(
          sectionID: "1",
          buttonProperties: PageBuilderButtonProperties(
              width: 200.0,
              height: 50.0,
              borderRadius: 10.0,
              backgroundPaint: const PagebuilderPaint.color(Colors.white),
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
                  isItalic: true)));
      final model2 = PagebuilderAnchorButtonProperties(
          sectionID: "1",
          buttonProperties: PageBuilderButtonProperties(
              width: 200.0,
              height: 50.0,
              borderRadius: 10.0,
              backgroundPaint: const PagebuilderPaint.color(Colors.white),
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
                  isItalic: true)));
      // Then
      expect(model, model2);
    });
  });
}
