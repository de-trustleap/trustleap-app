import 'package:finanzbegleiter/features/dashboard/application/promoters/dashboard_promoters_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../mocks.mocks.dart';

void main() {
  late DashboardPromotersCubit cubit;
  late MockPromoterRepository mockPromoterRepository;

  setUp(() {
    mockPromoterRepository = MockPromoterRepository();
    cubit = DashboardPromotersCubit(mockPromoterRepository);
  });

  group("DashboardPromotersCubit_InitialState", () {
    test("init state should be DashboardPromotersInitial", () {
      expect(cubit.state, DashboardPromotersInitial());
    });
  });

  group("DashboardPromotersCubit_GetRegisteredPromoters", () {
    final date = DateTime.now();
    
    final testUser = CustomUser(
        id: UniqueID.fromUniqueString("1"),
        email: "test@example.com",
        firstName: "Test",
        lastName: "User",
        role: Role.company,
        registeredPromoterIDs: ["1", "2"],
        createdAt: date);

    final testUserWithoutPromoters = CustomUser(
        id: UniqueID.fromUniqueString("2"),
        email: "test2@example.com",
        firstName: "Test2",
        lastName: "User2",
        role: Role.company,
        registeredPromoterIDs: null,
        createdAt: date);

    final testUserWithEmptyPromoters = CustomUser(
        id: UniqueID.fromUniqueString("3"),
        email: "test3@example.com",
        firstName: "Test3",
        lastName: "User3",
        role: Role.company,
        registeredPromoterIDs: [],
        createdAt: date);

    final testPromoters = [
      CustomUser(
        id: UniqueID.fromUniqueString("1"),
        email: "promoter1@example.com",
        firstName: "Promoter",
        lastName: "One",
        role: Role.promoter,
        createdAt: date,
      ),
      CustomUser(
        id: UniqueID.fromUniqueString("2"),
        email: "promoter2@example.com",
        firstName: "Promoter",
        lastName: "Two",
        role: Role.promoter,
        createdAt: date,
      ),
    ];

    test("should call promoter repo when getRegisteredPromoters is called", () async {
      // Given
      when(mockPromoterRepository.getRegisteredPromoters(["1", "2"]))
          .thenAnswer((_) async => right(testPromoters));

      // When
      cubit.getRegisteredPromoters(testUser);
      await untilCalled(mockPromoterRepository.getRegisteredPromoters(["1", "2"]));

      // Then
      verify(mockPromoterRepository.getRegisteredPromoters(["1", "2"]));
      verifyNoMoreInteractions(mockPromoterRepository);
    });

    test("should emit LoadingState and then SuccessState when getRegisteredPromoters is called", () {
      // Given
      final expectedResult = [
        DashboardPromotersGetRegisteredPromotersLoadingState(),
        DashboardPromotersGetRegisteredPromotersSuccessState(
          promoters: testPromoters,
        )
      ];
      when(mockPromoterRepository.getRegisteredPromoters(["1", "2"]))
          .thenAnswer((_) async => right(testPromoters));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getRegisteredPromoters(testUser);
    });

    test("should emit LoadingState and then FailureState when getRegisteredPromoters fails", () {
      // Given
      final expectedResult = [
        DashboardPromotersGetRegisteredPromotersLoadingState(),
        DashboardPromotersGetRegisteredPromotersFailureState(failure: BackendFailure())
      ];
      when(mockPromoterRepository.getRegisteredPromoters(["1", "2"]))
          .thenAnswer((_) async => left(BackendFailure()));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getRegisteredPromoters(testUser);
    });

    test("should emit LoadingState and then EmptyState when user has no registered promoters", () {
      // Given
      final expectedResult = [
        DashboardPromotersGetRegisteredPromotersLoadingState(),
        DashboardPromotersGetRegisteredPromotersEmptyState()
      ];

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getRegisteredPromoters(testUserWithoutPromoters);
    });

    test("should emit LoadingState and then EmptyState when user has empty registered promoters list", () {
      // Given
      final expectedResult = [
        DashboardPromotersGetRegisteredPromotersLoadingState(),
        DashboardPromotersGetRegisteredPromotersEmptyState()
      ];

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getRegisteredPromoters(testUserWithEmptyPromoters);
    });

    test("should not call repository when user has no registered promoters", () async {
      // When
      cubit.getRegisteredPromoters(testUserWithoutPromoters);
      
      // Wait a bit to ensure no calls are made
      await Future.delayed(const Duration(milliseconds: 100));

      // Then
      verifyNever(mockPromoterRepository.getRegisteredPromoters(any));
    });

    test("should not call repository when user has empty registered promoters list", () async {
      // When
      cubit.getRegisteredPromoters(testUserWithEmptyPromoters);
      
      // Wait a bit to ensure no calls are made
      await Future.delayed(const Duration(milliseconds: 100));

      // Then
      verifyNever(mockPromoterRepository.getRegisteredPromoters(any));
    });

    test("should emit LoadingState and then FailureState when repository returns NotFoundFailure", () {
      // Given
      final expectedResult = [
        DashboardPromotersGetRegisteredPromotersLoadingState(),
        DashboardPromotersGetRegisteredPromotersFailureState(failure: NotFoundFailure())
      ];
      when(mockPromoterRepository.getRegisteredPromoters(["1", "2"]))
          .thenAnswer((_) async => left(NotFoundFailure()));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getRegisteredPromoters(testUser);
    });

    test("should emit LoadingState and then SuccessState with empty list when repository returns empty list", () {
      // Given
      final expectedResult = [
        DashboardPromotersGetRegisteredPromotersLoadingState(),
        DashboardPromotersGetRegisteredPromotersSuccessState(
          promoters: [],
        )
      ];
      when(mockPromoterRepository.getRegisteredPromoters(["1", "2"]))
          .thenAnswer((_) async => right([]));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getRegisteredPromoters(testUser);
    });
  });
}