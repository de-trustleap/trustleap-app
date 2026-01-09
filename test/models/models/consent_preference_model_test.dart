import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/consent_preference.dart';
import 'package:finanzbegleiter/infrastructure/models/consent_preference_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("ConsentPreferenceModel_CopyWith", () {
    test(
        "set policyVersion with copyWith should change policyVersion for resulting object",
        () {
      // Given
      const model = ConsentPreferenceModel(
        categories: ['necessary', 'statistics'],
        method: 'acceptAll',
        policyVersion: '1.0',
        timestamp: '2024-01-01T00:00:00.000Z',
      );
      const expectedResult = ConsentPreferenceModel(
        categories: ['necessary', 'statistics'],
        method: 'acceptAll',
        policyVersion: '2.0',
        timestamp: '2024-01-01T00:00:00.000Z',
      );
      // When
      final result = model.copyWith(policyVersion: '2.0');
      // Then
      expect(expectedResult, result);
    });

    test("set categories with copyWith should change categories for resulting object",
        () {
      // Given
      const model = ConsentPreferenceModel(
        categories: ['necessary'],
        method: 'rejectAll',
        policyVersion: '1.0',
        timestamp: '2024-01-01T00:00:00.000Z',
      );
      const expectedResult = ConsentPreferenceModel(
        categories: ['necessary', 'statistics'],
        method: 'rejectAll',
        policyVersion: '1.0',
        timestamp: '2024-01-01T00:00:00.000Z',
      );
      // When
      final result = model.copyWith(categories: ['necessary', 'statistics']);
      // Then
      expect(expectedResult, result);
    });
  });

  group("ConsentPreferenceModel_ToStorageMap", () {
    test("check if model is successfully converted to a storage map", () {
      // Given
      const model = ConsentPreferenceModel(
        categories: ['necessary', 'statistics'],
        method: 'acceptAll',
        policyVersion: '1.0',
        timestamp: '2024-01-01T00:00:00.000Z',
      );
      final expectedResult = {
        'categories': ['necessary', 'statistics'],
        'method': 'acceptAll',
        'policyVersion': '1.0',
        'timestamp': '2024-01-01T00:00:00.000Z',
      };
      // When
      final result = model.toStorageMap();
      // Then
      expect(expectedResult, result);
    });
  });

  group("ConsentPreferenceModel_ToFirestoreMap", () {
    test("check if model is successfully converted to a firestore map", () {
      // Given
      const model = ConsentPreferenceModel(
        categories: ['necessary', 'statistics'],
        method: 'acceptAll',
        policyVersion: '1.0',
        timestamp: '2024-01-01T00:00:00.000Z',
      );
      // When
      final result = model.toFirestoreMap();
      // Then
      expect(result['categories'], ['necessary', 'statistics']);
      expect(result['method'], 'acceptAll');
      expect(result['policyVersion'], '1.0');
      expect(result['timestamp'], isA<FieldValue>());
    });
  });

  group("ConsentPreferenceModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        'categories': ['necessary', 'statistics'],
        'method': 'acceptAll',
        'policyVersion': '1.0',
        'timestamp': '2024-01-01T00:00:00.000Z',
      };
      const expectedResult = ConsentPreferenceModel(
        categories: ['necessary', 'statistics'],
        method: 'acceptAll',
        policyVersion: '1.0',
        timestamp: '2024-01-01T00:00:00.000Z',
      );
      // When
      final result = ConsentPreferenceModel.fromMap(map);
      // Then
      expect(expectedResult, result);
    });

    test("check if fromMap handles list correctly", () {
      // Given
      final map = {
        'categories': ['necessary'],
        'method': 'rejectAll',
        'policyVersion': '1.0',
        'timestamp': '2024-01-01T00:00:00.000Z',
      };
      const expectedResult = ConsentPreferenceModel(
        categories: ['necessary'],
        method: 'rejectAll',
        policyVersion: '1.0',
        timestamp: '2024-01-01T00:00:00.000Z',
      );
      // When
      final result = ConsentPreferenceModel.fromMap(map);
      // Then
      expect(expectedResult, result);
    });
  });

  group("ConsentPreferenceModel_FromFirestore", () {
    test("check if fromFirestore successfully converts map with Timestamp", () {
      // Given
      final map = {
        'categories': ['necessary', 'statistics'],
        'method': 'custom',
        'policyVersion': '1.0',
        'timestamp': Timestamp(1704067200, 0),
      };
      final expectedResult = ConsentPreferenceModel(
        categories: const ['necessary', 'statistics'],
        method: 'custom',
        policyVersion: '1.0',
        timestamp: Timestamp(1704067200, 0),
      );
      // When
      final result = ConsentPreferenceModel.fromFirestore(map);
      // Then
      expect(expectedResult, result);
    });
  });

  group("ConsentPreferenceModel_ToDomain", () {
    test("check if conversion from ConsentPreferenceModel to ConsentPreference works with String timestamp",
        () {
      // Given
      const model = ConsentPreferenceModel(
        categories: ['necessary', 'statistics'],
        method: 'acceptAll',
        policyVersion: '1.0',
        timestamp: '2024-01-01T00:00:00.000Z',
      );
      final expectedResult = ConsentPreference(
        categories: {ConsentCategory.necessary, ConsentCategory.statistics},
        method: ConsentMethod.acceptAll,
        policyVersion: '1.0',
        timestamp: DateTime.parse('2024-01-01T00:00:00.000Z'),
      );
      // When
      final result = model.toDomain();
      // Then
      expect(expectedResult.categories, result.categories);
      expect(expectedResult.method, result.method);
      expect(expectedResult.policyVersion, result.policyVersion);
      expect(expectedResult.timestamp, result.timestamp);
    });

    test("check if conversion handles Firestore Timestamp correctly", () {
      // Given
      final model = ConsentPreferenceModel(
        categories: const ['necessary'],
        method: 'rejectAll',
        policyVersion: '1.0',
        timestamp: Timestamp(1704067200, 0),
      );
      final expectedResult = ConsentPreference(
        categories: {ConsentCategory.necessary},
        method: ConsentMethod.rejectAll,
        policyVersion: '1.0',
        timestamp: DateTime.fromMillisecondsSinceEpoch(1704067200000),
      );
      // When
      final result = model.toDomain();
      // Then
      expect(expectedResult.categories, result.categories);
      expect(expectedResult.method, result.method);
      expect(expectedResult.policyVersion, result.policyVersion);
      expect(expectedResult.timestamp, result.timestamp);
    });

    test("check if conversion handles int timestamp correctly", () {
      // Given
      const model = ConsentPreferenceModel(
        categories: ['necessary', 'statistics'],
        method: 'custom',
        policyVersion: '1.0',
        timestamp: 1704067200000,
      );
      final expectedResult = ConsentPreference(
        categories: {ConsentCategory.necessary, ConsentCategory.statistics},
        method: ConsentMethod.custom,
        policyVersion: '1.0',
        timestamp: DateTime.fromMillisecondsSinceEpoch(1704067200000),
      );
      // When
      final result = model.toDomain();
      // Then
      expect(expectedResult.categories, result.categories);
      expect(expectedResult.method, result.method);
      expect(expectedResult.policyVersion, result.policyVersion);
      expect(expectedResult.timestamp, result.timestamp);
    });

    test("check if conversion defaults to DateTime.now() for invalid timestamp",
        () {
      // Given
      const model = ConsentPreferenceModel(
        categories: ['necessary'],
        method: 'acceptAll',
        policyVersion: '1.0',
        timestamp: 'invalid',
      );
      final now = DateTime.now();
      // When
      final result = model.toDomain();
      // Then
      expect(result.categories, {ConsentCategory.necessary});
      expect(result.method, ConsentMethod.acceptAll);
      expect(result.policyVersion, '1.0');
      expect(
          result.timestamp.difference(now).inSeconds < 5, true); // Within 5s
    });
  });

  group("ConsentPreferenceModel_FromDomain", () {
    test("check if conversion from ConsentPreference to ConsentPreferenceModel works",
        () {
      // Given
      final timestamp = DateTime.parse('2024-01-01T00:00:00.000Z');
      final consent = ConsentPreference(
        categories: {ConsentCategory.necessary, ConsentCategory.statistics},
        method: ConsentMethod.acceptAll,
        policyVersion: '1.0',
        timestamp: timestamp,
      );
      final expectedResult = ConsentPreferenceModel(
        categories: const ['necessary', 'statistics'],
        method: 'acceptAll',
        policyVersion: '1.0',
        timestamp: timestamp.toIso8601String(),
      );
      // When
      final result = ConsentPreferenceModel.fromDomain(consent);
      // Then
      expect(expectedResult, result);
    });

    test("check if conversion handles single category correctly", () {
      // Given
      final timestamp = DateTime.parse('2024-01-01T00:00:00.000Z');
      final consent = ConsentPreference(
        categories: {ConsentCategory.necessary},
        method: ConsentMethod.rejectAll,
        policyVersion: '1.0',
        timestamp: timestamp,
      );
      final expectedResult = ConsentPreferenceModel(
        categories: const ['necessary'],
        method: 'rejectAll',
        policyVersion: '1.0',
        timestamp: timestamp.toIso8601String(),
      );
      // When
      final result = ConsentPreferenceModel.fromDomain(consent);
      // Then
      expect(expectedResult, result);
    });

    test("check if conversion handles custom method correctly", () {
      // Given
      final timestamp = DateTime.parse('2024-01-01T00:00:00.000Z');
      final consent = ConsentPreference(
        categories: {ConsentCategory.necessary, ConsentCategory.statistics},
        method: ConsentMethod.custom,
        policyVersion: '1.0',
        timestamp: timestamp,
      );
      final expectedResult = ConsentPreferenceModel(
        categories: const ['necessary', 'statistics'],
        method: 'custom',
        policyVersion: '1.0',
        timestamp: timestamp.toIso8601String(),
      );
      // When
      final result = ConsentPreferenceModel.fromDomain(consent);
      // Then
      expect(expectedResult, result);
    });
  });

  group("ConsentPreferenceModel_Props", () {
    test("check if value equality works", () {
      // Given
      const model1 = ConsentPreferenceModel(
        categories: ['necessary', 'statistics'],
        method: 'acceptAll',
        policyVersion: '1.0',
        timestamp: '2024-01-01T00:00:00.000Z',
      );
      const model2 = ConsentPreferenceModel(
        categories: ['necessary', 'statistics'],
        method: 'acceptAll',
        policyVersion: '1.0',
        timestamp: '2024-01-01T00:00:00.000Z',
      );
      // Then
      expect(model1, model2);
    });

    test("check if value inequality works", () {
      // Given
      const model1 = ConsentPreferenceModel(
        categories: ['necessary'],
        method: 'rejectAll',
        policyVersion: '1.0',
        timestamp: '2024-01-01T00:00:00.000Z',
      );
      const model2 = ConsentPreferenceModel(
        categories: ['necessary', 'statistics'],
        method: 'acceptAll',
        policyVersion: '1.0',
        timestamp: '2024-01-01T00:00:00.000Z',
      );
      // Then
      expect(model1 == model2, false);
    });
  });
}
