import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_anchor_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_border.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_shadow.dart';
import 'package:flutter/material.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_paint.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';

void main() {
  group("PagebuilderAnchorButtonProperties_CopyWith", () {
    test(
        "set sectionName with copyWith should set sectionName for resulting object",
        () {
      // Given
      final model = PagebuilderAnchorButtonProperties(
          sectionName: "1",
          buttonProperties: PageBuilderButtonProperties(
              width: const PagebuilderResponsiveOrConstant.constant(200.0),
              height: const PagebuilderResponsiveOrConstant.constant(50.0),
              minWidthPercent: null,
              contentPadding: null,
              border: const PagebuilderBorder(radius: 10.0, width: null, color: null),
              backgroundPaint: const PagebuilderPaint.color(Colors.white),
              textProperties: PageBuilderTextProperties(
                  text: "Test",
                  fontSize: const PagebuilderResponsiveOrConstant.constant(18.0),
                  fontFamily: "Poppins",
                  lineHeight: null,
                  letterSpacing: null,
                  textShadow: null,
                  color: null,
                  alignment: null)));
      final expectedResult = PagebuilderAnchorButtonProperties(
          sectionName: "2",
          buttonProperties: PageBuilderButtonProperties(
              width: const PagebuilderResponsiveOrConstant.constant(200.0),
              height: const PagebuilderResponsiveOrConstant.constant(50.0),
              minWidthPercent: null,
              contentPadding: null,
              border: const PagebuilderBorder(radius: 10.0, width: null, color: null),
              backgroundPaint: const PagebuilderPaint.color(Colors.white),
              textProperties: PageBuilderTextProperties(
                  text: "Test",
                  fontSize: const PagebuilderResponsiveOrConstant.constant(18.0),
                  fontFamily: "Poppins",
                  lineHeight: null,
                  letterSpacing: null,
                  textShadow: null,
                  color: null,
                  alignment: null)));
      // When
      final result = model.copyWith(sectionName: "2");
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
        fontSize: const PagebuilderResponsiveOrConstant.constant(14.0),
        fontFamily: 'Roboto',
        lineHeight: const PagebuilderResponsiveOrConstant.constant(1.2),
        letterSpacing: const PagebuilderResponsiveOrConstant.constant(0.3),
        color: Colors.black,
        alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left),
        textShadow: originalTextShadow,
      );

      final originalButtonProperties = PageBuilderButtonProperties(
        width: const PagebuilderResponsiveOrConstant.constant(100.0),
        height: const PagebuilderResponsiveOrConstant.constant(40.0),
        minWidthPercent: null,
        contentPadding: null,
        border: const PagebuilderBorder(radius: 4.0, width: null, color: null),
        backgroundPaint: const PagebuilderPaint.color(Colors.green),
        textProperties: originalTextProperties,
      );

      final original = PagebuilderAnchorButtonProperties(
        sectionName: 'original-section',
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
        fontSize: const PagebuilderResponsiveOrConstant.constant(20.0),
        fontFamily: 'Helvetica',
        lineHeight: const PagebuilderResponsiveOrConstant.constant(2.0),
        letterSpacing: const PagebuilderResponsiveOrConstant.constant(1.0),
        color: Colors.yellow,
        alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.right),
        textShadow: mutatedTextShadow,
      );

      final mutatedButtonProperties = PageBuilderButtonProperties(
        width: const PagebuilderResponsiveOrConstant.constant(300.0),
        height: const PagebuilderResponsiveOrConstant.constant(80.0),
        minWidthPercent: null,
        contentPadding: null,
        border: const PagebuilderBorder(radius: 16.0, width: null, color: null),
        backgroundPaint: const PagebuilderPaint.color(Colors.purple),
        textProperties: mutatedTextProperties,
      );

      final mutatedCopy = PagebuilderAnchorButtonProperties(
        sectionName: 'mutated-section',
        buttonProperties: mutatedButtonProperties,
      );

      // Then
      expect(original.sectionName, equals('original-section'));
      expect(original.buttonProperties?.width, equals(const PagebuilderResponsiveOrConstant.constant(100.0)));
      expect(original.buttonProperties?.height, equals(const PagebuilderResponsiveOrConstant.constant(40.0)));
      expect(original.buttonProperties?.border?.radius, equals(4.0));
      expect(original.buttonProperties?.backgroundPaint?.color, equals(Colors.green));
      expect(original.buttonProperties?.textProperties?.text,
          equals('Original Text'));
      expect(original.buttonProperties?.textProperties?.fontSize, equals(const PagebuilderResponsiveOrConstant.constant(14.0)));
      expect(original.buttonProperties?.textProperties?.color,
          equals(Colors.black));
      expect(original.buttonProperties?.textProperties?.textShadow?.color,
          equals(Colors.red));

      expect(mutatedCopy.sectionName, equals('mutated-section'));
      expect(mutatedCopy.buttonProperties?.width, equals(const PagebuilderResponsiveOrConstant.constant(300.0)));
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
          sectionName: "1",
          buttonProperties: PageBuilderButtonProperties(
              width: const PagebuilderResponsiveOrConstant.constant(200.0),
              height: const PagebuilderResponsiveOrConstant.constant(50.0),
              minWidthPercent: null,
              contentPadding: null,
              border: const PagebuilderBorder(radius: 10.0, width: null, color: null),
              backgroundPaint: const PagebuilderPaint.color(Colors.white),
              textProperties: PageBuilderTextProperties(
                  text: "Test",
                  fontSize: const PagebuilderResponsiveOrConstant.constant(18.0),
                  fontFamily: "Poppins",
                  lineHeight: null,
                  letterSpacing: null,
                  textShadow: null,
                  color: null,
                  alignment: null)));
      final model2 = PagebuilderAnchorButtonProperties(
          sectionName: "1",
          buttonProperties: PageBuilderButtonProperties(
              width: const PagebuilderResponsiveOrConstant.constant(200.0),
              height: const PagebuilderResponsiveOrConstant.constant(50.0),
              minWidthPercent: null,
              contentPadding: null,
              border: const PagebuilderBorder(radius: 10.0, width: null, color: null),
              backgroundPaint: const PagebuilderPaint.color(Colors.white),
              textProperties: PageBuilderTextProperties(
                  text: "Test",
                  fontSize: const PagebuilderResponsiveOrConstant.constant(18.0),
                  fontFamily: "Poppins",
                  lineHeight: null,
                  letterSpacing: null,
                  textShadow: null,
                  color: null,
                  alignment: null)));
      // Then
      expect(model, model2);
    });
  });
}
