import 'package:finanzbegleiter/application/dashboard/overview/dashboard_overview_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late DashboardOverviewCubit cubit;
  late MockUserRepository mockUserRepo;
  late MockDashboardRepository mockDashboardRepo;

  setUp(() {
    mockUserRepo = MockUserRepository();
    mockDashboardRepo = MockDashboardRepository();
    cubit = DashboardOverviewCubit(mockUserRepo, mockDashboardRepo);
  });

  group("DashboardOverviewCubit_InitialState", () {
    test("init state should be DashboardOverviewInitial", () {
      expect(cubit.state, DashboardOverviewInitial());
    });
  });

  group("DashboardOverviewCubit_GetUser", () {
    final date = DateTime.now();
    final testUser = CustomUser(
        id: UniqueID.fromUniqueString("1"),
        email: "test@example.com",
        firstName: "Test",
        lastName: "User",
        role: Role.company,
        place: "Test City",
        recommendationIDs: ["1"],
        createdAt: date);

    test("should call repo if getUser is called", () async {
      // Given
      when(mockUserRepo.getUser())
          .thenAnswer((_) async => right(testUser));

      // When
      cubit.getUser();
      await untilCalled(mockUserRepo.getUser());

      // Then
      verify(mockUserRepo.getUser());
      verifyNoMoreInteractions(mockUserRepo);
    });

    test("should emit LoadingState and then SuccessState when getUser is called", () {
      // Given
      final expectedResult = [
        DashboardOverviewGetUserLoadingState(),
        DashboardOverviewGetUserSuccessState(user: testUser)
      ];
      when(mockUserRepo.getUser())
          .thenAnswer((_) async => right(testUser));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getUser();
    });

    test("should emit LoadingState and then FailureState when getUser fails", () {
      // Given
      final expectedResult = [
        DashboardOverviewGetUserLoadingState(),
        DashboardOverviewGetUserFailureState(failure: BackendFailure())
      ];
      when(mockUserRepo.getUser())
          .thenAnswer((_) async => left(BackendFailure()));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getUser();
    });

    test("should emit LoadingState and then FailureState when getUser returns NotFoundFailure", () {
      // Given
      final expectedResult = [
        DashboardOverviewGetUserLoadingState(),
        DashboardOverviewGetUserFailureState(failure: NotFoundFailure())
      ];
      when(mockUserRepo.getUser())
          .thenAnswer((_) async => left(NotFoundFailure()));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getUser();
    });
  });
}