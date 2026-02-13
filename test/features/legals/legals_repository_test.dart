import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/legals/domain/legals.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import '../../mocks.mocks.dart';

void main() {
  late MockLegalsRepository mockLegalsRepo;

  setUp(() {
    mockLegalsRepo = MockLegalsRepository();
  });

  group("LegalsRepositoryImplementation_GetLegals", () {
    const privacyPolicy = "Test";
    test("should return legals when call was successful", () async {
      // Given
      final expectedResult = right(privacyPolicy);
      when(mockLegalsRepo.getLegals(LegalsType.privacyPolicy))
          .thenAnswer((_) async => right(privacyPolicy));
      // When
      final result = await mockLegalsRepo.getLegals(LegalsType.privacyPolicy);
      // Then
      verify(mockLegalsRepo.getLegals(LegalsType.privacyPolicy));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLegalsRepo);
    });

    test("should return failure when the call has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockLegalsRepo.getLegals(LegalsType.privacyPolicy))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockLegalsRepo.getLegals(LegalsType.privacyPolicy);
      // Then
      verify(mockLegalsRepo.getLegals(LegalsType.privacyPolicy));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLegalsRepo);
    });
  });

  group("LegalsRepositoryImplementation_GetAllLegals", () {
    const testLegals = Legals(
      avv: "Test AVV",
      privacyPolicy: "Test Privacy Policy",
      termsAndCondition: "Test Terms",
    );

    test("should return all legals when call was successful", () async {
      // Given
      final expectedResult = right(testLegals);
      when(mockLegalsRepo.getAllLegals())
          .thenAnswer((_) async => right(testLegals));
      // When
      final result = await mockLegalsRepo.getAllLegals();
      // Then
      verify(mockLegalsRepo.getAllLegals());
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLegalsRepo);
    });

    test("should return failure when the call has failed", () async {
      // Given
      final expectedResult = left(NotFoundFailure());
      when(mockLegalsRepo.getAllLegals())
          .thenAnswer((_) async => left(NotFoundFailure()));
      // When
      final result = await mockLegalsRepo.getAllLegals();
      // Then
      verify(mockLegalsRepo.getAllLegals());
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLegalsRepo);
    });

    test("should return failure when backend error occurs", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockLegalsRepo.getAllLegals())
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockLegalsRepo.getAllLegals();
      // Then
      verify(mockLegalsRepo.getAllLegals());
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLegalsRepo);
    });
  });

  group("LegalsRepositoryImplementation_SaveLegals", () {
    const testLegals = Legals(
      avv: "Updated AVV",
      privacyPolicy: "Updated Privacy Policy",
      termsAndCondition: "Updated Terms",
    );

    test("should return unit when save was successful", () async {
      // Given
      final expectedResult = right(unit);
      when(mockLegalsRepo.saveLegals(testLegals))
          .thenAnswer((_) async => right(unit));
      // When
      final result = await mockLegalsRepo.saveLegals(testLegals);
      // Then
      verify(mockLegalsRepo.saveLegals(testLegals));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLegalsRepo);
    });

    test("should return failure when save has failed", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockLegalsRepo.saveLegals(testLegals))
          .thenAnswer((_) async => left(BackendFailure()));
      // When
      final result = await mockLegalsRepo.saveLegals(testLegals);
      // Then
      verify(mockLegalsRepo.saveLegals(testLegals));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLegalsRepo);
    });

    test("should return failure when firebase function error occurs", () async {
      // Given
      final expectedResult = left(PermissionDeniedFailure());
      when(mockLegalsRepo.saveLegals(testLegals))
          .thenAnswer((_) async => left(PermissionDeniedFailure()));
      // When
      final result = await mockLegalsRepo.saveLegals(testLegals);
      // Then
      verify(mockLegalsRepo.saveLegals(testLegals));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLegalsRepo);
    });

    test("should handle null values in legals correctly", () async {
      // Given
      const legalsWithNulls = Legals(
        avv: null,
        privacyPolicy: "Only Privacy Policy",
        termsAndCondition: null,
      );
      final expectedResult = right(unit);
      when(mockLegalsRepo.saveLegals(legalsWithNulls))
          .thenAnswer((_) async => right(unit));
      // When
      final result = await mockLegalsRepo.saveLegals(legalsWithNulls);
      // Then
      verify(mockLegalsRepo.saveLegals(legalsWithNulls));
      expect(result, expectedResult);
      verifyNoMoreInteractions(mockLegalsRepo);
    });
  });
}
