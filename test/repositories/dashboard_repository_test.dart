// ignore_for_file: type=lint
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/dashboard/domain/dashboard_ranked_landingpage.dart';
import 'package:finanzbegleiter/features/dashboard/domain/dashboard_ranked_promoter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late MockDashboardRepository mockDashboardRepo;

  setUp(() {
    mockDashboardRepo = MockDashboardRepository();
  });

  group("DashboardRepository_getTop3Promoters", () {
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

    test(
        "should return List<DashboardRankedPromoter> when call is successful without TimePeriod",
        () async {
      // Given
      final expectedResult = right(mockRankedPromoters);
      when(mockDashboardRepo.getTop3Promoters(testPromoterIDs))
          .thenAnswer((_) async => right(mockRankedPromoters));
      
      // When
      final result = await mockDashboardRepo.getTop3Promoters(testPromoterIDs);
      
      // Then
      verify(mockDashboardRepo.getTop3Promoters(testPromoterIDs));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockDashboardRepo);
    });

    test(
        "should return List<DashboardRankedPromoter> when call is successful with TimePeriod.month",
        () async {
      // Given
      final expectedResult = right(mockRankedPromoters);
      when(mockDashboardRepo.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.month))
          .thenAnswer((_) async => right(mockRankedPromoters));
      
      // When
      final result = await mockDashboardRepo.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.month);
      
      // Then
      verify(mockDashboardRepo.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.month));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockDashboardRepo);
    });

    test(
        "should return List<DashboardRankedPromoter> when call is successful with TimePeriod.quarter",
        () async {
      // Given
      const quarterMockData = [
        DashboardRankedPromoter(
          promoterName: "Max Müller",
          rank: 1,
          completedRecommendationsCount: 45,
        ),
        DashboardRankedPromoter(
          promoterName: "Lisa Fischer",
          rank: 2,
          completedRecommendationsCount: 38,
        ),
        DashboardRankedPromoter(
          promoterName: "Anna Schmidt",
          rank: 3,
          completedRecommendationsCount: 32,
        ),
      ];
      final expectedResult = right(quarterMockData);
      when(mockDashboardRepo.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.quarter))
          .thenAnswer((_) async => right(quarterMockData));
      
      // When
      final result = await mockDashboardRepo.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.quarter);
      
      // Then
      verify(mockDashboardRepo.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.quarter));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockDashboardRepo);
    });

    test(
        "should return List<DashboardRankedPromoter> when call is successful with TimePeriod.year",
        () async {
      // Given
      const yearMockData = [
        DashboardRankedPromoter(
          promoterName: "Lisa Fischer",
          rank: 1,
          completedRecommendationsCount: 187,
        ),
        DashboardRankedPromoter(
          promoterName: "Tom Wagner",
          rank: 2,
          completedRecommendationsCount: 156,
        ),
        DashboardRankedPromoter(
          promoterName: "Max Müller",
          rank: 3,
          completedRecommendationsCount: 143,
        ),
      ];
      final expectedResult = right(yearMockData);
      when(mockDashboardRepo.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.year))
          .thenAnswer((_) async => right(yearMockData));
      
      // When
      final result = await mockDashboardRepo.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.year);
      
      // Then
      verify(mockDashboardRepo.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.year));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockDashboardRepo);
    });

    test("should return empty list when promoterIDs list is empty", () async {
      // Given
      const emptyPromoterIDs = <String>[];
      when(mockDashboardRepo.getTop3Promoters(emptyPromoterIDs))
          .thenAnswer((_) async => right(<DashboardRankedPromoter>[]));
      
      // When
      final result = await mockDashboardRepo.getTop3Promoters(emptyPromoterIDs);
      
      // Then
      verify(mockDashboardRepo.getTop3Promoters(emptyPromoterIDs));
      expect(result.isRight(), true);
      expect(result.getOrElse(() => []).isEmpty, true);
      verifyNoMoreInteractions(mockDashboardRepo);
    });

    test("should return DatabaseFailure when call fails with BackendFailure", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockDashboardRepo.getTop3Promoters(testPromoterIDs))
          .thenAnswer((_) async => left(BackendFailure()));
      
      // When
      final result = await mockDashboardRepo.getTop3Promoters(testPromoterIDs);
      
      // Then
      verify(mockDashboardRepo.getTop3Promoters(testPromoterIDs));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockDashboardRepo);
    });

    test("should return DatabaseFailure when call fails with NotFoundFailure", () async {
      // Given
      final expectedResult = left(NotFoundFailure());
      when(mockDashboardRepo.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.month))
          .thenAnswer((_) async => left(NotFoundFailure()));
      
      // When
      final result = await mockDashboardRepo.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.month);
      
      // Then
      verify(mockDashboardRepo.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.month));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockDashboardRepo);
    });

    test("should return DatabaseFailure when call fails with PermissionDeniedFailure", () async {
      // Given
      final expectedResult = left(PermissionDeniedFailure());
      when(mockDashboardRepo.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.quarter))
          .thenAnswer((_) async => left(PermissionDeniedFailure()));
      
      // When
      final result = await mockDashboardRepo.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.quarter);
      
      // Then
      verify(mockDashboardRepo.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.quarter));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockDashboardRepo);
    });

    test("should return less than 3 promoters when only 2 promoters exist", () async {
      // Given
      const twoPromoterIDs = ["promoter1", "promoter2"];
      const twoPromoterResults = [
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
      ];
      final expectedResult = right(twoPromoterResults);
      when(mockDashboardRepo.getTop3Promoters(twoPromoterIDs))
          .thenAnswer((_) async => right(twoPromoterResults));
      
      // When
      final result = await mockDashboardRepo.getTop3Promoters(twoPromoterIDs);
      
      // Then
      verify(mockDashboardRepo.getTop3Promoters(twoPromoterIDs));
      expect(expectedResult, result);
      expect(result.getOrElse(() => []).length, 2);
      verifyNoMoreInteractions(mockDashboardRepo);
    });

    test("should return promoters with 0 completed recommendations when no archived recommendations exist", () async {
      // Given
      const zeroCompletedPromoters = [
        DashboardRankedPromoter(
          promoterName: "New Promoter 1",
          rank: 1,
          completedRecommendationsCount: 0,
        ),
        DashboardRankedPromoter(
          promoterName: "New Promoter 2",
          rank: 2,
          completedRecommendationsCount: 0,
        ),
        DashboardRankedPromoter(
          promoterName: "New Promoter 3",
          rank: 3,
          completedRecommendationsCount: 0,
        ),
      ];
      final expectedResult = right(zeroCompletedPromoters);
      when(mockDashboardRepo.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.month))
          .thenAnswer((_) async => right(zeroCompletedPromoters));
      
      // When
      final result = await mockDashboardRepo.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.month);
      
      // Then
      verify(mockDashboardRepo.getTop3Promoters(testPromoterIDs, timePeriod: TimePeriod.month));
      expect(expectedResult, result);
      final promoters = result.getOrElse(() => []);
      expect(promoters.every((p) => p.completedRecommendationsCount == 0), true);
      verifyNoMoreInteractions(mockDashboardRepo);
    });
  });

  group("DashboardRepository_getTop3LandingPages", () {
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

    test(
        "should return List<DashboardRankedLandingpage> when call is successful without TimePeriod",
        () async {
      // Given
      final expectedResult = right(mockRankedLandingPages);
      when(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs))
          .thenAnswer((_) async => right(mockRankedLandingPages));
      
      // When
      final result = await mockDashboardRepo.getTop3LandingPages(testLandingPageIDs);
      
      // Then
      verify(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockDashboardRepo);
    });

    test(
        "should return List<DashboardRankedLandingpage> when call is successful with TimePeriod.month",
        () async {
      // Given
      final expectedResult = right(mockRankedLandingPages);
      when(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs, timePeriod: TimePeriod.month))
          .thenAnswer((_) async => right(mockRankedLandingPages));
      
      // When
      final result = await mockDashboardRepo.getTop3LandingPages(testLandingPageIDs, timePeriod: TimePeriod.month);
      
      // Then
      verify(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs, timePeriod: TimePeriod.month));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockDashboardRepo);
    });

    test(
        "should return List<DashboardRankedLandingpage> when call is successful with TimePeriod.quarter",
        () async {
      // Given
      const quarterMockData = [
        DashboardRankedLandingpage(
          landingPageName: "Kredit Beratung",
          rank: 1,
          completedRecommendationsCount: 67,
        ),
        DashboardRankedLandingpage(
          landingPageName: "Investment Guide",
          rank: 2,
          completedRecommendationsCount: 54,
        ),
        DashboardRankedLandingpage(
          landingPageName: "Immobilien Beratung",
          rank: 3,
          completedRecommendationsCount: 48,
        ),
      ];
      final expectedResult = right(quarterMockData);
      when(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs, timePeriod: TimePeriod.quarter))
          .thenAnswer((_) async => right(quarterMockData));
      
      // When
      final result = await mockDashboardRepo.getTop3LandingPages(testLandingPageIDs, timePeriod: TimePeriod.quarter);
      
      // Then
      verify(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs, timePeriod: TimePeriod.quarter));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockDashboardRepo);
    });

    test(
        "should return List<DashboardRankedLandingpage> when call is successful with TimePeriod.year",
        () async {
      // Given
      const yearMockData = [
        DashboardRankedLandingpage(
          landingPageName: "Investment Guide",
          rank: 1,
          completedRecommendationsCount: 234,
        ),
        DashboardRankedLandingpage(
          landingPageName: "Steuer Optimierung",
          rank: 2,
          completedRecommendationsCount: 189,
        ),
        DashboardRankedLandingpage(
          landingPageName: "Kredit Beratung",
          rank: 3,
          completedRecommendationsCount: 167,
        ),
      ];
      final expectedResult = right(yearMockData);
      when(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs, timePeriod: TimePeriod.year))
          .thenAnswer((_) async => right(yearMockData));
      
      // When
      final result = await mockDashboardRepo.getTop3LandingPages(testLandingPageIDs, timePeriod: TimePeriod.year);
      
      // Then
      verify(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs, timePeriod: TimePeriod.year));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockDashboardRepo);
    });

    test("should return empty list when landingPageIDs list is empty", () async {
      // Given
      const emptyLandingPageIDs = <String>[];
      when(mockDashboardRepo.getTop3LandingPages(emptyLandingPageIDs))
          .thenAnswer((_) async => right(<DashboardRankedLandingpage>[]));
      
      // When
      final result = await mockDashboardRepo.getTop3LandingPages(emptyLandingPageIDs);
      
      // Then
      verify(mockDashboardRepo.getTop3LandingPages(emptyLandingPageIDs));
      expect(result.isRight(), true);
      expect(result.getOrElse(() => []).isEmpty, true);
      verifyNoMoreInteractions(mockDashboardRepo);
    });

    test("should return DatabaseFailure when call fails with BackendFailure", () async {
      // Given
      final expectedResult = left(BackendFailure());
      when(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs))
          .thenAnswer((_) async => left(BackendFailure()));
      
      // When
      final result = await mockDashboardRepo.getTop3LandingPages(testLandingPageIDs);
      
      // Then
      verify(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockDashboardRepo);
    });

    test("should return DatabaseFailure when call fails with NotFoundFailure", () async {
      // Given
      final expectedResult = left(NotFoundFailure());
      when(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs, timePeriod: TimePeriod.month))
          .thenAnswer((_) async => left(NotFoundFailure()));
      
      // When
      final result = await mockDashboardRepo.getTop3LandingPages(testLandingPageIDs, timePeriod: TimePeriod.month);
      
      // Then
      verify(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs, timePeriod: TimePeriod.month));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockDashboardRepo);
    });

    test("should return DatabaseFailure when call fails with PermissionDeniedFailure", () async {
      // Given
      final expectedResult = left(PermissionDeniedFailure());
      when(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs, timePeriod: TimePeriod.quarter))
          .thenAnswer((_) async => left(PermissionDeniedFailure()));
      
      // When
      final result = await mockDashboardRepo.getTop3LandingPages(testLandingPageIDs, timePeriod: TimePeriod.quarter);
      
      // Then
      verify(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs, timePeriod: TimePeriod.quarter));
      expect(expectedResult, result);
      verifyNoMoreInteractions(mockDashboardRepo);
    });

    test("should return less than 3 landing pages when only 2 landing pages exist", () async {
      // Given
      const twoLandingPageIDs = ["landing1", "landing2"];
      const twoLandingPageResults = [
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
      ];
      final expectedResult = right(twoLandingPageResults);
      when(mockDashboardRepo.getTop3LandingPages(twoLandingPageIDs))
          .thenAnswer((_) async => right(twoLandingPageResults));
      
      // When
      final result = await mockDashboardRepo.getTop3LandingPages(twoLandingPageIDs);
      
      // Then
      verify(mockDashboardRepo.getTop3LandingPages(twoLandingPageIDs));
      expect(expectedResult, result);
      expect(result.getOrElse(() => []).length, 2);
      verifyNoMoreInteractions(mockDashboardRepo);
    });

    test("should return landing pages with 0 completed recommendations when no archived recommendations exist", () async {
      // Given
      const zeroCompletedLandingPages = [
        DashboardRankedLandingpage(
          landingPageName: "New Landing Page 1",
          rank: 1,
          completedRecommendationsCount: 0,
        ),
        DashboardRankedLandingpage(
          landingPageName: "New Landing Page 2",
          rank: 2,
          completedRecommendationsCount: 0,
        ),
        DashboardRankedLandingpage(
          landingPageName: "New Landing Page 3",
          rank: 3,
          completedRecommendationsCount: 0,
        ),
      ];
      final expectedResult = right(zeroCompletedLandingPages);
      when(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs, timePeriod: TimePeriod.month))
          .thenAnswer((_) async => right(zeroCompletedLandingPages));
      
      // When
      final result = await mockDashboardRepo.getTop3LandingPages(testLandingPageIDs, timePeriod: TimePeriod.month);
      
      // Then
      verify(mockDashboardRepo.getTop3LandingPages(testLandingPageIDs, timePeriod: TimePeriod.month));
      expect(expectedResult, result);
      final landingPages = result.getOrElse(() => []);
      expect(landingPages.every((lp) => lp.completedRecommendationsCount == 0), true);
      verifyNoMoreInteractions(mockDashboardRepo);
    });
  });
}