import "package:fl_chart/fl_chart.dart";
import "package:finanzbegleiter/core/id.dart";
import 'package:finanzbegleiter/features/recommendations/domain/campaign_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/personalized_recommendation_item.dart';
import "package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart";
import "package:finanzbegleiter/features/recommendations/domain/recommendation_status_counts.dart";
import "package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart";
import "package:finanzbegleiter/features/promoter/presentation/widgets/promoter_detail/promoter_detail_chart_helper.dart";
import "package:flutter_test/flutter_test.dart";
import "package:intl/date_symbol_data_local.dart";

void main() {
  setUpAll(() async {
    await initializeDateFormatting("de_DE", null);
  });
  group("PromoterDetailChartHelper", () {
    UserRecommendation createRecommendation({
      required String id,
      required StatusLevel statusLevel,
      required DateTime createdAt,
    }) {
      return UserRecommendation(
        id: UniqueID.fromUniqueString(id),
        recoID: id,
        userID: "user-1",
        priority: RecommendationPriority.medium,
        notes: null,
        recommendation: PersonalizedRecommendationItem(
          id: id,
          name: "Rec $id",
          reason: "Test",
          landingPageID: "lp-1",
          promotionTemplate: null,
          promoterName: "Test User",
          serviceProviderName: null,
          defaultLandingPageID: null,
          statusLevel: statusLevel,
          statusTimestamps: {0: createdAt},
          userID: "user-1",
          promoterImageDownloadURL: null,
          createdAt: createdAt,
        ),
      );
    }

    group("nonSuccessful", () {
      test("should filter out successful recommendations", () {
        final recommendations = [
          createRecommendation(
              id: "1",
              statusLevel: StatusLevel.recommendationSend,
              createdAt: DateTime.now()),
          createRecommendation(
              id: "2",
              statusLevel: StatusLevel.successful,
              createdAt: DateTime.now()),
          createRecommendation(
              id: "3",
              statusLevel: StatusLevel.linkClicked,
              createdAt: DateTime.now()),
        ];

        final helper = PromoterDetailChartHelper(
          recommendations: recommendations,
          selectedDays: 7,
        );

        expect(helper.nonSuccessful.length, equals(2));
        expect(
            helper.nonSuccessful.every((r) {
              final reco = r.recommendation;
              return reco is PersonalizedRecommendationItem &&
                  reco.statusLevel != StatusLevel.successful;
            }),
            isTrue);
      });

      test("should return all when none are successful", () {
        final recommendations = [
          createRecommendation(
              id: "1",
              statusLevel: StatusLevel.recommendationSend,
              createdAt: DateTime.now()),
          createRecommendation(
              id: "2",
              statusLevel: StatusLevel.failed,
              createdAt: DateTime.now()),
        ];

        final helper = PromoterDetailChartHelper(
          recommendations: recommendations,
          selectedDays: 7,
        );

        expect(helper.nonSuccessful.length, equals(2));
      });

      test("should return empty when all are successful", () {
        final recommendations = [
          createRecommendation(
              id: "1",
              statusLevel: StatusLevel.successful,
              createdAt: DateTime.now()),
          createRecommendation(
              id: "2",
              statusLevel: StatusLevel.successful,
              createdAt: DateTime.now()),
        ];

        final helper = PromoterDetailChartHelper(
          recommendations: recommendations,
          selectedDays: 7,
        );

        expect(helper.nonSuccessful, isEmpty);
      });
    });

    group("conversions", () {
      test("should return only successful recommendations", () {
        final recommendations = [
          createRecommendation(
              id: "1",
              statusLevel: StatusLevel.recommendationSend,
              createdAt: DateTime.now()),
          createRecommendation(
              id: "2",
              statusLevel: StatusLevel.successful,
              createdAt: DateTime.now()),
          createRecommendation(
              id: "3",
              statusLevel: StatusLevel.successful,
              createdAt: DateTime.now()),
        ];

        final helper = PromoterDetailChartHelper(
          recommendations: recommendations,
          selectedDays: 7,
        );

        expect(helper.conversions.length, equals(2));
        expect(
            helper.conversions.every((r) {
              final reco = r.recommendation;
              return reco is PersonalizedRecommendationItem &&
                  reco.statusLevel == StatusLevel.successful;
            }),
            isTrue);
      });

      test("should return empty when none are successful", () {
        final recommendations = [
          createRecommendation(
              id: "1",
              statusLevel: StatusLevel.recommendationSend,
              createdAt: DateTime.now()),
          createRecommendation(
              id: "2",
              statusLevel: StatusLevel.failed,
              createdAt: DateTime.now()),
        ];

        final helper = PromoterDetailChartHelper(
          recommendations: recommendations,
          selectedDays: 7,
        );

        expect(helper.conversions, isEmpty);
      });
    });

    group("generateSpots", () {
      test("should return spots for each day in the selected period", () {
        final helper = PromoterDetailChartHelper(
          recommendations: [],
          selectedDays: 7,
        );

        final spots = helper.generateSpots([]);

        expect(spots.length, equals(7));
      });

      test("should return spots for 30 days", () {
        final helper = PromoterDetailChartHelper(
          recommendations: [],
          selectedDays: 30,
        );

        final spots = helper.generateSpots([]);

        expect(spots.length, equals(30));
      });

      test("should count recommendations on the correct day", () {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        final recommendations = [
          createRecommendation(
              id: "1",
              statusLevel: StatusLevel.recommendationSend,
              createdAt: today),
          createRecommendation(
              id: "2",
              statusLevel: StatusLevel.recommendationSend,
              createdAt: today),
        ];

        final helper = PromoterDetailChartHelper(
          recommendations: recommendations,
          selectedDays: 7,
        );

        final spots = helper.generateSpots(recommendations);

        // Last spot (index 6) = today
        expect(spots.last.y, equals(2.0));
        expect(spots.last.x, equals(6.0));
      });

      test("should place recommendations on correct day index", () {
        final now = DateTime.now();
        final twoDaysAgo = DateTime(now.year, now.month, now.day)
            .subtract(const Duration(days: 2));

        final recommendations = [
          createRecommendation(
              id: "1",
              statusLevel: StatusLevel.recommendationSend,
              createdAt: twoDaysAgo),
        ];

        final helper = PromoterDetailChartHelper(
          recommendations: recommendations,
          selectedDays: 7,
        );

        final spots = helper.generateSpots(recommendations);

        // 7 days: index 0 = 6 days ago, ..., index 4 = 2 days ago, ..., index 6 = today
        expect(spots[4].y, equals(1.0));
        expect(spots.last.y, equals(0.0));
      });

      test("should return all zeros when no recommendations match", () {
        final helper = PromoterDetailChartHelper(
          recommendations: [],
          selectedDays: 7,
        );

        final spots = helper.generateSpots([]);

        expect(spots.every((spot) => spot.y == 0.0), isTrue);
      });

      test("should ignore recommendations outside the selected timeframe", () {
        final now = DateTime.now();
        final tenDaysAgo = DateTime(now.year, now.month, now.day)
            .subtract(const Duration(days: 10));

        final recommendations = [
          createRecommendation(
              id: "1",
              statusLevel: StatusLevel.recommendationSend,
              createdAt: tenDaysAgo),
        ];

        final helper = PromoterDetailChartHelper(
          recommendations: recommendations,
          selectedDays: 7,
        );

        final spots = helper.generateSpots(recommendations);

        expect(spots.every((spot) => spot.y == 0.0), isTrue);
      });

      test("should handle recommendations with null statusTimestamps", () {
        final rec = UserRecommendation(
          id: UniqueID.fromUniqueString("null-ts"),
          recoID: "null-ts",
          userID: "user-1",
          priority: RecommendationPriority.medium,
          notes: null,
          recommendation: PersonalizedRecommendationItem(
            id: "null-ts",
            name: "Rec",
            reason: "Test",
            landingPageID: "lp-1",
            promotionTemplate: null,
            promoterName: "Test",
            serviceProviderName: null,
            defaultLandingPageID: null,
            statusLevel: StatusLevel.recommendationSend,
            statusTimestamps: null,
            userID: "user-1",
            promoterImageDownloadURL: null,
          ),
        );

        final helper = PromoterDetailChartHelper(
          recommendations: [rec],
          selectedDays: 7,
        );

        final spots = helper.generateSpots([rec]);

        expect(spots.every((spot) => spot.y == 0.0), isTrue);
      });
    });

    group("hasConversionsInTimeframe", () {
      test("should return true when conversions exist in timeframe", () {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        final recommendations = [
          createRecommendation(
              id: "1",
              statusLevel: StatusLevel.successful,
              createdAt: today),
        ];

        final helper = PromoterDetailChartHelper(
          recommendations: recommendations,
          selectedDays: 7,
        );

        expect(helper.hasConversionsInTimeframe, isTrue);
      });

      test("should return false when no conversions exist", () {
        final recommendations = [
          createRecommendation(
              id: "1",
              statusLevel: StatusLevel.recommendationSend,
              createdAt: DateTime.now()),
        ];

        final helper = PromoterDetailChartHelper(
          recommendations: recommendations,
          selectedDays: 7,
        );

        expect(helper.hasConversionsInTimeframe, isFalse);
      });

      test("should return false when conversions are outside timeframe", () {
        final now = DateTime.now();
        final thirtyDaysAgo = DateTime(now.year, now.month, now.day)
            .subtract(const Duration(days: 30));

        final recommendations = [
          createRecommendation(
              id: "1",
              statusLevel: StatusLevel.successful,
              createdAt: thirtyDaysAgo),
        ];

        final helper = PromoterDetailChartHelper(
          recommendations: recommendations,
          selectedDays: 7,
        );

        expect(helper.hasConversionsInTimeframe, isFalse);
      });

      test("should return false for empty recommendations", () {
        final helper = PromoterDetailChartHelper(
          recommendations: [],
          selectedDays: 7,
        );

        expect(helper.hasConversionsInTimeframe, isFalse);
      });
    });

    group("calculateMaxY", () {
      test("should return minimum of 5.0 for empty series", () {
        final helper = PromoterDetailChartHelper(
          recommendations: [],
          selectedDays: 7,
        );

        final maxY = helper.calculateMaxY([]);

        expect(maxY, equals(5.0));
      });

      test("should return minimum of 5.0 for small values", () {
        final helper = PromoterDetailChartHelper(
          recommendations: [],
          selectedDays: 7,
        );

        final spots = [FlSpot(0, 1), FlSpot(1, 2), FlSpot(2, 3)];
        final maxY = helper.calculateMaxY([spots]);

        expect(maxY, equals(5.0));
      });

      test("should add 20% padding to max value", () {
        final helper = PromoterDetailChartHelper(
          recommendations: [],
          selectedDays: 7,
        );

        final spots = [FlSpot(0, 10), FlSpot(1, 20), FlSpot(2, 10)];
        final maxY = helper.calculateMaxY([spots]);

        // 20 + 20% = 24.0
        expect(maxY, equals(24.0));
      });

      test("should consider multiple series", () {
        final helper = PromoterDetailChartHelper(
          recommendations: [],
          selectedDays: 7,
        );

        final series1 = [FlSpot(0, 5), FlSpot(1, 10)];
        final series2 = [FlSpot(0, 15), FlSpot(1, 8)];
        final maxY = helper.calculateMaxY([series1, series2]);

        // Max is 15, + 20% = 18.0
        expect(maxY, equals(18.0));
      });

      test("should return 5.0 for all-zero spots", () {
        final helper = PromoterDetailChartHelper(
          recommendations: [],
          selectedDays: 7,
        );

        final spots = [FlSpot(0, 0), FlSpot(1, 0)];
        final maxY = helper.calculateMaxY([spots]);

        expect(maxY, equals(5.0));
      });
    });

    group("xAxisInterval", () {
      test("should return 1 for 7 days", () {
        final helper = PromoterDetailChartHelper(
          recommendations: [],
          selectedDays: 7,
        );

        expect(helper.xAxisInterval, equals(1));
      });

      test("should return 5 for 30 days", () {
        final helper = PromoterDetailChartHelper(
          recommendations: [],
          selectedDays: 30,
        );

        expect(helper.xAxisInterval, equals(5));
      });

      test("should return 5 for values between 8 and 30", () {
        final helper = PromoterDetailChartHelper(
          recommendations: [],
          selectedDays: 14,
        );

        expect(helper.xAxisInterval, equals(5));
      });

      test("should return 15 for 90 days", () {
        final helper = PromoterDetailChartHelper(
          recommendations: [],
          selectedDays: 90,
        );

        expect(helper.xAxisInterval, equals(15));
      });
    });

    group("getYAxisInterval", () {
      test("should return 2 for maxY <= 10", () {
        final helper = PromoterDetailChartHelper(
          recommendations: [],
          selectedDays: 7,
        );

        expect(helper.getYAxisInterval(5), equals(2));
        expect(helper.getYAxisInterval(10), equals(2));
      });

      test("should return 5 for maxY <= 20", () {
        final helper = PromoterDetailChartHelper(
          recommendations: [],
          selectedDays: 7,
        );

        expect(helper.getYAxisInterval(11), equals(5));
        expect(helper.getYAxisInterval(20), equals(5));
      });

      test("should return 10 for maxY <= 50", () {
        final helper = PromoterDetailChartHelper(
          recommendations: [],
          selectedDays: 7,
        );

        expect(helper.getYAxisInterval(21), equals(10));
        expect(helper.getYAxisInterval(50), equals(10));
      });

      test("should return 20 for maxY > 50", () {
        final helper = PromoterDetailChartHelper(
          recommendations: [],
          selectedDays: 7,
        );

        expect(helper.getYAxisInterval(51), equals(20));
        expect(helper.getYAxisInterval(100), equals(20));
      });
    });

    group("getXAxisLabel", () {
      test("should return short day name for 7-day period", () {
        final helper = PromoterDetailChartHelper(
          recommendations: [],
          selectedDays: 7,
        );

        final label = helper.getXAxisLabel(6); // today
        expect(label, isNotEmpty);
        // Short day names in German: Mo, Di, Mi, Do, Fr, Sa, So
        expect(label.length, lessThanOrEqualTo(3));
      });

      test("should return dd.MM format for 30-day period", () {
        final helper = PromoterDetailChartHelper(
          recommendations: [],
          selectedDays: 30,
        );

        final label = helper.getXAxisLabel(29); // today
        expect(label, contains("."));
        expect(label.length, equals(5)); // dd.MM
      });

      test("should return dd.MM format for 90-day period", () {
        final helper = PromoterDetailChartHelper(
          recommendations: [],
          selectedDays: 90,
        );

        final label = helper.getXAxisLabel(89); // today
        expect(label, contains("."));
        expect(label.length, equals(5));
      });
    });

    group("campaign recommendations", () {
      UserRecommendation createCampaignRecommendation({
        required String id,
        required DateTime createdAt,
        int successful = 0,
        int linkClicked = 0,
      }) {
        return UserRecommendation(
          id: UniqueID.fromUniqueString(id),
          recoID: id,
          userID: "user-1",
          priority: RecommendationPriority.medium,
          notes: null,
          recommendation: CampaignRecommendationItem(
            id: id,
            campaignName: "Campaign $id",
            campaignDurationDays: 30,
            reason: "Test",
            landingPageID: "lp-1",
            promotionTemplate: null,
            promoterName: "Test User",
            serviceProviderName: null,
            defaultLandingPageID: null,
            userID: "user-1",
            promoterImageDownloadURL: null,
            statusCounts: RecommendationStatusCounts(
              linkClicked: linkClicked,
              successful: successful,
            ),
            createdAt: createdAt,
          ),
        );
      }

      test("should count campaign with successful > 0 as conversion", () {
        final recommendations = [
          createCampaignRecommendation(
              id: "c1", createdAt: DateTime.now(), successful: 3),
          createCampaignRecommendation(
              id: "c2", createdAt: DateTime.now(), successful: 0),
          createRecommendation(
              id: "p1",
              statusLevel: StatusLevel.successful,
              createdAt: DateTime.now()),
        ];

        final helper = PromoterDetailChartHelper(
          recommendations: recommendations,
          selectedDays: 7,
        );

        expect(helper.conversions.length, equals(2));
      });

      test("should count campaign with successful == 0 as nonSuccessful", () {
        final recommendations = [
          createCampaignRecommendation(
              id: "c1", createdAt: DateTime.now(), successful: 0),
          createCampaignRecommendation(
              id: "c2", createdAt: DateTime.now(), successful: 2),
        ];

        final helper = PromoterDetailChartHelper(
          recommendations: recommendations,
          selectedDays: 7,
        );

        expect(helper.nonSuccessful.length, equals(1));
      });

      test("should use createdAt for campaign spots", () {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        final recommendations = [
          createCampaignRecommendation(
              id: "c1", createdAt: today, successful: 1),
        ];

        final helper = PromoterDetailChartHelper(
          recommendations: recommendations,
          selectedDays: 7,
        );

        final spots = helper.generateSpots(recommendations);

        // Last spot (index 6) = today
        expect(spots.last.y, equals(1.0));
      });

      test("should count mixed personalized and campaign recommendations on correct days", () {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        final recommendations = [
          createRecommendation(
              id: "p1",
              statusLevel: StatusLevel.recommendationSend,
              createdAt: today),
          createCampaignRecommendation(
              id: "c1", createdAt: today, successful: 1),
        ];

        final helper = PromoterDetailChartHelper(
          recommendations: recommendations,
          selectedDays: 7,
        );

        final spots = helper.generateSpots(recommendations);

        expect(spots.last.y, equals(2.0));
      });
    });
  });
}
