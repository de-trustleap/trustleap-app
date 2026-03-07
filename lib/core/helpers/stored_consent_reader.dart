import 'dart:convert';

import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/consent/domain/consent_local_storage.dart';

class StoredConsentReader {
  static const String _localStorageConsentKey = 'cookie_consent_preferences';

  static bool hasConsent(ConsentCategory category) {
    if (category == ConsentCategory.necessary) {
      return true;
    }

    try {
      final consentJson = ConsentLocalStorage.getItem(_localStorageConsentKey);
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
