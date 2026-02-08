import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/chart_trend.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/promoter_recommendations.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/domain/statistics/recommendations_statistics.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAppLocalizations extends Mock implements AppLocalizations {
  @override
  String dashboard_recommendations_last_24_hours(int count) =>
      "$count in 24h";

  @override
  String dashboard_recommendations_last_7_days(int count) =>
      "$count in 7 days";

  @override
  String dashboard_recommendations_last_month(int count) =>
      "$count in last month";
}

void main() {
  UserRecommendation createRecommendation({
    required String id,
    String reason = "Test Page",
    StatusLevel statusLevel = StatusLevel.recommendationSend,
    DateTime? createdAt,
  }) {
    return UserRecommendation(
      id: UniqueID.fromUniqueString(id),
      recoID: id,
      userID: "user-1",
      priority: RecommendationPriority.medium,
      notes: null,
      recommendation: RecommendationItem(
        id: id,
        name: "Test",
        reason: reason,
        landingPageID: "lp1",
        promotionTemplate: null,
        promoterName: null,
        serviceProviderName: null,
        defaultLandingPageID: null,
        statusLevel: statusLevel,
        statusTimestamps: null,
        userID: "user-1",
        promoterImageDownloadURL: null,
        createdAt: createdAt,
      ),
    );
  }

  group("RecommendationsStatistics_GetFilteredRecommendations", () {
    final rec1 = createRecommendation(id: "r1", reason: "Investment Page");
    final rec2 = createRecommendation(id: "r2", reason: "Savings Page");
    final rec3 = createRecommendation(id: "r3", reason: "Investment Page");
    final allRecommendations = [rec1, rec2, rec3];

    test(
        "should return all recommendations when no promoter is selected and role is company",
        () {
      // When
      final result = RecommendationsStatistics.getFilteredRecommendations(
        recommendations: allRecommendations,
        selectedPromoterId: null,
        userRole: Role.company,
      );

      // Then
      expect(result, allRecommendations);
    });

    test(
        "should return all recommendations when role is not company even with promoter selected",
        () {
      // When
      final result = RecommendationsStatistics.getFilteredRecommendations(
        recommendations: allRecommendations,
        selectedPromoterId: "p1",
        userRole: Role.promoter,
      );

      // Then
      expect(result, allRecommendations);
    });

    test(
        "should return promoter-specific recommendations when promoter is selected and role is company",
        () {
      // Given
      final promoterRecs = [rec1, rec3];
      final promoterRecommendations = [
        PromoterRecommendations(
          promoter: CustomUser(id: UniqueID.fromUniqueString("p1")),
          recommendations: promoterRecs,
        ),
      ];

      // When
      final result = RecommendationsStatistics.getFilteredRecommendations(
        recommendations: allRecommendations,
        selectedPromoterId: "p1",
        userRole: Role.company,
        promoterRecommendations: promoterRecommendations,
      );

      // Then
      expect(result, promoterRecs);
    });

    test(
        "should return empty list when selected promoter is not found in promoterRecommendations",
        () {
      // Given
      final promoterRecommendations = [
        PromoterRecommendations(
          promoter: CustomUser(id: UniqueID.fromUniqueString("p1")),
          recommendations: [rec1],
        ),
      ];

      // When
      final result = RecommendationsStatistics.getFilteredRecommendations(
        recommendations: allRecommendations,
        selectedPromoterId: "unknown",
        userRole: Role.company,
        promoterRecommendations: promoterRecommendations,
      );

      // Then
      expect(result, isEmpty);
    });

    test(
        "should return all recommendations when promoter selected but promoterRecommendations is null",
        () {
      // When
      final result = RecommendationsStatistics.getFilteredRecommendations(
        recommendations: allRecommendations,
        selectedPromoterId: "p1",
        userRole: Role.company,
        promoterRecommendations: null,
      );

      // Then
      expect(result, allRecommendations);
    });

    test("should filter by landing page when selectedLandingPageId is set", () {
      // Given
      final landingPages = [
        LandingPage(
          id: UniqueID.fromUniqueString("lp-inv"),
          name: "Investment Page",
          ownerID: UniqueID.fromUniqueString("user-1"),
        ),
      ];

      // When
      final result = RecommendationsStatistics.getFilteredRecommendations(
        recommendations: allRecommendations,
        selectedPromoterId: null,
        userRole: Role.company,
        selectedLandingPageId: "lp-inv",
        allLandingPages: landingPages,
      );

      // Then
      expect(result.length, 2);
      expect(result, [rec1, rec3]);
    });

    test(
        "should not filter by landing page when selectedLandingPageId is not found",
        () {
      // Given
      final landingPages = [
        LandingPage(
          id: UniqueID.fromUniqueString("lp-other"),
          name: "Other Page",
          ownerID: UniqueID.fromUniqueString("user-1"),
        ),
      ];

      // When
      final result = RecommendationsStatistics.getFilteredRecommendations(
        recommendations: allRecommendations,
        selectedPromoterId: null,
        userRole: Role.company,
        selectedLandingPageId: "lp-unknown",
        allLandingPages: landingPages,
      );

      // Then
      expect(result, allRecommendations);
    });

    test(
        "should combine promoter filter and landing page filter", () {
      // Given
      final promoterRecs = [rec1, rec2, rec3];
      final promoterRecommendations = [
        PromoterRecommendations(
          promoter: CustomUser(id: UniqueID.fromUniqueString("p1")),
          recommendations: promoterRecs,
        ),
      ];
      final landingPages = [
        LandingPage(
          id: UniqueID.fromUniqueString("lp-inv"),
          name: "Investment Page",
          ownerID: UniqueID.fromUniqueString("user-1"),
        ),
      ];

      // When
      final result = RecommendationsStatistics.getFilteredRecommendations(
        recommendations: allRecommendations,
        selectedPromoterId: "p1",
        userRole: Role.company,
        promoterRecommendations: promoterRecommendations,
        selectedLandingPageId: "lp-inv",
        allLandingPages: landingPages,
      );

      // Then
      expect(result.length, 2);
      expect(result, [rec1, rec3]);
    });
  });

  group("RecommendationsStatistics_GetTimePeriodSummaryText", () {
    late MockAppLocalizations mockLocalizations;

    setUp(() {
      mockLocalizations = MockAppLocalizations();
    });

    test("should return 24h text for TimePeriod.day", () {
      // Given
      final rec = createRecommendation(
        id: "r1",
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      );

      // When
      final result = RecommendationsStatistics.getTimePeriodSummaryText(
        recommendations: [rec],
        timePeriod: TimePeriod.day,
        localization: mockLocalizations,
      );

      // Then
      expect(result, "1 in 24h");
    });

    test("should return 7 days text for TimePeriod.week", () {
      // Given
      final rec = createRecommendation(
        id: "r1",
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      );

      // When
      final result = RecommendationsStatistics.getTimePeriodSummaryText(
        recommendations: [rec],
        timePeriod: TimePeriod.week,
        localization: mockLocalizations,
      );

      // Then
      expect(result, "1 in 7 days");
    });

    test("should return month text for TimePeriod.month", () {
      // Given
      final rec = createRecommendation(
        id: "r1",
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      );

      // When
      final result = RecommendationsStatistics.getTimePeriodSummaryText(
        recommendations: [rec],
        timePeriod: TimePeriod.month,
        localization: mockLocalizations,
      );

      // Then
      expect(result, "1 in last month");
    });

    test("should count 0 when no recommendations are in period", () {
      // Given
      final rec = createRecommendation(
        id: "r1",
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
      );

      // When
      final result = RecommendationsStatistics.getTimePeriodSummaryText(
        recommendations: [rec],
        timePeriod: TimePeriod.day,
        localization: mockLocalizations,
      );

      // Then
      expect(result, "0 in 24h");
    });
  });

  group("RecommendationsStatistics_CalculateTrend", () {
    final now = DateTime(2025, 6, 15, 12, 0, 0);

    test("should return increasing trend when current period has more recs",
        () {
      // Given - 2 recs in current week, 1 in previous week
      final recommendations = [
        createRecommendation(
          id: "r1",
          createdAt: now.subtract(const Duration(days: 2)),
        ),
        createRecommendation(
          id: "r2",
          createdAt: now.subtract(const Duration(days: 3)),
        ),
        createRecommendation(
          id: "r3",
          createdAt: now.subtract(const Duration(days: 10)),
        ),
      ];

      // When
      final result = RecommendationsStatistics.calculateTrend(
        recommendations: recommendations,
        timePeriod: TimePeriod.week,
        now: now,
      );

      // Then
      expect(result.currentPeriodCount, 2);
      expect(result.previousPeriodCount, 1);
      expect(result.isIncreasing, true);
      expect(result.isDecreasing, false);
      expect(result.percentageChange, 100.0);
    });

    test("should return decreasing trend when current period has fewer recs",
        () {
      // Given - 1 rec in current week, 2 in previous week
      final recommendations = [
        createRecommendation(
          id: "r1",
          createdAt: now.subtract(const Duration(days: 2)),
        ),
        createRecommendation(
          id: "r2",
          createdAt: now.subtract(const Duration(days: 10)),
        ),
        createRecommendation(
          id: "r3",
          createdAt: now.subtract(const Duration(days: 12)),
        ),
      ];

      // When
      final result = RecommendationsStatistics.calculateTrend(
        recommendations: recommendations,
        timePeriod: TimePeriod.week,
        now: now,
      );

      // Then
      expect(result.currentPeriodCount, 1);
      expect(result.previousPeriodCount, 2);
      expect(result.isIncreasing, false);
      expect(result.isDecreasing, true);
      expect(result.percentageChange, -50.0);
    });

    test("should return stable trend when counts are equal", () {
      // Given - 1 rec in each period
      final recommendations = [
        createRecommendation(
          id: "r1",
          createdAt: now.subtract(const Duration(days: 2)),
        ),
        createRecommendation(
          id: "r2",
          createdAt: now.subtract(const Duration(days: 10)),
        ),
      ];

      // When
      final result = RecommendationsStatistics.calculateTrend(
        recommendations: recommendations,
        timePeriod: TimePeriod.week,
        now: now,
      );

      // Then
      expect(result.currentPeriodCount, 1);
      expect(result.previousPeriodCount, 1);
      expect(result.isIncreasing, false);
      expect(result.isDecreasing, false);
      expect(result.percentageChange, 0.0);
    });

    test(
        "should return increasing when current has recs and previous has none",
        () {
      // Given
      final recommendations = [
        createRecommendation(
          id: "r1",
          createdAt: now.subtract(const Duration(days: 2)),
        ),
      ];

      // When
      final result = RecommendationsStatistics.calculateTrend(
        recommendations: recommendations,
        timePeriod: TimePeriod.week,
        now: now,
      );

      // Then
      expect(result.currentPeriodCount, 1);
      expect(result.previousPeriodCount, 0);
      expect(result.isIncreasing, true);
      expect(result.percentageChange, 100.0);
    });

    test("should return zero trend when no recs in either period", () {
      // When
      final result = RecommendationsStatistics.calculateTrend(
        recommendations: [],
        timePeriod: TimePeriod.week,
        now: now,
      );

      // Then
      expect(
        result,
        const ChartTrend(
          currentPeriodCount: 0,
          previousPeriodCount: 0,
          percentageChange: 0.0,
          isIncreasing: false,
          isDecreasing: false,
        ),
      );
    });

    test("should work with TimePeriod.day", () {
      // Given - 1 rec in last 24h, 1 in previous 24h
      final recommendations = [
        createRecommendation(
          id: "r1",
          createdAt: now.subtract(const Duration(hours: 6)),
        ),
        createRecommendation(
          id: "r2",
          createdAt: now.subtract(const Duration(hours: 30)),
        ),
      ];

      // When
      final result = RecommendationsStatistics.calculateTrend(
        recommendations: recommendations,
        timePeriod: TimePeriod.day,
        now: now,
      );

      // Then
      expect(result.currentPeriodCount, 1);
      expect(result.previousPeriodCount, 1);
    });

    test("should work with TimePeriod.month", () {
      // Given - rec in current month
      final recommendations = [
        createRecommendation(
          id: "r1",
          createdAt: DateTime(2025, 6, 10),
        ),
        createRecommendation(
          id: "r2",
          createdAt: DateTime(2025, 5, 15),
        ),
      ];

      // When
      final result = RecommendationsStatistics.calculateTrend(
        recommendations: recommendations,
        timePeriod: TimePeriod.month,
        now: now,
      );

      // Then
      expect(result.currentPeriodCount, 1);
      expect(result.previousPeriodCount, 1);
    });

    test("should filter by statusLevel when provided", () {
      // Given - statusLevel 2 = contactFormSent (index 2)
      // recommendationSend (0), linkClicked (1), contactFormSent (2) should match statusLevel 2
      // appointment (3) should NOT match
      final recommendations = [
        createRecommendation(
          id: "r1",
          statusLevel: StatusLevel.recommendationSend,
          createdAt: now.subtract(const Duration(days: 2)),
        ),
        createRecommendation(
          id: "r2",
          statusLevel: StatusLevel.appointment,
          createdAt: now.subtract(const Duration(days: 3)),
        ),
        createRecommendation(
          id: "r3",
          statusLevel: StatusLevel.successful,
          createdAt: now.subtract(const Duration(days: 4)),
        ),
      ];

      // When
      final result = RecommendationsStatistics.calculateTrend(
        recommendations: recommendations,
        timePeriod: TimePeriod.week,
        statusLevel: 2,
        now: now,
      );

      // Then
      // r1 (index 0+1=1 <= 2) matches, r2 (index 3+1=4 > 2) doesn't match, r3 (successful) always matches
      expect(result.currentPeriodCount, 2);
    });
  });
}
