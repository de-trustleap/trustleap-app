// ignore_for_file: type=lint
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late MockTutorialRepository mockTutorialRepo;

  setUp(() {
    mockTutorialRepo = MockTutorialRepository();
  });

  group("TutorialRepository_getCurrentStep", () {
    final testUser = CustomUser(
      id: UniqueID.fromUniqueString("123"),
      gender: Gender.male,
      firstName: "Tester",
      lastName: "Test",
      birthDate: "23.12.23",
      email: "tester@test.de",
      role: Role.company,
      tutorialStep: 5,
      companyID: "company123",
      defaultLandingPageID: "landing123",
      landingPageIDs: ["landing456"],
      registeredPromoterIDs: ["promoter123"],
      recommendationIDs: ["recommendation123"],
    );

    test("should return current step when call is successful", () async {
      // Given
      const expectedStep = 8;
      final expectedResult = right(expectedStep);
      when(mockTutorialRepo.getCurrentStep(testUser))
          .thenAnswer((_) async => right(expectedStep));

      // When
      final result = await mockTutorialRepo.getCurrentStep(testUser);

      // Then
      verify(mockTutorialRepo.getCurrentStep(testUser));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockTutorialRepo);
    });

    test("should return step 0 for unverified email", () async {
      // Given
      const expectedStep = 0;
      final expectedResult = right(expectedStep);
      final unverifiedUser = testUser.copyWith(tutorialStep: 0);
      
      when(mockTutorialRepo.getCurrentStep(unverifiedUser))
          .thenAnswer((_) async => right(expectedStep));

      // When
      final result = await mockTutorialRepo.getCurrentStep(unverifiedUser);

      // Then
      verify(mockTutorialRepo.getCurrentStep(unverifiedUser));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockTutorialRepo);
    });

    test("should return step 1 for incomplete contact data", () async {
      // Given
      const expectedStep = 1;
      final expectedResult = right(expectedStep);
      final incompleteUser = testUser.copyWith(
        firstName: null,
        tutorialStep: 1,
      );

      when(mockTutorialRepo.getCurrentStep(incompleteUser))
          .thenAnswer((_) async => right(expectedStep));

      // When
      final result = await mockTutorialRepo.getCurrentStep(incompleteUser);

      // Then
      verify(mockTutorialRepo.getCurrentStep(incompleteUser));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockTutorialRepo);
    });

    test("should return step 2 for missing company registration", () async {
      // Given
      const expectedStep = 2;
      final expectedResult = right(expectedStep);
      final noCompanyUser = testUser.copyWith(
        companyID: null,
        pendingCompanyRequestID: null,
        tutorialStep: 1,
      );

      when(mockTutorialRepo.getCurrentStep(noCompanyUser))
          .thenAnswer((_) async => right(expectedStep));

      // When
      final result = await mockTutorialRepo.getCurrentStep(noCompanyUser);

      // Then
      verify(mockTutorialRepo.getCurrentStep(noCompanyUser));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockTutorialRepo);
    });

    test("should return failure when database call fails", () async {
      // Given
      final expectedResult = left(PermissionDeniedFailure());
      when(mockTutorialRepo.getCurrentStep(testUser))
          .thenAnswer((_) async => left(PermissionDeniedFailure()));

      // When
      final result = await mockTutorialRepo.getCurrentStep(testUser);

      // Then
      verify(mockTutorialRepo.getCurrentStep(testUser));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockTutorialRepo);
    });
  });

  group("TutorialRepository_setStep", () {
    final testUser = CustomUser(
      id: UniqueID.fromUniqueString("123"),
      gender: Gender.male,
      firstName: "Tester",
      lastName: "Test",
      birthDate: "23.12.23",
      email: "tester@test.de",
      role: Role.company,
      tutorialStep: 5,
    );

    test("should complete successfully when setting step", () async {
      // Given
      const newStep = 7;
      when(mockTutorialRepo.setStep(testUser, newStep))
          .thenAnswer((_) async => Future.value());

      // When
      await mockTutorialRepo.setStep(testUser, newStep);

      // Then
      verify(mockTutorialRepo.setStep(testUser, newStep));
      verifyNoMoreInteractions(mockTutorialRepo);
    });

    test("should complete successfully when setting step to null", () async {
      // Given
      when(mockTutorialRepo.setStep(testUser, null))
          .thenAnswer((_) async => Future.value());

      // When
      await mockTutorialRepo.setStep(testUser, null);

      // Then
      verify(mockTutorialRepo.setStep(testUser, null));
      verifyNoMoreInteractions(mockTutorialRepo);
    });

    test("should throw exception when database update fails", () async {
      // Given
      const newStep = 7;
      when(mockTutorialRepo.setStep(testUser, newStep))
          .thenThrow(Exception("Database error"));

      // When & Then
      expect(
        () async => await mockTutorialRepo.setStep(testUser, newStep),
        throwsException,
      );
      verify(mockTutorialRepo.setStep(testUser, newStep));
      verifyNoMoreInteractions(mockTutorialRepo);
    });
  });
}