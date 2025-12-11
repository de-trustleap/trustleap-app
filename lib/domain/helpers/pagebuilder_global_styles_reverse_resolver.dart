import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';

/// Reverses token resolution - converts resolved hex colors back to tokens
/// This should be applied BEFORE saving to Firestore to preserve tokens
class PagebuilderGlobalStylesReverseResolver {
  final PageBuilderGlobalStyles globalStyles;

  PagebuilderGlobalStylesReverseResolver(this.globalStyles);

  /// Recursively applies tokens to a Map structure
  /// Replaces hex colors that match global styles with their token equivalents
  Map<String, dynamic> applyTokensToMap(Map<String, dynamic> map) {
    final result = <String, dynamic>{};

    for (final entry in map.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is String && _isHexColor(value)) {
        // This might be a resolved color - try to reverse it
        result[key] = _reverseResolveColor(key, value);
      } else if (value is Map<String, dynamic>) {
        // Recursively apply tokens to nested maps
        result[key] = applyTokensToMap(value);
      } else if (value is List) {
        // Recursively apply tokens to lists
        result[key] = _applyTokensToList(value);
      } else {
        // Keep value as-is
        result[key] = value;
      }
    }

    return result;
  }

  /// Applies tokens to a list (could contain maps or other values)
  List<dynamic> _applyTokensToList(List<dynamic> list) {
    return list.map((item) {
      if (item is Map<String, dynamic>) {
        return applyTokensToMap(item);
      } else if (item is List) {
        return _applyTokensToList(item);
      } else {
        return item;
      }
    }).toList();
  }

  /// Checks if a string is a hex color (8 or 6 digits, optionally with #)
  bool _isHexColor(String value) {
    if (value.startsWith('#')) {
      return value.length == 7 || value.length == 9;
    }
    return value.length == 6 || value.length == 8;
  }

  /// Tries to reverse resolve a color hex string to a token
  /// Returns the token if found, otherwise returns the original hex
  String _reverseResolveColor(String fieldName, String hexColor) {
    final lowerFieldName = fieldName.toLowerCase();

    // Only try to reverse resolve if this is a color field
    if (lowerFieldName != 'color' &&
        lowerFieldName != 'backgroundcolor' &&
        !lowerFieldName.contains('color')) {
      return hexColor;
    }

    // Normalize hex color (remove # if present, ensure 8 digits with FF alpha)
    String normalizedHex = hexColor.replaceAll('#', '').toUpperCase();
    if (normalizedHex.length == 6) {
      normalizedHex = 'FF$normalizedHex'; // Add alpha if missing
    }

    // Try to match with global style colors
    final colors = globalStyles.colors;
    if (colors == null) return hexColor;

    // Check each global color (convert Color to 8-digit hex for comparison)
    if (colors.primary != null &&
        ColorUtility.colorToHex(colors.primary!).toUpperCase() == normalizedHex) {
      print('🔄 [ReverseResolver] $fieldName: $hexColor -> @primary');
      return '@primary';
    }
    if (colors.secondary != null &&
        ColorUtility.colorToHex(colors.secondary!).toUpperCase() == normalizedHex) {
      print('🔄 [ReverseResolver] $fieldName: $hexColor -> @secondary');
      return '@secondary';
    }
    if (colors.tertiary != null &&
        ColorUtility.colorToHex(colors.tertiary!).toUpperCase() == normalizedHex) {
      print('🔄 [ReverseResolver] $fieldName: $hexColor -> @tertiary');
      return '@tertiary';
    }
    if (colors.background != null &&
        ColorUtility.colorToHex(colors.background!).toUpperCase() == normalizedHex) {
      print('🔄 [ReverseResolver] $fieldName: $hexColor -> @background');
      return '@background';
    }
    if (colors.surface != null &&
        ColorUtility.colorToHex(colors.surface!).toUpperCase() == normalizedHex) {
      print('🔄 [ReverseResolver] $fieldName: $hexColor -> @surface');
      return '@surface';
    }

    // No match found - return original hex
    print('🔄 [ReverseResolver] $fieldName: $hexColor -> (no match, keeping hex)');
    return hexColor;
  }
}
