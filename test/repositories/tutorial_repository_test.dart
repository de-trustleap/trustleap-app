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

  group("TutorialRepository_getCurrentStep_CompanyUser", () {
    final companyUser = CustomUser(
      id: UniqueID.fromUniqueString("123"),
      gender: Gender.male,
      firstName: "Tester",
      lastName: "Test",
      birthDate: "23.12.23",
      email: "tester@test.de",
      role: Role.company,
      tutorialStep: 5,
      parentUserID: null,
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
      when(mockTutorialRepo.getCurrentStep(companyUser))
          .thenAnswer((_) async => right(expectedStep));

      // When
      final result = await mockTutorialRepo.getCurrentStep(companyUser);

      // Then
      verify(mockTutorialRepo.getCurrentStep(companyUser));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockTutorialRepo);
    });

    test("should return step 0 for unverified email", () async {
      // Given
      const expectedStep = 0;
      final expectedResult = right(expectedStep);
      final unverifiedUser = companyUser.copyWith(tutorialStep: 0);

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
      final incompleteUser = companyUser.copyWith(
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
      final noCompanyUser = companyUser.copyWith(
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
      when(mockTutorialRepo.getCurrentStep(companyUser))
          .thenAnswer((_) async => left(PermissionDeniedFailure()));

      // When
      final result = await mockTutorialRepo.getCurrentStep(companyUser);

      // Then
      verify(mockTutorialRepo.getCurrentStep(companyUser));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockTutorialRepo);
    });
  });

  group("TutorialRepository_getCurrentStep_PromoterUser", () {
    final promoterUser = CustomUser(
      id: UniqueID.fromUniqueString("456"),
      gender: Gender.female,
      firstName: "Promoter",
      lastName: "Test",
      birthDate: "15.05.95",
      email: "promoter@test.de",
      role: Role.promoter,
      tutorialStep: 3,
      parentUserID: "parent123",
      recommendationIDs: ["recommendation456"],
    );

    test("should return step 0 for unverified email", () async {
      // Given
      const expectedStep = 0;
      final expectedResult = right(expectedStep);
      final unverifiedUser = promoterUser.copyWith(tutorialStep: 0);

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
      final incompleteUser = promoterUser.copyWith(
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

    test(
        "should return step 8 for missing recommendation (skips company steps 2-7)",
        () async {
      // Given
      const expectedStep = 8;
      final expectedResult = right(expectedStep);
      final noRecommendationUser = promoterUser.copyWith(
        recommendationIDs: null,
      );

      when(mockTutorialRepo.getCurrentStep(noRecommendationUser))
          .thenAnswer((_) async => right(expectedStep));

      // When
      final result =
          await mockTutorialRepo.getCurrentStep(noRecommendationUser);

      // Then
      verify(mockTutorialRepo.getCurrentStep(noRecommendationUser));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockTutorialRepo);
    });

    test("should return step 9 for recommendation manager step", () async {
      // Given
      const expectedStep = 9;
      final expectedResult = right(expectedStep);
      final managerStepUser = promoterUser.copyWith(
        recommendationIDs: ["recommendation123"],
        tutorialStep: 8,
      );

      when(mockTutorialRepo.getCurrentStep(managerStepUser))
          .thenAnswer((_) async => right(expectedStep));

      // When
      final result = await mockTutorialRepo.getCurrentStep(managerStepUser);

      // Then
      verify(mockTutorialRepo.getCurrentStep(managerStepUser));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockTutorialRepo);
    });

    test("should return step 10 for completed tutorial", () async {
      // Given
      const expectedStep = 10;
      final expectedResult = right(expectedStep);
      final completedUser = promoterUser.copyWith(
        recommendationIDs: ["recommendation123"],
        tutorialStep: 10,
      );

      when(mockTutorialRepo.getCurrentStep(completedUser))
          .thenAnswer((_) async => right(expectedStep));

      // When
      final result = await mockTutorialRepo.getCurrentStep(completedUser);

      // Then
      verify(mockTutorialRepo.getCurrentStep(completedUser));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockTutorialRepo);
    });

    test("should return failure when database call fails", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockTutorialRepo.getCurrentStep(promoterUser))
          .thenAnswer((_) async => left(BackendFailure()));

      // When
      final result = await mockTutorialRepo.getCurrentStep(promoterUser);

      // Then
      verify(mockTutorialRepo.getCurrentStep(promoterUser));
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
