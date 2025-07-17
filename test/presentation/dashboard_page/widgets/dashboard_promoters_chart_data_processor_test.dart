import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_promoters/dashboard_promoters_chart_data_processor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  late DashboardPromotersChartDataProcessor processor;
  late List<CustomUser> testPromoters;
  late DateTime now;

  setUpAll(() async {
    await initializeDateFormatting('de_DE');
  });

  setUp(() {
    now = DateTime.now();
    testPromoters = [
      CustomUser(
        id: UniqueID.fromUniqueString("1"),
        email: "promoter1@example.com",
        firstName: "Promoter",
        lastName: "One",
        role: Role.promoter,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      CustomUser(
        id: UniqueID.fromUniqueString("2"),
        email: "promoter2@example.com",
        firstName: "Promoter",
        lastName: "Two",
        role: Role.promoter,
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      CustomUser(
        id: UniqueID.fromUniqueString("3"),
        email: "promoter3@example.com",
        firstName: "Promoter",
        lastName: "Three",
        role: Role.promoter,
        createdAt: now.subtract(const Duration(days: 30)),
      ),
    ];
  });

  group("DashboardPromotersChartDataProcessor_getPeriodLength", () {
    test("should return 7 for week period", () {
      processor = DashboardPromotersChartDataProcessor(
        promoters: testPromoters,
        timePeriod: TimePeriod.week,
      );

      expect(processor.getPeriodLength(), 7);
    });

    test("should return 30 for month period", () {
      processor = DashboardPromotersChartDataProcessor(
        promoters: testPromoters,
        timePeriod: TimePeriod.month,
      );

      expect(processor.getPeriodLength(), 30);
    });

    test("should return 12 for year period", () {
      processor = DashboardPromotersChartDataProcessor(
        promoters: testPromoters,
        timePeriod: TimePeriod.year,
      );

      expect(processor.getPeriodLength(), 12);
    });

    test("should return 7 for day period (fallback to week)", () {
      processor = DashboardPromotersChartDataProcessor(
        promoters: testPromoters,
        timePeriod: TimePeriod.day,
      );

      expect(processor.getPeriodLength(), 7);
    });
  });

  group("DashboardPromotersChartDataProcessor_generateSpots", () {
    test("should generate correct number of spots for week period", () {
      processor = DashboardPromotersChartDataProcessor(
        promoters: testPromoters,
        timePeriod: TimePeriod.week,
      );

      final spots = processor.generateSpots();

      expect(spots.length, 7);
      expect(spots.every((spot) => spot.x >= 0 && spot.x < 7), true);
    });

    test("should generate correct number of spots for month period", () {
      processor = DashboardPromotersChartDataProcessor(
        promoters: testPromoters,
        timePeriod: TimePeriod.month,
      );

      final spots = processor.generateSpots();

      expect(spots.length, 30);
      expect(spots.every((spot) => spot.x >= 0 && spot.x < 30), true);
    });

    test("should generate correct number of spots for year period", () {
      processor = DashboardPromotersChartDataProcessor(
        promoters: testPromoters,
        timePeriod: TimePeriod.year,
      );

      final spots = processor.generateSpots();

      expect(spots.length, 12);
      expect(spots.every((spot) => spot.x >= 0 && spot.x < 12), true);
    });

    test("should handle empty promoters list", () {
      processor = DashboardPromotersChartDataProcessor(
        promoters: [],
        timePeriod: TimePeriod.week,
      );

      final spots = processor.generateSpots();

      expect(spots.length, 7);
      expect(spots.every((spot) => spot.y == 0), true);
    });

    test("should handle promoters with null createdAt", () {
      final promotersWithNullDate = [
        CustomUser(
          id: UniqueID.fromUniqueString("1"),
          email: "promoter1@example.com",
          firstName: "Promoter",
          lastName: "One",
          role: Role.promoter,
          createdAt: null,
        ),
      ];

      processor = DashboardPromotersChartDataProcessor(
        promoters: promotersWithNullDate,
        timePeriod: TimePeriod.week,
      );

      final spots = processor.generateSpots();

      expect(spots.length, 7);
      expect(spots.every((spot) => spot.y == 0), true);
    });
  });

  group("DashboardPromotersChartDataProcessor_getXAxisInterval", () {
    test("should return 1 for week period", () {
      processor = DashboardPromotersChartDataProcessor(
        promoters: testPromoters,
        timePeriod: TimePeriod.week,
      );

      expect(processor.getXAxisInterval(), 1);
    });

    test("should return 5 for month period", () {
      processor = DashboardPromotersChartDataProcessor(
        promoters: testPromoters,
        timePeriod: TimePeriod.month,
      );

      expect(processor.getXAxisInterval(), 5);
    });

    test("should return 2 for year period", () {
      processor = DashboardPromotersChartDataProcessor(
        promoters: testPromoters,
        timePeriod: TimePeriod.year,
      );

      expect(processor.getXAxisInterval(), 2);
    });

    test("should return 1 for day period (fallback to week)", () {
      processor = DashboardPromotersChartDataProcessor(
        promoters: testPromoters,
        timePeriod: TimePeriod.day,
      );

      expect(processor.getXAxisInterval(), 1);
    });
  });

  group("DashboardPromotersChartDataProcessor_getXAxisLabel", () {
    test("should return weekday abbreviation for week period", () {
      processor = DashboardPromotersChartDataProcessor(
        promoters: testPromoters,
        timePeriod: TimePeriod.week,
      );

      final label = processor.getXAxisLabel(0);

      expect(label.length, greaterThan(0));
      expect(label.length, lessThan(4)); // Weekday abbreviations are typically 2-3 chars
    });

    test("should return day format for month period", () {
      processor = DashboardPromotersChartDataProcessor(
        promoters: testPromoters,
        timePeriod: TimePeriod.month,
      );

      final label = processor.getXAxisLabel(0);

      expect(label, matches(RegExp(r'^\d{2}\.\d{2}$'))); // Format: dd.MM
    });

    test("should return month abbreviation for year period", () {
      processor = DashboardPromotersChartDataProcessor(
        promoters: testPromoters,
        timePeriod: TimePeriod.year,
      );

      final label = processor.getXAxisLabel(0);

      expect(label.length, greaterThan(0));
      expect(label.length, lessThan(5)); // Month abbreviations are typically 3-4 chars
    });
  });

  group("DashboardPromotersChartDataProcessor_getMaxY", () {
    test("should return minimum of 10 for empty promoters", () {
      processor = DashboardPromotersChartDataProcessor(
        promoters: [],
        timePeriod: TimePeriod.week,
      );

      expect(processor.getMaxY(), 10);
    });

    test("should return value with 20% padding", () {
      // Create promoters all on the same day to get a higher count
      final sameDay = now.subtract(const Duration(days: 1));
      final promotersOnSameDay = List.generate(5, (index) => CustomUser(
        id: UniqueID.fromUniqueString("$index"),
        email: "promoter$index@example.com",
        firstName: "Promoter",
        lastName: "$index",
        role: Role.promoter,
        createdAt: sameDay,
      ));

      processor = DashboardPromotersChartDataProcessor(
        promoters: promotersOnSameDay,
        timePeriod: TimePeriod.week,
      );

      final maxY = processor.getMaxY();

      expect(maxY, greaterThan(5)); // Should be more than the count
      expect(maxY, lessThanOrEqualTo(6)); // Should be count + 20%
    });

    test("should return minimum of 5 when calculated value is very low", () {
      processor = DashboardPromotersChartDataProcessor(
        promoters: [testPromoters.first], // Only one promoter
        timePeriod: TimePeriod.week,
      );

      final maxY = processor.getMaxY();

      expect(maxY, greaterThanOrEqualTo(5));
    });
  });

  group("DashboardPromotersChartDataProcessor_getYAxisInterval", () {
    test("should return 2 for maxY <= 10", () {
      processor = DashboardPromotersChartDataProcessor(
        promoters: [],
        timePeriod: TimePeriod.week,
      );

      expect(processor.getYAxisInterval(), 2);
    });

    test("should return appropriate interval based on maxY", () {
      processor = DashboardPromotersChartDataProcessor(
        promoters: testPromoters,
        timePeriod: TimePeriod.week,
      );

      final interval = processor.getYAxisInterval();

      expect(interval, isIn([2, 5, 10, 20]));
    });
  });
}