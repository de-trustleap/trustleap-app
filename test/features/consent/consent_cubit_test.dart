// ignore_for_file: type=lint
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/features/consent/application/consent_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/consent/domain/consent_preference.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../mocks.mocks.dart';

void main() {
  late ConsentCubit consentCubit;
  late MockConsentRepository mockConsentRepo;

  setUp(() {
    mockConsentRepo = MockConsentRepository();
    consentCubit = ConsentCubit(mockConsentRepo);
  });

  test("init state should be ConsentInitial", () {
    expect(consentCubit.state, ConsentInitial());
  });

  group("ConsentCubit_CheckConsentStatus", () {
    test("should emit ConsentRequiredState when no consent decision exists",
        () {
      // Given
      final expectedResult = [ConsentRequiredState()];
      when(mockConsentRepo.hasConsentDecision()).thenReturn(false);
      // Then
      expectLater(consentCubit.stream, emitsInOrder(expectedResult));
      consentCubit.checkConsentStatus();
    });

    test("should emit ConsentRequiredState when consent is outdated", () {
      // Given
      final testPreference = ConsentPreference.acceptAll('0.9');
      final expectedResult = [ConsentRequiredState()];
      when(mockConsentRepo.hasConsentDecision()).thenReturn(true);
      when(mockConsentRepo.isConsentOutdated(ConsentCubit.currentPolicyVersion))
          .thenReturn(true);
      when(mockConsentRepo.getConsentPreferences()).thenReturn(testPreference);
      // Then
      expectLater(consentCubit.stream, emitsInOrder(expectedResult));
      consentCubit.checkConsentStatus();
    });

    test("should emit ConsentLoadedState when valid consent exists", () {
      // Given
      final testPreference = ConsentPreference.acceptAll('1.0');
      final expectedResult = [
        ConsentLoadedState(preference: testPreference)
      ];
      when(mockConsentRepo.hasConsentDecision()).thenReturn(true);
      when(mockConsentRepo.isConsentOutdated(ConsentCubit.currentPolicyVersion))
          .thenReturn(false);
      when(mockConsentRepo.getConsentPreferences()).thenReturn(testPreference);
      // Then
      expectLater(consentCubit.stream, emitsInOrder(expectedResult));
      consentCubit.checkConsentStatus();
    });

    test("should only check once even when called multiple times", () {
      // Given
      when(mockConsentRepo.hasConsentDecision()).thenReturn(false);
      // When
      consentCubit.checkConsentStatus();
      consentCubit.checkConsentStatus();
      consentCubit.checkConsentStatus();
      // Then
      verify(mockConsentRepo.hasConsentDecision()).called(1);
      verifyNoMoreInteractions(mockConsentRepo);
    });

    test("should call repository methods in correct order", () {
      // Given
      final testPreference = ConsentPreference.acceptAll('1.0');
      when(mockConsentRepo.hasConsentDecision()).thenReturn(true);
      when(mockConsentRepo.isConsentOutdated(ConsentCubit.currentPolicyVersion))
          .thenReturn(false);
      when(mockConsentRepo.getConsentPreferences()).thenReturn(testPreference);
      // When
      consentCubit.checkConsentStatus();
      // Then
      verifyInOrder([
        mockConsentRepo.hasConsentDecision(),
        mockConsentRepo.isConsentOutdated(ConsentCubit.currentPolicyVersion),
        mockConsentRepo.getConsentPreferences(),
      ]);
    });
  });

  group("ConsentCubit_AcceptAll", () {
    test("should call consent repo when function is called", () async {
      // Given
      when(mockConsentRepo.saveConsentPreference(any))
          .thenAnswer((_) async => right(unit));
      // When
      consentCubit.acceptAll();
      await untilCalled(mockConsentRepo.saveConsentPreference(any));
      // Then
      verify(mockConsentRepo.saveConsentPreference(any));
      verifyNoMoreInteractions(mockConsentRepo);
    });

    test(
        "should emit ConsentSavingState and then ConsentSaveSuccessState when function is called",
        () async {
      // Given
      when(mockConsentRepo.saveConsentPreference(any))
          .thenAnswer((_) async => right(unit));
      // Then
      expectLater(
        consentCubit.stream,
        emitsInOrder([
          ConsentSavingState(),
          isA<ConsentSaveSuccessState>(),
        ]),
      );
      consentCubit.acceptAll();
    });

    test(
        "should emit ConsentSavingState and then ConsentSaveFailureState when save fails",
        () async {
      // Given
      when(mockConsentRepo.saveConsentPreference(any))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(
        consentCubit.stream,
        emitsInOrder([
          ConsentSavingState(),
          ConsentSaveFailureState(failure: BackendFailure()),
        ]),
      );
      consentCubit.acceptAll();
    });

    test("should save preference with all categories", () async {
      // Given
      when(mockConsentRepo.saveConsentPreference(any))
          .thenAnswer((_) async => right(unit));
      // When
      consentCubit.acceptAll();
      await untilCalled(mockConsentRepo.saveConsentPreference(any));
      // Then
      final captured =
          verify(mockConsentRepo.saveConsentPreference(captureAny))
              .captured
              .single as ConsentPreference;
      expect(captured.categories, ConsentCategory.values.toSet());
      expect(captured.method, ConsentMethod.acceptAll);
      expect(captured.policyVersion, ConsentCubit.currentPolicyVersion);
    });

    test("should return PermissionDeniedFailure when access is denied",
        () async {
      // Given
      when(mockConsentRepo.saveConsentPreference(any))
          .thenAnswer((_) async => left(PermissionDeniedFailure()));
      // Then
      expectLater(
        consentCubit.stream,
        emitsInOrder([
          ConsentSavingState(),
          ConsentSaveFailureState(failure: PermissionDeniedFailure()),
        ]),
      );
      consentCubit.acceptAll();
    });
  });

  group("ConsentCubit_RejectAll", () {
    test("should call consent repo when function is called", () async {
      // Given
      when(mockConsentRepo.saveConsentPreference(any))
          .thenAnswer((_) async => right(unit));
      // When
      consentCubit.rejectAll();
      await untilCalled(mockConsentRepo.saveConsentPreference(any));
      // Then
      verify(mockConsentRepo.saveConsentPreference(any));
      verifyNoMoreInteractions(mockConsentRepo);
    });

    test(
        "should emit ConsentSavingState and then ConsentSaveSuccessState when function is called",
        () async {
      // Given
      when(mockConsentRepo.saveConsentPreference(any))
          .thenAnswer((_) async => right(unit));
      // Then
      expectLater(
        consentCubit.stream,
        emitsInOrder([
          ConsentSavingState(),
          isA<ConsentSaveSuccessState>(),
        ]),
      );
      consentCubit.rejectAll();
    });

    test(
        "should emit ConsentSavingState and then ConsentSaveFailureState when save fails",
        () async {
      // Given
      when(mockConsentRepo.saveConsentPreference(any))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(
        consentCubit.stream,
        emitsInOrder([
          ConsentSavingState(),
          ConsentSaveFailureState(failure: BackendFailure()),
        ]),
      );
      consentCubit.rejectAll();
    });

    test("should save preference with only necessary category", () async {
      // Given
      when(mockConsentRepo.saveConsentPreference(any))
          .thenAnswer((_) async => right(unit));
      // When
      consentCubit.rejectAll();
      await untilCalled(mockConsentRepo.saveConsentPreference(any));
      // Then
      final captured =
          verify(mockConsentRepo.saveConsentPreference(captureAny))
              .captured
              .single as ConsentPreference;
      expect(captured.categories, {ConsentCategory.necessary});
      expect(captured.method, ConsentMethod.rejectAll);
      expect(captured.policyVersion, ConsentCubit.currentPolicyVersion);
    });
  });

  group("ConsentCubit_SaveCustomConsent", () {
    final testCategories = {
      ConsentCategory.necessary,
      ConsentCategory.statistics
    };

    test("should call consent repo when function is called", () async {
      // Given
      when(mockConsentRepo.saveConsentPreference(any))
          .thenAnswer((_) async => right(unit));
      // When
      consentCubit.saveCustomConsent(testCategories);
      await untilCalled(mockConsentRepo.saveConsentPreference(any));
      // Then
      verify(mockConsentRepo.saveConsentPreference(any));
      verifyNoMoreInteractions(mockConsentRepo);
    });

    test(
        "should emit ConsentSavingState and then ConsentSaveSuccessState when function is called",
        () async {
      // Given
      when(mockConsentRepo.saveConsentPreference(any))
          .thenAnswer((_) async => right(unit));
      // Then
      expectLater(
        consentCubit.stream,
        emitsInOrder([
          ConsentSavingState(),
          isA<ConsentSaveSuccessState>(),
        ]),
      );
      consentCubit.saveCustomConsent(testCategories);
    });

    test(
        "should emit ConsentSavingState and then ConsentSaveFailureState when save fails",
        () async {
      // Given
      when(mockConsentRepo.saveConsentPreference(any))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(
        consentCubit.stream,
        emitsInOrder([
          ConsentSavingState(),
          ConsentSaveFailureState(failure: BackendFailure()),
        ]),
      );
      consentCubit.saveCustomConsent(testCategories);
    });

    test("should save preference with custom method and specified categories",
        () async {
      // Given
      when(mockConsentRepo.saveConsentPreference(any))
          .thenAnswer((_) async => right(unit));
      // When
      consentCubit.saveCustomConsent(testCategories);
      await untilCalled(mockConsentRepo.saveConsentPreference(any));
      // Then
      final captured =
          verify(mockConsentRepo.saveConsentPreference(captureAny))
              .captured
              .single as ConsentPreference;
      expect(captured.categories, testCategories);
      expect(captured.method, ConsentMethod.custom);
      expect(captured.policyVersion, ConsentCubit.currentPolicyVersion);
    });

    test("should handle only necessary category correctly", () async {
      // Given
      final onlyNecessary = {ConsentCategory.necessary};
      when(mockConsentRepo.saveConsentPreference(any))
          .thenAnswer((_) async => right(unit));
      // When
      consentCubit.saveCustomConsent(onlyNecessary);
      await untilCalled(mockConsentRepo.saveConsentPreference(any));
      // Then
      final captured =
          verify(mockConsentRepo.saveConsentPreference(captureAny))
              .captured
              .single as ConsentPreference;
      expect(captured.categories, onlyNecessary);
      expect(captured.method, ConsentMethod.custom);
    });
  });

  group("ConsentCubit_RevokeConsent", () {
    test("should call consent repo when function is called", () async {
      // Given
      when(mockConsentRepo.revokeConsent(any))
          .thenAnswer((_) async => right(unit));
      // When
      consentCubit.revokeConsent();
      await untilCalled(mockConsentRepo.revokeConsent(any));
      // Then
      verify(mockConsentRepo.revokeConsent(ConsentCubit.currentPolicyVersion));
      verifyNoMoreInteractions(mockConsentRepo);
    });

    test(
        "should emit ConsentSavingState and then ConsentSaveSuccessState when function is called",
        () async {
      // Given
      when(mockConsentRepo.revokeConsent(any))
          .thenAnswer((_) async => right(unit));
      // Then
      expectLater(
        consentCubit.stream,
        emitsInOrder([
          ConsentSavingState(),
          isA<ConsentSaveSuccessState>(),
        ]),
      );
      consentCubit.revokeConsent();
    });

    test(
        "should emit ConsentSavingState and then ConsentSaveFailureState when revoke fails",
        () async {
      // Given
      when(mockConsentRepo.revokeConsent(any))
          .thenAnswer((_) async => left(BackendFailure()));
      // Then
      expectLater(
        consentCubit.stream,
        emitsInOrder([
          ConsentSavingState(),
          ConsentSaveFailureState(failure: BackendFailure()),
        ]),
      );
      consentCubit.revokeConsent();
    });

    test("should pass current policy version to repository", () async {
      // Given
      when(mockConsentRepo.revokeConsent(any))
          .thenAnswer((_) async => right(unit));
      // When
      consentCubit.revokeConsent();
      await untilCalled(mockConsentRepo.revokeConsent(any));
      // Then
      verify(mockConsentRepo.revokeConsent(ConsentCubit.currentPolicyVersion));
    });
  });

  group("ConsentCubit_HasConsent", () {
    test("should return true for necessary category", () {
      // Given
      when(mockConsentRepo.hasConsent(ConsentCategory.necessary))
          .thenReturn(true);
      // When
      final result = consentCubit.hasConsent(ConsentCategory.necessary);
      // Then
      expect(result, true);
      verify(mockConsentRepo.hasConsent(ConsentCategory.necessary));
    });

    test("should return true when statistics consent is given", () {
      // Given
      when(mockConsentRepo.hasConsent(ConsentCategory.statistics))
          .thenReturn(true);
      // When
      final result = consentCubit.hasConsent(ConsentCategory.statistics);
      // Then
      expect(result, true);
      verify(mockConsentRepo.hasConsent(ConsentCategory.statistics));
    });

    test("should return false when statistics consent is not given", () {
      // Given
      when(mockConsentRepo.hasConsent(ConsentCategory.statistics))
          .thenReturn(false);
      // When
      final result = consentCubit.hasConsent(ConsentCategory.statistics);
      // Then
      expect(result, false);
      verify(mockConsentRepo.hasConsent(ConsentCategory.statistics));
    });

    test("should call repository for each check", () {
      // Given
      when(mockConsentRepo.hasConsent(any)).thenReturn(true);
      // When
      consentCubit.hasConsent(ConsentCategory.necessary);
      consentCubit.hasConsent(ConsentCategory.statistics);
      // Then
      verify(mockConsentRepo.hasConsent(ConsentCategory.necessary));
      verify(mockConsentRepo.hasConsent(ConsentCategory.statistics));
      verifyNoMoreInteractions(mockConsentRepo);
    });
  });

  group("ConsentCubit_GetCurrentPreferences", () {
    test("should return current preferences from repository", () {
      // Given
      final testPreference = ConsentPreference.acceptAll('1.0');
      when(mockConsentRepo.getConsentPreferences()).thenReturn(testPreference);
      // When
      final result = consentCubit.getCurrentPreferences();
      // Then
      expect(result, testPreference);
      verify(mockConsentRepo.getConsentPreferences());
    });

    test("should return preferences with all categories when acceptAll", () {
      // Given
      final testPreference = ConsentPreference.acceptAll('1.0');
      when(mockConsentRepo.getConsentPreferences()).thenReturn(testPreference);
      // When
      final result = consentCubit.getCurrentPreferences();
      // Then
      expect(result.categories, ConsentCategory.values.toSet());
      expect(result.method, ConsentMethod.acceptAll);
    });

    test("should return preferences with only necessary when rejectAll", () {
      // Given
      final testPreference = ConsentPreference.rejectAll('1.0');
      when(mockConsentRepo.getConsentPreferences()).thenReturn(testPreference);
      // When
      final result = consentCubit.getCurrentPreferences();
      // Then
      expect(result.categories, {ConsentCategory.necessary});
      expect(result.method, ConsentMethod.rejectAll);
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
      final result = consentCubit.getCurrentPreferences();
      // Then
      expect(result.categories,
          {ConsentCategory.necessary, ConsentCategory.statistics});
      expect(result.method, ConsentMethod.custom);
    });

    test("should call repository each time", () {
      // Given
      final testPreference = ConsentPreference.acceptAll('1.0');
      when(mockConsentRepo.getConsentPreferences()).thenReturn(testPreference);
      // When
      consentCubit.getCurrentPreferences();
      consentCubit.getCurrentPreferences();
      // Then
      verify(mockConsentRepo.getConsentPreferences()).called(2);
      verifyNoMoreInteractions(mockConsentRepo);
    });
  });
}
