import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';

/// Resolves all global style tokens (like @primary, @headline) in a Map
/// This should be applied to the raw Firestore data BEFORE parsing to Models
class PagebuilderGlobalStylesTokenResolver {
  final PageBuilderGlobalStyles? globalStyles;

  PagebuilderGlobalStylesTokenResolver(this.globalStyles);

  /// Recursively resolves all tokens in a Map structure
  /// Returns a new Map with all tokens replaced by their actual values
  Map<String, dynamic> resolveTokensInMap(Map<String, dynamic> map) {
    final result = <String, dynamic>{};

    for (final entry in map.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is String && value.startsWith('@')) {
        // This is a token - resolve it
        result[key] = _resolveToken(key, value);
      } else if (value is Map<String, dynamic>) {
        // Recursively resolve nested maps
        result[key] = resolveTokensInMap(value);
      } else if (value is List) {
        // Recursively resolve lists
        result[key] = _resolveTokensInList(value);
      } else {
        // Keep value as-is
        result[key] = value;
      }
    }

    return result;
  }

  /// Resolves tokens in a list (could contain maps or other values)
  List<dynamic> _resolveTokensInList(List<dynamic> list) {
    return list.map((item) {
      if (item is Map<String, dynamic>) {
        return resolveTokensInMap(item);
      } else if (item is List) {
        return _resolveTokensInList(item);
      } else if (item is String && item.startsWith('@')) {
        // This shouldn't typically happen, but handle it
        return item; // Can't resolve without context of what type it should be
      } else {
        return item;
      }
    }).toList();
  }

  /// Resolves a single token based on the field name context
  /// Returns the resolved hex string for colors, or font family for fonts
  String _resolveToken(String fieldName, String token) {
    final lowerFieldName = fieldName.toLowerCase();

    // Check if this is a color field
    if (lowerFieldName == 'color' ||
        lowerFieldName == 'backgroundcolor' ||
        lowerFieldName.contains('color')) {
      return _resolveColorToken(token);
    }

    // Check if this is a font field
    if (lowerFieldName == 'fontfamily' ||
        lowerFieldName.contains('font')) {
      return _resolveFontToken(token);
    }

    // Unknown context - return original token
    return token;
  }

  /// Resolves a color token to a hex string (8-digit ARGB)
  String _resolveColorToken(String token) {
    if (globalStyles == null) return token;

    final resolvedColor = globalStyles!.resolveColorReference(token);
    if (resolvedColor != null) {
      return ColorUtility.colorToHex(resolvedColor);
    }

    return token;
  }

  /// Resolves a font token to a font family string
  String _resolveFontToken(String token) {
    if (globalStyles == null) return token;

    final resolvedFont = globalStyles!.resolveFontReference(token);
    if (resolvedFont != null) {
      return resolvedFont;
    }

    return token;
  }
}
