import 'package:flutter_test/flutter_test.dart';
import "package:finanzbegleiter/presentation/page_builder/page_elements/textstyle_parser.dart";
import "package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart";
import "package:flutter/material.dart";
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:finanzbegleiter/constants.dart';

class TextStyleParserTestModule extends Module {
  final PagebuilderResponsiveBreakpointCubit breakpointCubit;

  TextStyleParserTestModule(this.breakpointCubit);

  @override
  void binds(i) {
    i.addInstance<PagebuilderResponsiveBreakpointCubit>(breakpointCubit);
  }

  @override
  void routes(r) {}
}

void main() {
  group("TextStyleParser Tests", () {
    late TextStyleParser textStyleParser;
    late PagebuilderResponsiveBreakpointCubit breakpointCubit;

    setUp(() {
      textStyleParser = TextStyleParser();
      breakpointCubit = PagebuilderResponsiveBreakpointCubit();
      Modular.init(TextStyleParserTestModule(breakpointCubit));
    });

    tearDown(() {
      Modular.destroy();
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
        fontSize: const PagebuilderResponsiveOrConstant.constant(14.0),
        fontFamily: "Roboto",
        lineHeight: const PagebuilderResponsiveOrConstant.constant(1.5),
        letterSpacing: null,
        textShadow: null,
        color: Colors.black,
        alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.left),
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
        fontSize: const PagebuilderResponsiveOrConstant.constant(12.0),
        fontFamily: "Arial",
        lineHeight: const PagebuilderResponsiveOrConstant.constant(1.2),
        letterSpacing: null,
        textShadow: null,
        color: Colors.blue,
        alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.center),
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
        fontSize: const PagebuilderResponsiveOrConstant.constant(16.0),
        fontFamily: "Times New Roman",
        lineHeight: const PagebuilderResponsiveOrConstant.constant(1.4),
        letterSpacing: null,
        textShadow: null,
        color: Colors.red,
        alignment: const PagebuilderResponsiveOrConstant.constant(TextAlign.right),
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
