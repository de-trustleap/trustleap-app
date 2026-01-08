import 'dart:convert';
import 'package:finanzbegleiter/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

/// Reads consent status from localStorage
class StoredConsentReader {
  static const String _localStorageConsentKey = 'cookie_consent_preferences';

  /// Check if user has given consent for a specific category
  static bool hasConsent(ConsentCategory category) {
    if (!kIsWeb) {
      // Always enabled on non-web platforms
      return true;
    }

    if (category == ConsentCategory.necessary) {
      // Necessary cookies are always enabled
      return true;
    }

    try {
      final consentJson =
          web.window.localStorage.getItem(_localStorageConsentKey);
      if (consentJson == null) {
        return false;
      }

      final consent = jsonDecode(consentJson) as Map<String, dynamic>;
      final categories =
          (consent['categories'] as List<dynamic>?)?.cast<String>() ?? [];
      return categories.contains(category.name);
    } catch (e) {
      return false;
    }
  }

  /// Check if user has given consent for statistics (Sentry)
  static bool hasStatisticsConsent() {
    return hasConsent(ConsentCategory.statistics);
  }
}
