import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/features/page_builder/helpers/pagebuilder_global_styles_resolver.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_global_colors.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_global_fonts.dart';
import 'package:flutter/material.dart';

void main() {
  group("PagebuilderGlobalStylesResolver_Constructor", () {
    test("should create resolver with global styles", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      // When
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      // Then
      expect(resolver.globalStyles, globalStyles);
    });

    test("should create resolver with null global styles", () {
      // Given & When
      final resolver = PagebuilderGlobalStylesResolver(null);
      // Then
      expect(resolver.globalStyles, null);
    });
  });

  group("PagebuilderGlobalStylesResolver_ResolveColorTokenToColor", () {
    test("should resolve @primary token to primary color", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: Color(0xFF00FF00),
        tertiary: Color(0xFF0000FF),
        background: Color(0xFFFFFFFF),
        surface: Color(0xFFF0F0F0),
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      // When
      final result = resolver.resolveColorTokenToColor("@primary");
      // Then
      expect(result, Color(0xFFFF0000));
    });

    test("should resolve @secondary token to secondary color", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: Color(0xFF00FF00),
        tertiary: Color(0xFF0000FF),
        background: Color(0xFFFFFFFF),
        surface: Color(0xFFF0F0F0),
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      // When
      final result = resolver.resolveColorTokenToColor("@secondary");
      // Then
      expect(result, Color(0xFF00FF00));
    });

    test("should resolve @tertiary token to tertiary color", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: Color(0xFF00FF00),
        tertiary: Color(0xFF0000FF),
        background: Color(0xFFFFFFFF),
        surface: Color(0xFFF0F0F0),
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      // When
      final result = resolver.resolveColorTokenToColor("@tertiary");
      // Then
      expect(result, Color(0xFF0000FF));
    });

    test("should resolve @background token to background color", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: Color(0xFF00FF00),
        tertiary: Color(0xFF0000FF),
        background: Color(0xFFFFFFFF),
        surface: Color(0xFFF0F0F0),
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      // When
      final result = resolver.resolveColorTokenToColor("@background");
      // Then
      expect(result, Color(0xFFFFFFFF));
    });

    test("should resolve @surface token to surface color", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: Color(0xFF00FF00),
        tertiary: Color(0xFF0000FF),
        background: Color(0xFFFFFFFF),
        surface: Color(0xFFF0F0F0),
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      // When
      final result = resolver.resolveColorTokenToColor("@surface");
      // Then
      expect(result, Color(0xFFF0F0F0));
    });

    test("should be case insensitive", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      // When
      final result1 = resolver.resolveColorTokenToColor("@PRIMARY");
      final result2 = resolver.resolveColorTokenToColor("@Primary");
      final result3 = resolver.resolveColorTokenToColor("@primary");
      // Then
      expect(result1, Color(0xFFFF0000));
      expect(result2, Color(0xFFFF0000));
      expect(result3, Color(0xFFFF0000));
    });

    test("should return null for non-token string", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      // When
      final result = resolver.resolveColorTokenToColor("#FF0000");
      // Then
      expect(result, null);
    });

    test("should return null for unknown token", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      // When
      final result = resolver.resolveColorTokenToColor("@unknown");
      // Then
      expect(result, null);
    });

    test("should return null when globalStyles is null", () {
      // Given
      final resolver = PagebuilderGlobalStylesResolver(null);
      // When
      final result = resolver.resolveColorTokenToColor("@primary");
      // Then
      expect(result, null);
    });

    test("should return null when colors is null", () {
      // Given
      const globalStyles = PageBuilderGlobalStyles(
        colors: null,
        fonts: null,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      // When
      final result = resolver.resolveColorTokenToColor("@primary");
      // Then
      expect(result, null);
    });

    test("should return null when specific color is null", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: null,
        secondary: Color(0xFF00FF00),
        tertiary: null,
        background: null,
        surface: null,
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      // When
      final result = resolver.resolveColorTokenToColor("@primary");
      // Then
      expect(result, null);
    });
  });

  group("PagebuilderGlobalStylesResolver_ResolveColorToken", () {
    test("should resolve color token to hex string", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      // When
      final result = resolver.resolveColorToken("@primary");
      // Then
      expect(result, "FFFF0000");
    });

    test("should return original string if not a token", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      // When
      final result = resolver.resolveColorToken("#00FF00");
      // Then
      expect(result, "#00FF00");
    });

    test("should return original string if token cannot be resolved", () {
      // Given
      const globalStyles = PageBuilderGlobalStyles(
        colors: null,
        fonts: null,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      // When
      final result = resolver.resolveColorToken("@primary");
      // Then
      expect(result, "@primary");
    });
  });

  group("PagebuilderGlobalStylesResolver_ResolveFontToken", () {
    test("should resolve @headline token to headline font", () {
      // Given
      const fonts = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Open Sans",
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: null,
        fonts: fonts,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      // When
      final result = resolver.resolveFontToken("@headline");
      // Then
      expect(result, "Roboto");
    });

    test("should resolve @text token to text font", () {
      // Given
      const fonts = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Open Sans",
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: null,
        fonts: fonts,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      // When
      final result = resolver.resolveFontToken("@text");
      // Then
      expect(result, "Open Sans");
    });

    test("should be case insensitive", () {
      // Given
      const fonts = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Open Sans",
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: null,
        fonts: fonts,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      // When
      final result1 = resolver.resolveFontToken("@HEADLINE");
      final result2 = resolver.resolveFontToken("@Headline");
      final result3 = resolver.resolveFontToken("@headline");
      // Then
      expect(result1, "Roboto");
      expect(result2, "Roboto");
      expect(result3, "Roboto");
    });

    test("should return original string if not a token", () {
      // Given
      const fonts = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Open Sans",
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: null,
        fonts: fonts,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      // When
      final result = resolver.resolveFontToken("Arial");
      // Then
      expect(result, "Arial");
    });

    test("should return original string for unknown token", () {
      // Given
      const fonts = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Open Sans",
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: null,
        fonts: fonts,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      // When
      final result = resolver.resolveFontToken("@unknown");
      // Then
      expect(result, "@unknown");
    });

    test("should return original string when globalStyles is null", () {
      // Given
      final resolver = PagebuilderGlobalStylesResolver(null);
      // When
      final result = resolver.resolveFontToken("@headline");
      // Then
      expect(result, "@headline");
    });

    test("should return original string when fonts is null", () {
      // Given
      const globalStyles = PageBuilderGlobalStyles(
        colors: null,
        fonts: null,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      // When
      final result = resolver.resolveFontToken("@headline");
      // Then
      expect(result, "@headline");
    });

    test("should return original string when specific font is null", () {
      // Given
      const fonts = PageBuilderGlobalFonts(
        headline: null,
        text: "Open Sans",
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: null,
        fonts: fonts,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      // When
      final result = resolver.resolveFontToken("@headline");
      // Then
      expect(result, "@headline");
    });
  });

  group("PagebuilderGlobalStylesResolver_ResolveHtmlColorTokens", () {
    test("should resolve single color token in HTML with 6-digit hex for opaque colors", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      const html = '<div style="color: @primary">Text</div>';
      // When
      final result = resolver.resolveHtmlColorTokens(html);
      // Then
      expect(result, '<div style="color: #FF0000">Text</div>');
    });

    test("should resolve multiple color tokens in HTML with 6-digit hex for opaque colors", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: Color(0xFF00FF00),
        tertiary: null,
        background: null,
        surface: null,
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      const html =
          '<div style="color: @primary">Text</div><span style="color: @secondary">More</span>';
      // When
      final result = resolver.resolveHtmlColorTokens(html);
      // Then
      expect(result,
          '<div style="color: #FF0000">Text</div><span style="color: #00FF00">More</span>');
    });

    test("should resolve transparent color token with 8-digit hex", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0x80FF0000),
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      const html = '<div style="color: @primary">Text</div>';
      // When
      final result = resolver.resolveHtmlColorTokens(html);
      // Then
      expect(result, '<div style="color: 80FF0000">Text</div>');
    });

    test("should handle HTML with no color tokens", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      const html = '<div style="color: #FF0000">Text</div>';
      // When
      final result = resolver.resolveHtmlColorTokens(html);
      // Then
      expect(result, html);
    });

    test("should handle HTML with spacing variations", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      const html = '<div style="color:@primary">Text</div>';
      // When
      final result = resolver.resolveHtmlColorTokens(html);
      // Then
      expect(result, '<div style="color: #FF0000">Text</div>');
    });

    test("should not resolve unresolvable tokens", () {
      // Given
      const globalStyles = PageBuilderGlobalStyles(
        colors: null,
        fonts: null,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      const html = '<div style="color: @primary">Text</div>';
      // When
      final result = resolver.resolveHtmlColorTokens(html);
      // Then
      expect(result, '<div style="color: @primary">Text</div>');
    });
  });

  group("PagebuilderGlobalStylesResolver_ResolveHtmlFontTokens", () {
    test("should resolve single font token in HTML", () {
      // Given
      const fonts = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Open Sans",
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: null,
        fonts: fonts,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      const html = '<div style="font-family: @headline">Text</div>';
      // When
      final result = resolver.resolveHtmlFontTokens(html);
      // Then
      expect(result, '<div style="font-family: Roboto">Text</div>');
    });

    test("should resolve multiple font tokens in HTML", () {
      // Given
      const fonts = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Open Sans",
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: null,
        fonts: fonts,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      const html =
          '<h1 style="font-family: @headline">Title</h1><p style="font-family: @text">Body</p>';
      // When
      final result = resolver.resolveHtmlFontTokens(html);
      // Then
      expect(result,
          '<h1 style="font-family: Roboto">Title</h1><p style="font-family: Open Sans">Body</p>');
    });

    test("should handle HTML with no font tokens", () {
      // Given
      const fonts = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Open Sans",
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: null,
        fonts: fonts,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      const html = '<div style="font-family: Arial">Text</div>';
      // When
      final result = resolver.resolveHtmlFontTokens(html);
      // Then
      expect(result, html);
    });

    test("should handle HTML with spacing variations", () {
      // Given
      const fonts = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Open Sans",
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: null,
        fonts: fonts,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      const html = '<div style="font-family:@headline">Text</div>';
      // When
      final result = resolver.resolveHtmlFontTokens(html);
      // Then
      expect(result, '<div style="font-family: Roboto">Text</div>');
    });

    test("should not resolve unresolvable tokens", () {
      // Given
      const globalStyles = PageBuilderGlobalStyles(
        colors: null,
        fonts: null,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      const html = '<div style="font-family: @headline">Text</div>';
      // When
      final result = resolver.resolveHtmlFontTokens(html);
      // Then
      expect(result, '<div style="font-family: @headline">Text</div>');
    });
  });

  group("PagebuilderGlobalStylesResolver_ResolveHtmlTokens", () {
    test("should resolve both color and font tokens in HTML", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const fonts = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Open Sans",
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: fonts,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      const html =
          '<div style="color: @primary; font-family: @headline">Text</div>';
      // When
      final result = resolver.resolveHtmlTokens(html);
      // Then
      expect(result,
          '<div style="color: #FF0000; font-family: Roboto">Text</div>');
    });

    test("should resolve multiple mixed tokens in HTML", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: Color(0xFF00FF00),
        tertiary: null,
        background: null,
        surface: null,
      );
      const fonts = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Open Sans",
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: fonts,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      const html =
          '<h1 style="color: @primary; font-family: @headline">Title</h1><p style="color: @secondary; font-family: @text">Body</p>';
      // When
      final result = resolver.resolveHtmlTokens(html);
      // Then
      expect(result,
          '<h1 style="color: #FF0000; font-family: Roboto">Title</h1><p style="color: #00FF00; font-family: Open Sans">Body</p>');
    });

    test("should handle HTML with only color tokens", () {
      // Given
      const colors = PageBuilderGlobalColors(
        primary: Color(0xFFFF0000),
        secondary: null,
        tertiary: null,
        background: null,
        surface: null,
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: colors,
        fonts: null,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      const html = '<div style="color: @primary">Text</div>';
      // When
      final result = resolver.resolveHtmlTokens(html);
      // Then
      expect(result, '<div style="color: #FF0000">Text</div>');
    });

    test("should handle HTML with only font tokens", () {
      // Given
      const fonts = PageBuilderGlobalFonts(
        headline: "Roboto",
        text: "Open Sans",
      );
      const globalStyles = PageBuilderGlobalStyles(
        colors: null,
        fonts: fonts,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      const html = '<div style="font-family: @headline">Text</div>';
      // When
      final result = resolver.resolveHtmlTokens(html);
      // Then
      expect(result, '<div style="font-family: Roboto">Text</div>');
    });

    test("should handle HTML with no tokens", () {
      // Given
      const globalStyles = PageBuilderGlobalStyles(
        colors: null,
        fonts: null,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      const html = '<div style="color: #FF0000; font-family: Arial">Text</div>';
      // When
      final result = resolver.resolveHtmlTokens(html);
      // Then
      expect(result, html);
    });

    test("should handle empty HTML", () {
      // Given
      const globalStyles = PageBuilderGlobalStyles(
        colors: null,
        fonts: null,
      );
      final resolver = PagebuilderGlobalStylesResolver(globalStyles);
      const html = '';
      // When
      final result = resolver.resolveHtmlTokens(html);
      // Then
      expect(result, '');
    });
  });
}
