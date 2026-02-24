import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/recommendations/domain/campaign_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/personalized_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_status_counts.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/features/dashboard/presentation/widgets/dashboard_recommendations/dashboard_recommendations_chart_data_processor.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    // Initialize locale data for DateFormat
    await initializeDateFormatting('de_DE', null);
  });

  group('DashboardRecommendationsChartDataProcessor', () {
    late DashboardRecommendationsChartDataProcessor processor;
    late List<UserRecommendation> testRecommendations;

    setUp(() {
      final now = DateTime.now();
      final recommendation1 = PersonalizedRecommendationItem(
        id: "1",
        name: "Test Recommendation 1",
        reason: "Test",
        landingPageID: "1",
        promotionTemplate: "",
        promoterName: "Test Promoter",
        serviceProviderName: "Test Service",
        defaultLandingPageID: "2",
        userID: "user1",
        statusLevel: StatusLevel.recommendationSend,
        statusTimestamps: {0: now.subtract(Duration(days: 1))},
        promoterImageDownloadURL: null,
      );

      final recommendation2 = PersonalizedRecommendationItem(
        id: "2",
        name: "Test Recommendation 2",
        reason: "Test",
        landingPageID: "1",
        promotionTemplate: "",
        promoterName: "Test Promoter",
        serviceProviderName: "Test Service",
        defaultLandingPageID: "2",
        userID: "user1",
        statusLevel: StatusLevel.contactFormSent,
        statusTimestamps: {0: now.subtract(Duration(days: 2))},
        promoterImageDownloadURL: null,
      );

      testRecommendations = [
        UserRecommendation(
          id: UniqueID.fromUniqueString("1"),
          recoID: "1",
          userID: "user1",
          priority: RecommendationPriority.medium,
  
          notes: "Test note",
          recommendation: recommendation1,
        ),
        UserRecommendation(
          id: UniqueID.fromUniqueString("2"),
          recoID: "2",
          userID: "user1",
          priority: RecommendationPriority.high,
  
          notes: "Test note 2",
          recommendation: recommendation2,
        ),
      ];
    });

    group('generateSpots', () {
      test('should generate spots for week period', () {
        processor = DashboardRecommendationsChartDataProcessor(
          recommendations: testRecommendations,
          timePeriod: TimePeriod.week,
        );

        final spots = processor.generateSpots();

        expect(spots.length, 7); // 7 days in a week
        expect(spots.every((spot) => spot.x >= 0 && spot.x <= 6), true);
        expect(spots.every((spot) => spot.y >= 0), true);
      });

      test('should generate spots for day period', () {
        processor = DashboardRecommendationsChartDataProcessor(
          recommendations: testRecommendations,
          timePeriod: TimePeriod.day,
        );

        final spots = processor.generateSpots();

        expect(spots.length, 24); // 24 hours in a day
        expect(spots.every((spot) => spot.x >= 0 && spot.x <= 23), true);
        expect(spots.every((spot) => spot.y >= 0), true);
      });

      test('should generate spots for month period', () {
        processor = DashboardRecommendationsChartDataProcessor(
          recommendations: testRecommendations,
          timePeriod: TimePeriod.month,
        );

        final spots = processor.generateSpots();

        expect(spots.length, 30); // 30 days in a month
        expect(spots.every((spot) => spot.x >= 0 && spot.x <= 29), true);
        expect(spots.every((spot) => spot.y >= 0), true);
      });

      test('should handle empty recommendations list', () {
        processor = DashboardRecommendationsChartDataProcessor(
          recommendations: [],
          timePeriod: TimePeriod.week,
        );

        final spots = processor.generateSpots();

        expect(spots.length, 7);
        expect(spots.every((spot) => spot.y == 0), true);
      });
    });

    group('getPeriodLength', () {
      test('should return correct length for day period', () {
        processor = DashboardRecommendationsChartDataProcessor(
          recommendations: testRecommendations,
          timePeriod: TimePeriod.day,
        );

        expect(processor.getPeriodLength(), 24);
      });

      test('should return correct length for week period', () {
        processor = DashboardRecommendationsChartDataProcessor(
          recommendations: testRecommendations,
          timePeriod: TimePeriod.week,
        );

        expect(processor.getPeriodLength(), 7);
      });

      test('should return correct length for month period', () {
        processor = DashboardRecommendationsChartDataProcessor(
          recommendations: testRecommendations,
          timePeriod: TimePeriod.month,
        );

        expect(processor.getPeriodLength(), 30);
      });
    });

    group('getXAxisLabel', () {
      test('should return correct labels for day period', () {
        processor = DashboardRecommendationsChartDataProcessor(
          recommendations: testRecommendations,
          timePeriod: TimePeriod.day,
        );

        expect(processor.getXAxisLabel(0), "00:00");
        expect(processor.getXAxisLabel(6), "06:00");
        expect(processor.getXAxisLabel(12), "12:00");
        expect(processor.getXAxisLabel(18), "18:00");
      });

      test('should return correct labels for week period', () {
        processor = DashboardRecommendationsChartDataProcessor(
          recommendations: testRecommendations,
          timePeriod: TimePeriod.week,
        );

        final label = processor.getXAxisLabel(0);
        expect(label.isNotEmpty, true);
      });

      test('should return correct labels for month period', () {
        processor = DashboardRecommendationsChartDataProcessor(
          recommendations: testRecommendations,
          timePeriod: TimePeriod.month,
        );

        final label = processor.getXAxisLabel(0);
        expect(label.contains('.'), true); // Should contain date format like "01.01"
      });
    });

    group('getXAxisInterval', () {
      test('should return correct interval for day period', () {
        processor = DashboardRecommendationsChartDataProcessor(
          recommendations: testRecommendations,
          timePeriod: TimePeriod.day,
        );

        expect(processor.getXAxisInterval(), 6);
      });

      test('should return correct interval for week period', () {
        processor = DashboardRecommendationsChartDataProcessor(
          recommendations: testRecommendations,
          timePeriod: TimePeriod.week,
        );

        expect(processor.getXAxisInterval(), 1);
      });

      test('should return correct interval for month period', () {
        processor = DashboardRecommendationsChartDataProcessor(
          recommendations: testRecommendations,
          timePeriod: TimePeriod.month,
        );

        expect(processor.getXAxisInterval(), 5);
      });
    });

    group('getMaxY', () {
      test('should return minimum value when no recommendations', () {
        processor = DashboardRecommendationsChartDataProcessor(
          recommendations: [],
          timePeriod: TimePeriod.week,
        );

        expect(processor.getMaxY(), 10);
      });

      test('should return calculated max with padding', () {
        processor = DashboardRecommendationsChartDataProcessor(
          recommendations: testRecommendations,
          timePeriod: TimePeriod.week,
        );

        final maxY = processor.getMaxY();
        expect(maxY >= 5.0, true); // Should be at least minimum value
      });
    });

    group('getYAxisInterval', () {
      test('should return correct interval for different max values', () {
        processor = DashboardRecommendationsChartDataProcessor(
          recommendations: [],
          timePeriod: TimePeriod.week,
        );

        // With empty recommendations, maxY should be 10
        expect(processor.getYAxisInterval(), 2);
      });
    });

    group('status level filtering', () {
      test('should filter recommendations by status level', () {
        processor = DashboardRecommendationsChartDataProcessor(
          recommendations: testRecommendations,
          timePeriod: TimePeriod.week,
          statusLevel: 1, // Should match StatusLevel.recommendationSend (index 0)
        );

        final spots = processor.generateSpots();
        expect(spots.length, 7);
        
        // Should only count recommendations with statusLevel.index == 0
        final totalCount = spots.map((spot) => spot.y).reduce((a, b) => a + b);
        expect(totalCount, 1); // Only one recommendation should match
      });

      test('should include all recommendations when no status level filter', () {
        processor = DashboardRecommendationsChartDataProcessor(
          recommendations: testRecommendations,
          timePeriod: TimePeriod.week,
          statusLevel: null,
        );

        final spots = processor.generateSpots();
        expect(spots.length, 7);

        // Should count all recommendations
        final totalCount = spots.map((spot) => spot.y).reduce((a, b) => a + b);
        expect(totalCount, 2); // Both recommendations should be counted
      });
    });

    group('campaign recommendations', () {
      late List<UserRecommendation> mixedRecommendations;

      setUp(() {
        final now = DateTime.now();

        final campaignReco = CampaignRecommendationItem(
          id: "c1",
          campaignName: "Test Campaign",
          campaignDurationDays: 30,
          reason: "Test",
          landingPageID: "1",
          promotionTemplate: null,
          promoterName: "Test Promoter",
          serviceProviderName: "Test Service",
          defaultLandingPageID: null,
          userID: "user1",
          promoterImageDownloadURL: null,
          statusCounts: const RecommendationStatusCounts(
            linkClicked: 10,
            contactFormSent: 5,
            appointment: 3,
            successful: 2,
            failed: 1,
          ),
          createdAt: now.subtract(const Duration(days: 1)),
        );

        final personalizedReco = PersonalizedRecommendationItem(
          id: "p1",
          name: "Test Personalized",
          reason: "Test",
          landingPageID: "1",
          promotionTemplate: "",
          promoterName: "Test Promoter",
          serviceProviderName: "Test Service",
          defaultLandingPageID: "2",
          userID: "user1",
          statusLevel: StatusLevel.successful,
          statusTimestamps: {
            0: now.subtract(const Duration(days: 3)),
            StatusLevel.successful.index: now.subtract(const Duration(days: 2)),
          },
          promoterImageDownloadURL: null,
        );

        mixedRecommendations = [
          UserRecommendation(
            id: UniqueID.fromUniqueString("c1"),
            recoID: "c1",
            userID: "user1",
            priority: RecommendationPriority.medium,
            notes: null,
            recommendation: campaignReco,
          ),
          UserRecommendation(
            id: UniqueID.fromUniqueString("p1"),
            recoID: "p1",
            userID: "user1",
            priority: RecommendationPriority.medium,
            notes: null,
            recommendation: personalizedReco,
          ),
        ];
      });

      test('should include campaign recommendations in spots without status filter', () {
        processor = DashboardRecommendationsChartDataProcessor(
          recommendations: mixedRecommendations,
          timePeriod: TimePeriod.week,
          statusLevel: null,
        );

        final spots = processor.generateSpots();
        final totalCount = spots.map((spot) => spot.y).reduce((a, b) => a + b);
        expect(totalCount, 2);
      });

      test('should include campaign when statusLevel filter matches successful', () {
        // statusLevel 5 maps to index 4 = StatusLevel.successful
        processor = DashboardRecommendationsChartDataProcessor(
          recommendations: mixedRecommendations,
          timePeriod: TimePeriod.week,
          statusLevel: 5,
        );

        final spots = processor.generateSpots();
        final totalCount = spots.map((spot) => spot.y).reduce((a, b) => a + b);
        // Both should match: personalized has statusLevel.successful, campaign has successful > 0
        expect(totalCount, 2);
      });

      test('should exclude campaign when statusCounts is zero for filtered level', () {
        final now = DateTime.now();
        final campaignNoAppointments = CampaignRecommendationItem(
          id: "c2",
          campaignName: "No Appointments",
          campaignDurationDays: 30,
          reason: "Test",
          landingPageID: "1",
          promotionTemplate: null,
          promoterName: "Test Promoter",
          serviceProviderName: "Test Service",
          defaultLandingPageID: null,
          userID: "user1",
          promoterImageDownloadURL: null,
          statusCounts: const RecommendationStatusCounts(
            linkClicked: 10,
            contactFormSent: 5,
            appointment: 0,
            successful: 0,
            failed: 0,
          ),
          createdAt: now.subtract(const Duration(days: 1)),
        );

        final recommendations = [
          UserRecommendation(
            id: UniqueID.fromUniqueString("c2"),
            recoID: "c2",
            userID: "user1",
            priority: RecommendationPriority.medium,
            notes: null,
            recommendation: campaignNoAppointments,
          ),
        ];

        // statusLevel 5 = index 4 = successful
        processor = DashboardRecommendationsChartDataProcessor(
          recommendations: recommendations,
          timePeriod: TimePeriod.week,
          statusLevel: 5,
        );

        final spots = processor.generateSpots();
        final totalCount = spots.map((spot) => spot.y).reduce((a, b) => a + b);
        expect(totalCount, 0);
      });
    });
  });
}