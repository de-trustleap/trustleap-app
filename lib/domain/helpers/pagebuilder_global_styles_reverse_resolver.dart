import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';

class PagebuilderGlobalStylesReverseResolver {
  final PageBuilderGlobalStyles globalStyles;

  PagebuilderGlobalStylesReverseResolver(this.globalStyles);

  /// Replaces hex colors that match global styles with their token equivalents
  Map<String, dynamic> applyTokensToMap(Map<String, dynamic> map) {
    final result = <String, dynamic>{};

    for (final entry in map.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is String && _isHexColor(value)) {
        result[key] = _reverseResolveColor(key, value);
      } else if (value is Map<String, dynamic>) {
        result[key] = applyTokensToMap(value);
      } else if (value is List) {
        result[key] = _applyTokensToList(value);
      } else {
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

    if (lowerFieldName != "color" &&
        lowerFieldName != "backgroundcolor" &&
        !lowerFieldName.contains("color")) {
      return hexColor;
    }

    String normalizedHex = hexColor.replaceAll("#", "").toUpperCase();
    if (normalizedHex.length == 6) {
      normalizedHex = "FF$normalizedHex";
    }

    final colors = globalStyles.colors;
    if (colors == null) return hexColor;

    // Check each global color (convert Color to 8-digit hex for comparison)
    if (colors.primary != null &&
        ColorUtility.colorToHex(colors.primary!).toUpperCase() ==
            normalizedHex) {
      return "@primary";
    }
    if (colors.secondary != null &&
        ColorUtility.colorToHex(colors.secondary!).toUpperCase() ==
            normalizedHex) {
      return "@secondary";
    }
    if (colors.tertiary != null &&
        ColorUtility.colorToHex(colors.tertiary!).toUpperCase() ==
            normalizedHex) {
      return "@tertiary";
    }
    if (colors.background != null &&
        ColorUtility.colorToHex(colors.background!).toUpperCase() ==
            normalizedHex) {
      return "@background";
    }
    if (colors.surface != null &&
        ColorUtility.colorToHex(colors.surface!).toUpperCase() ==
            normalizedHex) {
      return "@surface";
    }
    return hexColor;
  }
}
