import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
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
          color: Colors.black,
          alignment: TextAlign.left,
          isBold: false,
          isItalic: null);
      final expectedResult = PageBuilderTextProperties(
          text: "Test2",
          fontSize: 18.0,
          fontFamily: "Poppins",
          lineHeight: null,
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

    group("PagebuilderTextProperties_Props", () {
    test(
        "check if value equality works",
        () {
      // Given
      final properties1 = PageBuilderTextProperties(
          text: "Test",
          fontSize: 16.0,
          fontFamily: "Poppins",
          lineHeight: null,
          color: Colors.black,
          alignment: TextAlign.left,
          isBold: false,
          isItalic: null);
      final properties2 = PageBuilderTextProperties(
          text: "Test",
          fontSize: 16.0,
          fontFamily: "Poppins",
          lineHeight: null,
          color: Colors.black,
          alignment: TextAlign.left,
          isBold: false,
          isItalic: null);
      // Then
      expect(properties1, properties2);
    });
  });
}
