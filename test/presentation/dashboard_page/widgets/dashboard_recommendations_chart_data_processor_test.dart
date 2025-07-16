import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_recommendations_chart_data_processor.dart';
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
      final recommendation1 = RecommendationItem(
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

      final recommendation2 = RecommendationItem(
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
          notesLastEdited: null,
          recommendation: recommendation1,
        ),
        UserRecommendation(
          id: UniqueID.fromUniqueString("2"),
          recoID: "2",
          userID: "user1",
          priority: RecommendationPriority.high,
  
          notes: "Test note 2",
          notesLastEdited: null,
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
  });
}