import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/application/dashboard/landingpage_ranking/dashboard_landingpage_ranking_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/dashboard_ranked_landingpage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late DashboardLandingpageRankingCubit cubit;
  late MockDashboardRepository mockDashboardRepo;

  setUp(() {
    mockDashboardRepo = MockDashboardRepository();
    cubit = DashboardLandingpageRankingCubit(mockDashboardRepo);
  });

  group("LandingpageRankingCubit_InitialState", () {
    test("init state should be DashboardLandingpageRankingInitial", () {
      expect(cubit.state, DashboardLandingpageRankingInitial());
    });
  });

  group("LandingpageRankingCubit_GetTop3LandingPages", () {
    const testLandingPageIDs = ["landing1", "landing2", "landing3"];
    const mockRankedLandingPages = [
      DashboardRankedLandingpage(
        landingPageName: "Immobilien Beratung",
        rank: 1,
        completedRecommendationsCount: 25,
      ),
      DashboardRankedLandingpage(
        landingPageName: "Versicherungs Check",
        rank: 2,
        completedRecommendationsCount: 18,
      ),
      DashboardRankedLandingpage(
        landingPageName: "Altersvorsorge Planer",
        rank: 3,
        completedRecommendationsCount: 12,
      ),
    ];

    test("should call repo if getTop3LandingPages is called without TimePeriod",
        () async {
      // Given
      when(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs))
          .thenAnswer((_) async => right(mockRankedLandingPages));

      // When
      cubit.getTop3LandingPages(testLandingPageIDs, null);
      await untilCalled(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs));

      // Then
      verify(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs));
      verifyNoMoreInteractions(mockDashboardRepo);
    });

    test("should call repo if getTop3LandingPages is called with TimePeriod",
        () async {
      // Given
      when(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs,
              timePeriod: TimePeriod.month))
          .thenAnswer((_) async => right(mockRankedLandingPages));

      // When
      cubit.getTop3LandingPages(testLandingPageIDs, TimePeriod.month);
      await untilCalled(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs,
          timePeriod: TimePeriod.month));

      // Then
      verify(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs,
          timePeriod: TimePeriod.month));
      verifyNoMoreInteractions(mockDashboardRepo);
    });

    test(
        "should emit LoadingState and then SuccessState when getTop3LandingPages is successful",
        () {
      // Given
      final expectedResult = [
        DashboardLandingPageRankingGetTop3LoadingState(),
        DashboardLandingPageRankingGetTop3SuccessState(landingPages: mockRankedLandingPages)
      ];
      when(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs))
          .thenAnswer((_) async => right(mockRankedLandingPages));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getTop3LandingPages(testLandingPageIDs, null);
    });

    test(
        "should emit LoadingState and then SuccessState when getTop3LandingPages is successful with TimePeriod",
        () {
      // Given
      final expectedResult = [
        DashboardLandingPageRankingGetTop3LoadingState(),
        DashboardLandingPageRankingGetTop3SuccessState(landingPages: mockRankedLandingPages)
      ];
      when(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs,
              timePeriod: TimePeriod.quarter))
          .thenAnswer((_) async => right(mockRankedLandingPages));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getTop3LandingPages(testLandingPageIDs, TimePeriod.quarter);
    });

    test("should emit NoPagesState when landingPageIDs list is empty", () {
      // Given
      final expectedResult = [DashboardLandingPageRankingGetTop3NoPagesState()];

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getTop3LandingPages([], null);
    });

    test(
        "should emit LoadingState and then FailureState when getTop3LandingPages fails with BackendFailure",
        () {
      // Given
      final expectedResult = [
        DashboardLandingPageRankingGetTop3LoadingState(),
        DashboardLandingPageRankingGetTop3FailureState(failure: BackendFailure())
      ];
      when(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs))
          .thenAnswer((_) async => left(BackendFailure()));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getTop3LandingPages(testLandingPageIDs, null);
    });

    test(
        "should emit LoadingState and then FailureState when getTop3LandingPages fails with NotFoundFailure",
        () {
      // Given
      final expectedResult = [
        DashboardLandingPageRankingGetTop3LoadingState(),
        DashboardLandingPageRankingGetTop3FailureState(failure: NotFoundFailure())
      ];
      when(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs,
              timePeriod: TimePeriod.month))
          .thenAnswer((_) async => left(NotFoundFailure()));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getTop3LandingPages(testLandingPageIDs, TimePeriod.month);
    });

    test(
        "should emit LoadingState and then FailureState when getTop3LandingPages fails with PermissionDeniedFailure",
        () {
      // Given
      final expectedResult = [
        DashboardLandingPageRankingGetTop3LoadingState(),
        DashboardLandingPageRankingGetTop3FailureState(failure: PermissionDeniedFailure())
      ];
      when(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs,
              timePeriod: TimePeriod.year))
          .thenAnswer((_) async => left(PermissionDeniedFailure()));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getTop3LandingPages(testLandingPageIDs, TimePeriod.year);
    });

    test(
        "should emit LoadingState and then SuccessState when getTop3LandingPages returns empty list",
        () {
      // Given
      final expectedResult = [
        DashboardLandingPageRankingGetTop3LoadingState(),
        DashboardLandingPageRankingGetTop3SuccessState(
            landingPages: <DashboardRankedLandingpage>[])
      ];
      when(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs))
          .thenAnswer((_) async => right(<DashboardRankedLandingpage>[]));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getTop3LandingPages(testLandingPageIDs, null);
    });
  });
}