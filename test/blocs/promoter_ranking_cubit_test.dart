import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/application/dashboard/promoter_ranking/promoter_ranking_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/dashboard_ranked_promoter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late PromoterRankingCubit cubit;
  late MockDashboardRepository mockDashboardRepo;

  setUp(() {
    mockDashboardRepo = MockDashboardRepository();
    cubit = PromoterRankingCubit(mockDashboardRepo);
  });

  group("PromoterRankingCubit_InitialState", () {
    test("init state should be PromoterRankingInitial", () {
      expect(cubit.state, PromoterRankingInitial());
    });
  });

  group("PromoterRankingCubit_GetTop3Promoters", () {
    const testPromoterIDs = ["promoter1", "promoter2", "promoter3"];
    const mockRankedPromoters = [
      DashboardRankedPromoter(
        promoterName: "Anna Schmidt",
        rank: 1,
        completedRecommendationsCount: 15,
      ),
      DashboardRankedPromoter(
        promoterName: "Max Müller",
        rank: 2,
        completedRecommendationsCount: 12,
      ),
      DashboardRankedPromoter(
        promoterName: "Sarah Weber",
        rank: 3,
        completedRecommendationsCount: 8,
      ),
    ];

    test("should call repo if getTop3Promoters is called without TimePeriod", () async {
      // Given
      when(mockDashboardRepo.getTop3Promoters(testPromoterIDs))
          .thenAnswer((_) async => right(mockRankedPromoters));

      // When
      cubit.getTop3Promoters(testPromoterIDs);
      await untilCalled(mockDashboardRepo.getTop3Promoters(testPromoterIDs));

      // Then
      verify(mockDashboardRepo.getTop3Promoters(testPromoterIDs));
      verifyNoMoreInteractions(mockDashboardRepo);
    });

    test("should call repo if getTop3Promoters is called with TimePeriod", () async {
      // Given
      when(mockDashboardRepo.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.month))
          .thenAnswer((_) async => right(mockRankedPromoters));

      // When
      cubit.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.month);
      await untilCalled(mockDashboardRepo.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.month));

      // Then
      verify(mockDashboardRepo.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.month));
      verifyNoMoreInteractions(mockDashboardRepo);
    });

    test("should emit LoadingState and then SuccessState when getTop3Promoters is successful", () {
      // Given
      final expectedResult = [
        PromoterRankingGetTop3LoadingState(),
        PromoterRankingGetTop3SuccessState(promoters: mockRankedPromoters)
      ];
      when(mockDashboardRepo.getTop3Promoters(testPromoterIDs))
          .thenAnswer((_) async => right(mockRankedPromoters));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getTop3Promoters(testPromoterIDs);
    });

    test("should emit LoadingState and then SuccessState when getTop3Promoters is successful with TimePeriod", () {
      // Given
      final expectedResult = [
        PromoterRankingGetTop3LoadingState(),
        PromoterRankingGetTop3SuccessState(promoters: mockRankedPromoters)
      ];
      when(mockDashboardRepo.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.quarter))
          .thenAnswer((_) async => right(mockRankedPromoters));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.quarter);
    });

    test("should emit NoPromotersState when promoterIDs list is empty", () {
      // Given
      final expectedResult = [PromoterRankingGetTop3NoPromotersState()];

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getTop3Promoters([]);
    });

    test("should emit LoadingState and then FailureState when getTop3Promoters fails with BackendFailure", () {
      // Given
      final expectedResult = [
        PromoterRankingGetTop3LoadingState(),
        PromoterRankingGetTop3FailureState(failure: BackendFailure())
      ];
      when(mockDashboardRepo.getTop3Promoters(testPromoterIDs))
          .thenAnswer((_) async => left(BackendFailure()));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getTop3Promoters(testPromoterIDs);
    });

    test("should emit LoadingState and then FailureState when getTop3Promoters fails with NotFoundFailure", () {
      // Given
      final expectedResult = [
        PromoterRankingGetTop3LoadingState(),
        PromoterRankingGetTop3FailureState(failure: NotFoundFailure())
      ];
      when(mockDashboardRepo.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.month))
          .thenAnswer((_) async => left(NotFoundFailure()));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.month);
    });

    test("should emit LoadingState and then FailureState when getTop3Promoters fails with PermissionDeniedFailure", () {
      // Given
      final expectedResult = [
        PromoterRankingGetTop3LoadingState(),
        PromoterRankingGetTop3FailureState(failure: PermissionDeniedFailure())
      ];
      when(mockDashboardRepo.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.year))
          .thenAnswer((_) async => left(PermissionDeniedFailure()));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.year);
    });

    test("should emit LoadingState and then SuccessState when getTop3Promoters returns empty list", () {
      // Given
      final expectedResult = [
        PromoterRankingGetTop3LoadingState(),
        PromoterRankingGetTop3SuccessState(promoters: <DashboardRankedPromoter>[])
      ];
      when(mockDashboardRepo.getTop3Promoters(testPromoterIDs))
          .thenAnswer((_) async => right(<DashboardRankedPromoter>[]));

      // Then
      expectLater(cubit.stream, emitsInOrder(expectedResult));
      cubit.getTop3Promoters(testPromoterIDs);
    });
  });
}