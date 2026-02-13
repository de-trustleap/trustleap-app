import 'package:finanzbegleiter/features/dashboard/application/tutorial/dashboard_tutorial_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../mocks.mocks.dart';

void main() {
  late DashboardTutorialCubit cubit;
  late MockTutorialRepository mockTutorialRepo;

  setUp(() {
    mockTutorialRepo = MockTutorialRepository();
    cubit = DashboardTutorialCubit(mockTutorialRepo);
  });

  group("DashboardTutorialCubit_InitialState", () {
    test("init state should be DashboardTutorialInitial", () {
      expect(cubit.state, DashboardTutorialInitial());
    });
  });

  group("DashboardTutorialCubit_GetStep", () {
    final testUser = CustomUser(
      id: UniqueID.fromUniqueString("1"),
      email: "test@example.com",
      firstName: "Test",
      lastName: "User",
      role: Role.company,
      tutorialStep: 5,
    );

    test("should call repo when getStep is called", () async {
      // Given
      when(mockTutorialRepo.getCurrentStep(testUser))
          .thenAnswer((_) async => right(5));

      // When
      cubit.getStep(testUser);
      await untilCalled(mockTutorialRepo.getCurrentStep(testUser));

      // Then
      verify(mockTutorialRepo.getCurrentStep(testUser));
      verifyNoMoreInteractions(mockTutorialRepo);
    });

    test("should emit SuccessState when getStep is successful", () {
      // Given
      const expectedStep = 7;
      final expectedResult = [
        DashboardTutorialSuccess(currentStep: expectedStep)
      ];
      when(mockTutorialRepo.getCurrentStep(testUser))
          .thenAnswer((_) async => right(expectedStep));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getStep(testUser);
    });

    test("should emit SuccessState with step 0 for new user", () {
      // Given
      const expectedStep = 0;
      final newUser = testUser.copyWith(tutorialStep: null);
      final expectedResult = [
        DashboardTutorialSuccess(currentStep: expectedStep)
      ];
      when(mockTutorialRepo.getCurrentStep(newUser))
          .thenAnswer((_) async => right(expectedStep));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getStep(newUser);
    });

    test("should emit SuccessState with step 10 for completed tutorial", () {
      // Given
      const expectedStep = 10;
      final completedUser = testUser.copyWith(
        tutorialStep: 10,
        companyID: "company123",
        defaultLandingPageID: "landing123",
        landingPageIDs: ["landing456"],
        registeredPromoterIDs: ["promoter123"],
        recommendationIDs: ["recommendation123"],
      );
      final expectedResult = [
        DashboardTutorialSuccess(currentStep: expectedStep)
      ];
      when(mockTutorialRepo.getCurrentStep(completedUser))
          .thenAnswer((_) async => right(expectedStep));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getStep(completedUser);
    });

    test("should emit FailureState when getStep fails with DatabaseFailure", () {
      // Given
      final expectedResult = [
        DashboardTutorialFailure(failure: BackendFailure())
      ];
      when(mockTutorialRepo.getCurrentStep(testUser))
          .thenAnswer((_) async => left(BackendFailure()));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getStep(testUser);
    });

    test("should emit FailureState when getStep fails with PermissionDeniedFailure", () {
      // Given
      final expectedResult = [
        DashboardTutorialFailure(failure: PermissionDeniedFailure())
      ];
      when(mockTutorialRepo.getCurrentStep(testUser))
          .thenAnswer((_) async => left(PermissionDeniedFailure()));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getStep(testUser);
    });
  });

  group("DashboardTutorialCubit_SetStep", () {
    final testUser = CustomUser(
      id: UniqueID.fromUniqueString("1"),
      email: "test@example.com",
      firstName: "Test",
      lastName: "User",
      role: Role.company,
      tutorialStep: 5,
    );

    test("should call repo when setStep is called", () async {
      // Given
      const newStep = 7;
      when(mockTutorialRepo.setStep(testUser, newStep))
          .thenAnswer((_) async => Future.value());

      // When
      cubit.setStep(testUser, newStep);

      // Then
      verify(mockTutorialRepo.setStep(testUser, newStep));
      verifyNoMoreInteractions(mockTutorialRepo);
    });

    test("should call repo when setStep is called with null (tutorial complete)", () async {
      // Given
      when(mockTutorialRepo.setStep(testUser, null))
          .thenAnswer((_) async => Future.value());

      // When
      cubit.setStep(testUser, null);

      // Then
      verify(mockTutorialRepo.setStep(testUser, null));
      verifyNoMoreInteractions(mockTutorialRepo);
    });

    test("should not emit any state when setStep is called", () async {
      // Given
      const newStep = 8;
      when(mockTutorialRepo.setStep(testUser, newStep))
          .thenAnswer((_) async => Future.value());

      // Then
      expectLater(cubit.stream, emitsDone);
      
      // When
      cubit.setStep(testUser, newStep);
      await cubit.close();
    });

    test("should handle exceptions from setStep gracefully", () async {
      // Given
      const newStep = 9;
      when(mockTutorialRepo.setStep(testUser, newStep))
          .thenThrow(Exception("Database error"));

      // When & Then
      expect(
        () => cubit.setStep(testUser, newStep),
        throwsException,
      );
      verify(mockTutorialRepo.setStep(testUser, newStep));
      verifyNoMoreInteractions(mockTutorialRepo);
    });
  });
}