import "package:test/test.dart";
import "package:finanzbegleiter/presentation/page_builder/page_elements/textstyle_parser.dart";
import "package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart";
import "package:flutter/material.dart";

void main() {
  group("TextStyleParser Tests", () {
    late TextStyleParser textStyleParser;

    setUp(() {
      textStyleParser = TextStyleParser();
    });

    test("Should return default TextStyle when properties is null", () {
      final textStyle = textStyleParser.getTextStyleFromProperties(null);

      expect(textStyle.fontSize, isNull);
      expect(textStyle.fontFamilyFallback, ["Poppins"]);
      expect(textStyle.fontWeight, FontWeight.normal);
      expect(textStyle.fontStyle, FontStyle.normal);
    });

    test("Should return TextStyle with bold fontWeight when isBold is true",
        () {
      final properties = PageBuilderTextProperties(
        text: "Test",
        fontSize: 14,
        fontFamily: "Roboto",
        lineHeight: 1.5,
        letterSpacing: null,
        textShadow: null,
        color: Colors.black,
        alignment: TextAlign.left,
        isBold: true,
        isItalic: false,
      );
      final textStyle = textStyleParser.getTextStyleFromProperties(properties);

      expect(textStyle.fontSize, 14);
      expect(textStyle.fontFamily, "Roboto");
      expect(textStyle.fontWeight, FontWeight.bold);
      expect(textStyle.fontStyle, FontStyle.normal);
      expect(textStyle.color, Colors.black);
    });

    test("Should return TextStyle with italic fontStyle when isItalic is true",
        () {
      final properties = PageBuilderTextProperties(
        text: "Test",
        fontSize: 12,
        fontFamily: "Arial",
        lineHeight: 1.2,
        letterSpacing: null,
        textShadow: null,
        color: Colors.blue,
        alignment: TextAlign.center,
        isBold: false,
        isItalic: true,
      );
      final textStyle = textStyleParser.getTextStyleFromProperties(properties);

      expect(textStyle.fontSize, 12);
      expect(textStyle.fontFamily, "Arial");
      expect(textStyle.fontWeight, FontWeight.normal);
      expect(textStyle.fontStyle, FontStyle.italic);
      expect(textStyle.color, Colors.blue);
    });

    test(
        "Should return TextStyle with provided fontSize, fontFamily, and color",
        () {
      final properties = PageBuilderTextProperties(
        text: "Test",
        fontSize: 16,
        fontFamily: "Times New Roman",
        lineHeight: 1.4,
        letterSpacing: null,
        textShadow: null,
        color: Colors.red,
        alignment: TextAlign.right,
        isBold: false,
        isItalic: false,
      );
      final textStyle = textStyleParser.getTextStyleFromProperties(properties);

      expect(textStyle.fontSize, 16);
      expect(textStyle.fontFamily, "Times New Roman");
      expect(textStyle.color, Colors.red);
    });
  });
}
