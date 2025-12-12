import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:flutter/material.dart';

class PagebuilderGlobalStylesResolver {
  final PageBuilderGlobalStyles? globalStyles;

  PagebuilderGlobalStylesResolver(this.globalStyles);

  Color? resolveColorTokenToColor(String colorToken) {
    if (!colorToken.startsWith('@')) {
      return null;
    }

    final token = colorToken.substring(1).toLowerCase();

    switch (token) {
      case "primary":
        return globalStyles?.colors?.primary;
      case "secondary":
        return globalStyles?.colors?.secondary;
      case "tertiary":
        return globalStyles?.colors?.tertiary;
      case "background":
        return globalStyles?.colors?.background;
      case "surface":
        return globalStyles?.colors?.surface;
      default:
        return null;
    }
  }

  String resolveColorToken(String colorString) {
    if (!colorString.startsWith('@')) {
      return colorString;
    }

    final resolvedColor = resolveColorTokenToColor(colorString);
    if (resolvedColor != null) {
      return ColorUtility.colorToHex(resolvedColor);
    }

    return colorString;
  }

  String resolveFontToken(String fontString) {
    if (!fontString.startsWith('@')) {
      return fontString;
    }

    final token = fontString.substring(1).toLowerCase();
    String? resolvedFont;

    switch (token) {
      case "headline":
        resolvedFont = globalStyles?.fonts?.headline;
        break;
      case "text":
        resolvedFont = globalStyles?.fonts?.text;
        break;
    }

    if (resolvedFont != null) {
      return resolvedFont;
    }

    return fontString;
  }

  String resolveHtmlColorTokens(String html) {
    final colorRegex = RegExp(r'color:\s*(@\w+)');
    return html.replaceAllMapped(colorRegex, (match) {
      final token = match.group(1)!;
      final resolvedColor = resolveColorTokenToColor(token);

      if (resolvedColor != null) {
        final hexString = ColorUtility.colorToHex(resolvedColor);
        final resolved = hexString.startsWith('FF') && hexString.length == 8
            ? '#${hexString.substring(2)}'
            : hexString;
        return "color: $resolved";
      }

      return "color: $token";
    });
  }

  String resolveHtmlFontTokens(String html) {
    final fontRegex = RegExp(r'font-family:\s*(@\w+)');
    return html.replaceAllMapped(fontRegex, (match) {
      final token = match.group(1)!;
      final resolved = resolveFontToken(token);
      return "font-family: $resolved";
    });
  }

  String resolveHtmlTokens(String html) {
    String result = resolveHtmlColorTokens(html);
    result = resolveHtmlFontTokens(result);
    return result;
  }
}
