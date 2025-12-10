import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:flutter/material.dart';

class PagebuilderGlobalStylesResolver {
  final PageBuilderGlobalStyles? globalStyles;

  PagebuilderGlobalStylesResolver(this.globalStyles);

  /// Resolves a color token string to a Color object
  /// Returns null if no match is found
  Color? resolveColorTokenToColor(String colorToken) {
    if (!colorToken.startsWith('@')) {
      return null;
    }

    final token = colorToken.substring(1).toLowerCase();

    switch (token) {
      case 'primary':
        return globalStyles?.colors?.primary;
      case 'secondary':
        return globalStyles?.colors?.secondary;
      case 'tertiary':
        return globalStyles?.colors?.tertiary;
      case 'background':
        return globalStyles?.colors?.background;
      case 'surface':
        return globalStyles?.colors?.surface;
      default:
        return null;
    }
  }

  /// Resolves color tokens like @primary, @secondary, etc. to actual colors
  /// Returns the original string if no match is found
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

  /// Resolves font tokens like @headline, @text to actual font families
  /// Returns the original string if no match is found
  String resolveFontToken(String fontString) {
    if (!fontString.startsWith('@')) {
      return fontString;
    }

    final token = fontString.substring(1).toLowerCase();
    String? resolvedFont;

    switch (token) {
      case 'headline':
        resolvedFont = globalStyles?.fonts?.headline;
        break;
      case 'text':
        resolvedFont = globalStyles?.fonts?.text;
        break;
    }

    if (resolvedFont != null) {
      return resolvedFont;
    }

    return fontString;
  }

  /// Resolves all color tokens in an HTML string
  /// Returns 6-digit hex if alpha is FF (opaque), otherwise 8-digit hex
  String resolveHtmlColorTokens(String html) {
    // Match color tokens in style attributes: color: @primary
    final colorRegex = RegExp(r'color:\s*(@\w+)');
    return html.replaceAllMapped(colorRegex, (match) {
      final token = match.group(1)!;
      final resolvedColor = resolveColorTokenToColor(token);

      if (resolvedColor != null) {
        final hexString = ColorUtility.colorToHex(resolvedColor);
        // Strip alpha channel if it's FF (fully opaque)
        final resolved = hexString.startsWith('FF') && hexString.length == 8
            ? hexString.substring(2)
            : hexString;
        return 'color: $resolved';
      }

      return 'color: $token';
    });
  }

  /// Resolves all font-family tokens in an HTML string
  String resolveHtmlFontTokens(String html) {
    // Match font-family tokens in style attributes: font-family: @headline
    final fontRegex = RegExp(r'font-family:\s*(@\w+)');
    return html.replaceAllMapped(fontRegex, (match) {
      final token = match.group(1)!;
      final resolved = resolveFontToken(token);
      return 'font-family: $resolved';
    });
  }

  /// Resolves all tokens (colors and fonts) in an HTML string
  String resolveHtmlTokens(String html) {
    String result = resolveHtmlColorTokens(html);
    result = resolveHtmlFontTokens(result);
    return result;
  }
}
