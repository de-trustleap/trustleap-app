import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/consent_preference.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("ConsentPreference_CopyWith", () {
    test("set policyVersion with copyWith should change policyVersion for resulting object",
        () {
      // Given
      final timestamp = DateTime.parse('2024-01-01T00:00:00.000Z');
      final preference = ConsentPreference(
        categories: {ConsentCategory.necessary, ConsentCategory.statistics},
        method: ConsentMethod.acceptAll,
        policyVersion: '1.0',
        timestamp: timestamp,
      );
      final expectedResult = ConsentPreference(
        categories: {ConsentCategory.necessary, ConsentCategory.statistics},
        method: ConsentMethod.acceptAll,
        policyVersion: '2.0',
        timestamp: timestamp,
      );
      // When
      final result = preference.copyWith(policyVersion: '2.0');
      // Then
      expect(expectedResult, result);
    });

    test("set categories with copyWith should change categories for resulting object",
        () {
      // Given
      final timestamp = DateTime.parse('2024-01-01T00:00:00.000Z');
      final preference = ConsentPreference(
        categories: {ConsentCategory.necessary},
        method: ConsentMethod.rejectAll,
        policyVersion: '1.0',
        timestamp: timestamp,
      );
      final expectedResult = ConsentPreference(
        categories: {ConsentCategory.necessary, ConsentCategory.statistics},
        method: ConsentMethod.rejectAll,
        policyVersion: '1.0',
        timestamp: timestamp,
      );
      // When
      final result = preference.copyWith(
        categories: {ConsentCategory.necessary, ConsentCategory.statistics},
      );
      // Then
      expect(expectedResult, result);
    });

    test("set method with copyWith should change method for resulting object",
        () {
      // Given
      final timestamp = DateTime.parse('2024-01-01T00:00:00.000Z');
      final preference = ConsentPreference(
        categories: {ConsentCategory.necessary},
        method: ConsentMethod.rejectAll,
        policyVersion: '1.0',
        timestamp: timestamp,
      );
      final expectedResult = ConsentPreference(
        categories: {ConsentCategory.necessary},
        method: ConsentMethod.custom,
        policyVersion: '1.0',
        timestamp: timestamp,
      );
      // When
      final result = preference.copyWith(method: ConsentMethod.custom);
      // Then
      expect(expectedResult, result);
    });
  });

  group("ConsentPreference_Initial", () {
    test("check if initial factory creates correct default preference", () {
      // When
      final result = ConsentPreference.initial();
      // Then
      expect(result.categories, {ConsentCategory.necessary});
      expect(result.method, ConsentMethod.rejectAll);
      expect(result.policyVersion, '1.0');
      expect(result.timestamp.isBefore(DateTime.now().add(Duration(seconds: 1))),
          true);
    });
  });

  group("ConsentPreference_AcceptAll", () {
    test("check if acceptAll factory creates preference with all categories",
        () {
      // When
      final result = ConsentPreference.acceptAll('1.0');
      // Then
      expect(result.categories, ConsentCategory.values.toSet());
      expect(result.method, ConsentMethod.acceptAll);
      expect(result.policyVersion, '1.0');
      expect(result.timestamp.isBefore(DateTime.now().add(Duration(seconds: 1))),
          true);
    });

    test("check if acceptAll uses provided policy version", () {
      // When
      final result = ConsentPreference.acceptAll('2.5');
      // Then
      expect(result.policyVersion, '2.5');
    });
  });

  group("ConsentPreference_RejectAll", () {
    test("check if rejectAll factory creates preference with only necessary category",
        () {
      // When
      final result = ConsentPreference.rejectAll('1.0');
      // Then
      expect(result.categories, {ConsentCategory.necessary});
      expect(result.method, ConsentMethod.rejectAll);
      expect(result.policyVersion, '1.0');
      expect(result.timestamp.isBefore(DateTime.now().add(Duration(seconds: 1))),
          true);
    });

    test("check if rejectAll uses provided policy version", () {
      // When
      final result = ConsentPreference.rejectAll('3.0');
      // Then
      expect(result.policyVersion, '3.0');
    });
  });

  group("ConsentPreference_HasConsent", () {
    test("check if hasConsent returns true for necessary category always", () {
      // Given
      final preference = ConsentPreference(
        categories: {ConsentCategory.necessary},
        method: ConsentMethod.rejectAll,
        policyVersion: '1.0',
        timestamp: DateTime.now(),
      );
      // When
      final result = preference.hasConsent(ConsentCategory.necessary);
      // Then
      expect(result, true);
    });

    test("check if hasConsent returns true for accepted statistics category",
        () {
      // Given
      final preference = ConsentPreference(
        categories: {ConsentCategory.necessary, ConsentCategory.statistics},
        method: ConsentMethod.acceptAll,
        policyVersion: '1.0',
        timestamp: DateTime.now(),
      );
      // When
      final result = preference.hasConsent(ConsentCategory.statistics);
      // Then
      expect(result, true);
    });

    test("check if hasConsent returns false for rejected statistics category",
        () {
      // Given
      final preference = ConsentPreference(
        categories: {ConsentCategory.necessary},
        method: ConsentMethod.rejectAll,
        policyVersion: '1.0',
        timestamp: DateTime.now(),
      );
      // When
      final result = preference.hasConsent(ConsentCategory.statistics);
      // Then
      expect(result, false);
    });

    test("check if hasConsent works with custom consent selection", () {
      // Given
      final preference = ConsentPreference(
        categories: {ConsentCategory.necessary, ConsentCategory.statistics},
        method: ConsentMethod.custom,
        policyVersion: '1.0',
        timestamp: DateTime.now(),
      );
      // When
      final hasStatistics = preference.hasConsent(ConsentCategory.statistics);
      final hasNecessary = preference.hasConsent(ConsentCategory.necessary);
      // Then
      expect(hasStatistics, true);
      expect(hasNecessary, true);
    });
  });

  group("ConsentPreference_Props", () {
    test("check if value equality works", () {
      // Given
      final timestamp = DateTime.parse('2024-01-01T00:00:00.000Z');
      final preference1 = ConsentPreference(
        categories: {ConsentCategory.necessary, ConsentCategory.statistics},
        method: ConsentMethod.acceptAll,
        policyVersion: '1.0',
        timestamp: timestamp,
      );
      final preference2 = ConsentPreference(
        categories: {ConsentCategory.necessary, ConsentCategory.statistics},
        method: ConsentMethod.acceptAll,
        policyVersion: '1.0',
        timestamp: timestamp,
      );
      // Then
      expect(preference1, preference2);
    });

    test("check if value inequality works for different categories", () {
      // Given
      final timestamp = DateTime.parse('2024-01-01T00:00:00.000Z');
      final preference1 = ConsentPreference(
        categories: {ConsentCategory.necessary},
        method: ConsentMethod.rejectAll,
        policyVersion: '1.0',
        timestamp: timestamp,
      );
      final preference2 = ConsentPreference(
        categories: {ConsentCategory.necessary, ConsentCategory.statistics},
        method: ConsentMethod.acceptAll,
        policyVersion: '1.0',
        timestamp: timestamp,
      );
      // Then
      expect(preference1 == preference2, false);
    });

    test("check if value inequality works for different timestamps", () {
      // Given
      final timestamp1 = DateTime.parse('2024-01-01T00:00:00.000Z');
      final timestamp2 = DateTime.parse('2024-01-02T00:00:00.000Z');
      final preference1 = ConsentPreference(
        categories: {ConsentCategory.necessary},
        method: ConsentMethod.rejectAll,
        policyVersion: '1.0',
        timestamp: timestamp1,
      );
      final preference2 = ConsentPreference(
        categories: {ConsentCategory.necessary},
        method: ConsentMethod.rejectAll,
        policyVersion: '1.0',
        timestamp: timestamp2,
      );
      // Then
      expect(preference1 == preference2, false);
    });
  });
}
