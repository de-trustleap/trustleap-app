import 'dart:convert';
import 'package:finanzbegleiter/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

class StoredConsentReader {
  static const String _localStorageConsentKey = 'cookie_consent_preferences';

  static bool hasConsent(ConsentCategory category) {
    if (!kIsWeb) {
      return true;
    }

    if (category == ConsentCategory.necessary) {
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

  static bool hasStatisticsConsent() {
    return hasConsent(ConsentCategory.statistics);
  }
}
