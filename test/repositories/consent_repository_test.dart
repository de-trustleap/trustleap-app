// ignore_for_file: type=lint
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/consent/domain/consent_preference.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late MockConsentRepository mockConsentRepo;

  setUp(() {
    mockConsentRepo = MockConsentRepository();
  });

  group("ConsentRepository_HasConsentDecision", () {
    test("should return true when user has made a consent decision", () {
      // Given
      const expectedResult = true;
      when(mockConsentRepo.hasConsentDecision()).thenReturn(true);
      // When
      final result = mockConsentRepo.hasConsentDecision();
      // Then
      verify(mockConsentRepo.hasConsentDecision());
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockConsentRepo);
    });

    test("should return false when user has not made a consent decision", () {
      // Given
      const expectedResult = false;
      when(mockConsentRepo.hasConsentDecision()).thenReturn(false);
      // When
      final result = mockConsentRepo.hasConsentDecision();
      // Then
      verify(mockConsentRepo.hasConsentDecision());
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockConsentRepo);
    });
  });

  group("ConsentRepository_GetConsentPreferences", () {
    test("should return consent preferences when they exist", () {
      // Given
      final testPreference = ConsentPreference(
        categories: {ConsentCategory.necessary, ConsentCategory.statistics},
        method: ConsentMethod.acceptAll,
        policyVersion: '1.0',
        timestamp: DateTime.parse('2024-01-01T00:00:00.000Z'),
      );
      when(mockConsentRepo.getConsentPreferences()).thenReturn(testPreference);
      // When
      final result = mockConsentRepo.getConsentPreferences();
      // Then
      verify(mockConsentRepo.getConsentPreferences());
      expect(result, testPreference);
      verifyNoMoreInteractions(mockConsentRepo);
    });

    test("should return initial preferences when no consent exists", () {
      // Given
      final testPreference = ConsentPreference.initial();
      when(mockConsentRepo.getConsentPreferences()).thenReturn(testPreference);
      // When
      final result = mockConsentRepo.getConsentPreferences();
      // Then
      verify(mockConsentRepo.getConsentPreferences());
      expect(result.categories, {ConsentCategory.necessary});
      expect(result.method, ConsentMethod.rejectAll);
      verifyNoMoreInteractions(mockConsentRepo);
    });

    test("should return acceptAll preferences correctly", () {
      // Given
      final testPreference = ConsentPreference.acceptAll('1.0');
      when(mockConsentRepo.getConsentPreferences()).thenReturn(testPreference);
      // When
      final result = mockConsentRepo.getConsentPreferences();
      // Then
      verify(mockConsentRepo.getConsentPreferences());
      expect(result.categories, ConsentCategory.values.toSet());
      expect(result.method, ConsentMethod.acceptAll);
      verifyNoMoreInteractions(mockConsentRepo);
    });

    test("should return rejectAll preferences correctly", () {
      // Given
      final testPreference = ConsentPreference.rejectAll('1.0');
      when(mockConsentRepo.getConsentPreferences()).thenReturn(testPreference);
      // When
      final result = mockConsentRepo.getConsentPreferences();
      // Then
      verify(mockConsentRepo.getConsentPreferences());
      expect(result.categories, {ConsentCategory.necessary});
      expect(result.method, ConsentMethod.rejectAll);
      verifyNoMoreInteractions(mockConsentRepo);
    });

    test("should return custom preferences correctly", () {
      // Given
      final testPreference = ConsentPreference(
        categories: {ConsentCategory.necessary, ConsentCategory.statistics},
        method: ConsentMethod.custom,
        policyVersion: '1.0',
        timestamp: DateTime.now(),
      );
      when(mockConsentRepo.getConsentPreferences()).thenReturn(testPreference);
      // When
      final result = mockConsentRepo.getConsentPreferences();
      // Then
      verify(mockConsentRepo.getConsentPreferences());
      expect(result.categories,
          {ConsentCategory.necessary, ConsentCategory.statistics});
      expect(result.method, ConsentMethod.custom);
      verifyNoMoreInteractions(mockConsentRepo);
    });
  });

  group("ConsentRepository_SaveConsentPreference", () {
    final testPreference = ConsentPreference(
      categories: {ConsentCategory.necessary, ConsentCategory.statistics},
      method: ConsentMethod.acceptAll,
      policyVersion: '1.0',
      timestamp: DateTime.parse('2024-01-01T00:00:00.000Z'),
    );

    test(
        "should return unit when consent preference has been saved successfully",
        () async {
      // Given
      final expectedResult = right(unit);
      when(mockConsentRepo.saveConsentPreference(testPreference))
          .thenAnswer((_) async => right(unit));
      // When
      final result = await mockConsentRepo.saveConsentPreference(testPreference);
      // Then
      verify(mockConsentRepo.saveConsentPreference(testPreference));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockConsentRepo);
    });

    test("should return BackendFailure when save has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockConsentRepo.saveConsentPreference(testPreference))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockConsentRepo.saveConsentPreference(testPreference);
      // Then
      verify(mockConsentRepo.saveConsentPreference(testPreference));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockConsentRepo);
    });

    test("should save acceptAll preference successfully", () async {
      // Given
      final acceptAllPreference = ConsentPreference.acceptAll('1.0');
      final expectedResult = right(unit);
      when(mockConsentRepo.saveConsentPreference(acceptAllPreference))
          .thenAnswer((_) async => right(unit));
      // When
      final result =
          await mockConsentRepo.saveConsentPreference(acceptAllPreference);
      // Then
      verify(mockConsentRepo.saveConsentPreference(acceptAllPreference));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockConsentRepo);
    });

    test("should save rejectAll preference successfully", () async {
      // Given
      final rejectAllPreference = ConsentPreference.rejectAll('1.0');
      final expectedResult = right(unit);
      when(mockConsentRepo.saveConsentPreference(rejectAllPreference))
          .thenAnswer((_) async => right(unit));
      // When
      final result =
          await mockConsentRepo.saveConsentPreference(rejectAllPreference);
      // Then
      verify(mockConsentRepo.saveConsentPreference(rejectAllPreference));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockConsentRepo);
    });

    test("should save custom preference successfully", () async {
      // Given
      final customPreference = ConsentPreference(
        categories: {ConsentCategory.necessary, ConsentCategory.statistics},
        method: ConsentMethod.custom,
        policyVersion: '1.0',
        timestamp: DateTime.now(),
      );
      final expectedResult = right(unit);
      when(mockConsentRepo.saveConsentPreference(customPreference))
          .thenAnswer((_) async => right(unit));
      // When
      final result =
          await mockConsentRepo.saveConsentPreference(customPreference);
      // Then
      verify(mockConsentRepo.saveConsentPreference(customPreference));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockConsentRepo);
    });

    test("should handle different policy versions correctly", () async {
      // Given
      final preferenceV1 = ConsentPreference.acceptAll('1.0');
      final preferenceV2 = ConsentPreference.acceptAll('2.0');

      when(mockConsentRepo.saveConsentPreference(preferenceV1))
          .thenAnswer((_) async => right(unit));
      when(mockConsentRepo.saveConsentPreference(preferenceV2))
          .thenAnswer((_) async => right(unit));

      // When
      final result1 = await mockConsentRepo.saveConsentPreference(preferenceV1);
      final result2 = await mockConsentRepo.saveConsentPreference(preferenceV2);

      // Then
      verify(mockConsentRepo.saveConsentPreference(preferenceV1));
      verify(mockConsentRepo.saveConsentPreference(preferenceV2));
      expect(result1, right(unit));
      expect(result2, right(unit));
      verifyNoMoreInteractions(mockConsentRepo);
    });
  });

  group("ConsentRepository_HasConsent", () {
    test("should return true for necessary category always", () {
      // Given
      const expectedResult = true;
      when(mockConsentRepo.hasConsent(ConsentCategory.necessary))
          .thenReturn(true);
      // When
      final result = mockConsentRepo.hasConsent(ConsentCategory.necessary);
      // Then
      verify(mockConsentRepo.hasConsent(ConsentCategory.necessary));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockConsentRepo);
    });

    test("should return true when user has consented to statistics", () {
      // Given
      const expectedResult = true;
      when(mockConsentRepo.hasConsent(ConsentCategory.statistics))
          .thenReturn(true);
      // When
      final result = mockConsentRepo.hasConsent(ConsentCategory.statistics);
      // Then
      verify(mockConsentRepo.hasConsent(ConsentCategory.statistics));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockConsentRepo);
    });

    test("should return false when user has not consented to statistics", () {
      // Given
      const expectedResult = false;
      when(mockConsentRepo.hasConsent(ConsentCategory.statistics))
          .thenReturn(false);
      // When
      final result = mockConsentRepo.hasConsent(ConsentCategory.statistics);
      // Then
      verify(mockConsentRepo.hasConsent(ConsentCategory.statistics));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockConsentRepo);
    });

    test("should handle multiple category checks correctly", () {
      // Given
      when(mockConsentRepo.hasConsent(ConsentCategory.necessary))
          .thenReturn(true);
      when(mockConsentRepo.hasConsent(ConsentCategory.statistics))
          .thenReturn(true);

      // When
      final hasNecessary =
          mockConsentRepo.hasConsent(ConsentCategory.necessary);
      final hasStatistics =
          mockConsentRepo.hasConsent(ConsentCategory.statistics);

      // Then
      verify(mockConsentRepo.hasConsent(ConsentCategory.necessary));
      verify(mockConsentRepo.hasConsent(ConsentCategory.statistics));
      expect(hasNecessary, true);
      expect(hasStatistics, true);
      verifyNoMoreInteractions(mockConsentRepo);
    });
  });

  group("ConsentRepository_RevokeConsent", () {
    const testPolicyVersion = '1.0';

    test("should return unit when consent has been revoked successfully",
        () async {
      // Given
      final expectedResult = right(unit);
      when(mockConsentRepo.revokeConsent(testPolicyVersion))
          .thenAnswer((_) async => right(unit));
      // When
      final result = await mockConsentRepo.revokeConsent(testPolicyVersion);
      // Then
      verify(mockConsentRepo.revokeConsent(testPolicyVersion));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockConsentRepo);
    });

    test("should return BackendFailure when revoke has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockConsentRepo.revokeConsent(testPolicyVersion))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockConsentRepo.revokeConsent(testPolicyVersion);
      // Then
      verify(mockConsentRepo.revokeConsent(testPolicyVersion));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockConsentRepo);
    });

    test("should handle different policy versions correctly", () async {
      // Given
      const policyV1 = '1.0';
      const policyV2 = '2.0';

      when(mockConsentRepo.revokeConsent(policyV1))
          .thenAnswer((_) async => right(unit));
      when(mockConsentRepo.revokeConsent(policyV2))
          .thenAnswer((_) async => right(unit));

      // When
      final result1 = await mockConsentRepo.revokeConsent(policyV1);
      final result2 = await mockConsentRepo.revokeConsent(policyV2);

      // Then
      verify(mockConsentRepo.revokeConsent(policyV1));
      verify(mockConsentRepo.revokeConsent(policyV2));
      expect(result1, right(unit));
      expect(result2, right(unit));
      verifyNoMoreInteractions(mockConsentRepo);
    });

    test("should return PermissionDeniedFailure when access is denied",
        () async {
      // Given
      final expectedResult = left(PermissionDeniedFailure());
      when(mockConsentRepo.revokeConsent(testPolicyVersion))
          .thenAnswer((_) async => left(PermissionDeniedFailure()));
      // When
      final result = await mockConsentRepo.revokeConsent(testPolicyVersion);
      // Then
      verify(mockConsentRepo.revokeConsent(testPolicyVersion));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockConsentRepo);
    });
  });

  group("ConsentRepository_IsConsentOutdated", () {
    const currentPolicyVersion = '2.0';

    test("should return true when consent is outdated", () {
      // Given
      const expectedResult = true;
      when(mockConsentRepo.isConsentOutdated(currentPolicyVersion))
          .thenReturn(true);
      // When
      final result = mockConsentRepo.isConsentOutdated(currentPolicyVersion);
      // Then
      verify(mockConsentRepo.isConsentOutdated(currentPolicyVersion));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockConsentRepo);
    });

    test("should return false when consent is up to date", () {
      // Given
      const expectedResult = false;
      when(mockConsentRepo.isConsentOutdated(currentPolicyVersion))
          .thenReturn(false);
      // When
      final result = mockConsentRepo.isConsentOutdated(currentPolicyVersion);
      // Then
      verify(mockConsentRepo.isConsentOutdated(currentPolicyVersion));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockConsentRepo);
    });

    test("should handle different policy versions correctly", () {
      // Given
      const policyV1 = '1.0';
      const policyV2 = '2.0';
      const policyV3 = '3.0';

      when(mockConsentRepo.isConsentOutdated(policyV1)).thenReturn(true);
      when(mockConsentRepo.isConsentOutdated(policyV2)).thenReturn(false);
      when(mockConsentRepo.isConsentOutdated(policyV3)).thenReturn(true);

      // When
      final result1 = mockConsentRepo.isConsentOutdated(policyV1);
      final result2 = mockConsentRepo.isConsentOutdated(policyV2);
      final result3 = mockConsentRepo.isConsentOutdated(policyV3);

      // Then
      verify(mockConsentRepo.isConsentOutdated(policyV1));
      verify(mockConsentRepo.isConsentOutdated(policyV2));
      verify(mockConsentRepo.isConsentOutdated(policyV3));
      expect(result1, true);
      expect(result2, false);
      expect(result3, true);
      verifyNoMoreInteractions(mockConsentRepo);
    });

    test("should compare version strings correctly", () {
      // Given
      when(mockConsentRepo.isConsentOutdated('1.0')).thenReturn(true);
      when(mockConsentRepo.isConsentOutdated('2.0')).thenReturn(false);

      // When
      final isOutdatedV1 = mockConsentRepo.isConsentOutdated('1.0');
      final isOutdatedV2 = mockConsentRepo.isConsentOutdated('2.0');

      // Then
      verify(mockConsentRepo.isConsentOutdated('1.0'));
      verify(mockConsentRepo.isConsentOutdated('2.0'));
      expect(isOutdatedV1, true);
      expect(isOutdatedV2, false);
      verifyNoMoreInteractions(mockConsentRepo);
    });
  });
}
