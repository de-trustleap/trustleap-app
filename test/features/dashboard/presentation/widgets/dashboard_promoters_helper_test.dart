import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/features/dashboard/presentation/widgets/dashboard_promoters/dashboard_promoters_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("DashboardPromotersHelper", () {
    group("calculateTrend", () {
      late DateTime fixedNow;

      setUp(() {
        // Fixed time for consistent tests: July 29, 2025, 12:00 PM
        fixedNow = DateTime(2025, 7, 29, 12, 0, 0);
      });

      CustomUser createPromoter({
        required String id,
        required DateTime createdAt,
        String firstName = "Test",
        String lastName = "User",
      }) {
        return CustomUser(
          id: UniqueID.fromUniqueString(id),
          firstName: firstName,
          lastName: lastName,
          email: "$id@example.com",
          role: Role.promoter,
          createdAt: createdAt,
        );
      }

      group("Basic functionality", () {
        test("should calculate positive trend when current period has more promoters", () {
          final promoters = [
            // Current week promoters
            createPromoter(id: "current1", createdAt: DateTime(2025, 7, 24, 10, 0, 0)),
            createPromoter(id: "current2", createdAt: DateTime(2025, 7, 25, 14, 0, 0)),
            createPromoter(id: "current3", createdAt: DateTime(2025, 7, 26, 16, 0, 0)),
            // Previous week promoters
            createPromoter(id: "previous1", createdAt: DateTime(2025, 7, 17, 10, 0, 0)),
            createPromoter(id: "previous2", createdAt: DateTime(2025, 7, 18, 14, 0, 0)),
          ];

          final result = DashboardPromotersHelper.calculateTrend(
            promoters: promoters,
            timePeriod: TimePeriod.week,
            now: fixedNow,
          );

          expect(result.currentPeriodCount, greaterThan(result.previousPeriodCount));
          expect(result.percentageChange, greaterThan(0));
          expect(result.isIncreasing, isTrue);
          expect(result.isDecreasing, isFalse);
          expect(result.isStable, isFalse);
        });

        test("should calculate negative trend when current period has fewer promoters", () {
          final promoters = [
            // Current week promoters (fewer)
            createPromoter(id: "current1", createdAt: DateTime(2025, 7, 24, 10, 0, 0)),
            // Previous week promoters (more)
            createPromoter(id: "previous1", createdAt: DateTime(2025, 7, 17, 10, 0, 0)),
            createPromoter(id: "previous2", createdAt: DateTime(2025, 7, 18, 14, 0, 0)),
            createPromoter(id: "previous3", createdAt: DateTime(2025, 7, 19, 16, 0, 0)),
          ];

          final result = DashboardPromotersHelper.calculateTrend(
            promoters: promoters,
            timePeriod: TimePeriod.week,
            now: fixedNow,
          );

          expect(result.currentPeriodCount, lessThan(result.previousPeriodCount));
          expect(result.percentageChange, lessThan(0));
          expect(result.isIncreasing, isFalse);
          expect(result.isDecreasing, isTrue);
          expect(result.isStable, isFalse);
        });

        test("should calculate stable trend when counts are equal", () {
          final promoters = [
            // Current week promoters
            createPromoter(id: 'current1', createdAt: DateTime(2025, 7, 24, 10, 0, 0)),
            createPromoter(id: 'current2', createdAt: DateTime(2025, 7, 25, 14, 0, 0)),
            // Previous week promoters (same count)
            createPromoter(id: 'previous1', createdAt: DateTime(2025, 7, 17, 10, 0, 0)),
            createPromoter(id: 'previous2', createdAt: DateTime(2025, 7, 18, 14, 0, 0)),
          ];

          final result = DashboardPromotersHelper.calculateTrend(
            promoters: promoters,
            timePeriod: TimePeriod.week,
            now: fixedNow,
          );

          expect(result.currentPeriodCount, equals(result.previousPeriodCount));
          expect(result.percentageChange, equals(0.0));
          expect(result.isIncreasing, isFalse);
          expect(result.isDecreasing, isFalse);
          expect(result.isStable, isTrue);
        });
      });

      group("Different time periods", () {
        test("should work with month period", () {
          final promoters = [
            // Current month promoters
            createPromoter(id: "current1", createdAt: DateTime(2025, 7, 15, 10, 0, 0)),
            createPromoter(id: "current2", createdAt: DateTime(2025, 7, 20, 14, 0, 0)),
            // Previous month promoters
            createPromoter(id: "previous1", createdAt: DateTime(2025, 6, 15, 10, 0, 0)),
          ];

          final result = DashboardPromotersHelper.calculateTrend(
            promoters: promoters,
            timePeriod: TimePeriod.month,
            now: fixedNow,
          );

          expect(result.currentPeriodCount, greaterThan(0));
          expect(result.previousPeriodCount, greaterThan(0));
          expect(result.isIncreasing, isTrue);
        });

        test("should work with year period", () {
          final promoters = [
            // Current year promoters
            createPromoter(id: "current1", createdAt: DateTime(2025, 3, 15, 10, 0, 0)),
            createPromoter(id: "current2", createdAt: DateTime(2025, 5, 20, 14, 0, 0)),
            // Previous year promoters
            createPromoter(id: "previous1", createdAt: DateTime(2024, 3, 15, 10, 0, 0)),
          ];

          final result = DashboardPromotersHelper.calculateTrend(
            promoters: promoters,
            timePeriod: TimePeriod.year,
            now: fixedNow,
          );

          expect(result.currentPeriodCount, greaterThan(0));
          expect(result.previousPeriodCount, greaterThan(0));
          expect(result.isIncreasing, isTrue);
        });
      });

      group("Edge cases", () {
        test("should handle empty promoters list", () {
          final result = DashboardPromotersHelper.calculateTrend(
            promoters: [],
            timePeriod: TimePeriod.week,
            now: fixedNow,
          );

          expect(result.currentPeriodCount, equals(0));
          expect(result.previousPeriodCount, equals(0));
          expect(result.percentageChange, equals(0.0));
          expect(result.isIncreasing, isFalse);
          expect(result.isDecreasing, isFalse);
          expect(result.isStable, isTrue);
        });

        test("should handle promoters with null createdAt", () {
          final promoters = [
            createPromoter(id: "valid", createdAt: DateTime(2025, 7, 24, 10, 0, 0)),
            CustomUser(
              id: UniqueID.fromUniqueString("null-date"),
              firstName: "Null",
              lastName: "Date",
              email: "null@example.com",
              role: Role.promoter,
              createdAt: null, // null createdAt
            ),
          ];

          final result = DashboardPromotersHelper.calculateTrend(
            promoters: promoters,
            timePeriod: TimePeriod.week,
            now: fixedNow,
          );

          expect(result.currentPeriodCount, greaterThan(0)); // Only valid promoter counted
          expect(result.previousPeriodCount, equals(0));
        });

        test("should handle zero current count with positive previous count", () {
          final promoters = [
            // No current period promoters
            // Previous week promoters
            createPromoter(id: 'previous1', createdAt: DateTime(2025, 7, 17, 10, 0, 0)),
            createPromoter(id: 'previous2', createdAt: DateTime(2025, 7, 18, 14, 0, 0)),
          ];

          final result = DashboardPromotersHelper.calculateTrend(
            promoters: promoters,
            timePeriod: TimePeriod.week,
            now: fixedNow,
          );

          expect(result.currentPeriodCount, equals(0));
          expect(result.previousPeriodCount, greaterThan(0));
          expect(result.percentageChange, equals(-100.0));
          expect(result.isIncreasing, isFalse);
          expect(result.isDecreasing, isTrue);
          expect(result.isStable, isFalse);
        });

        test("should handle zero previous count with positive current count", () {
          final promoters = [
            // Current week promoters
            createPromoter(id: 'current1', createdAt: DateTime(2025, 7, 24, 10, 0, 0)),
            createPromoter(id: 'current2', createdAt: DateTime(2025, 7, 25, 14, 0, 0)),
            // No previous week promoters
          ];

          final result = DashboardPromotersHelper.calculateTrend(
            promoters: promoters,
            timePeriod: TimePeriod.week,
            now: fixedNow,
          );

          expect(result.currentPeriodCount, greaterThan(0));
          expect(result.previousPeriodCount, equals(0));
          expect(result.percentageChange, greaterThan(100)); // N * 100% calculation
          expect(result.isIncreasing, isTrue);
          expect(result.isDecreasing, isFalse);
          expect(result.isStable, isFalse);
        });
      });

      group("Threshold behavior", () {
        test("should respect 1% threshold for stability", () {
          // Create a scenario where the change is very small (under 1%)
          final promoters = [
            // Many current promoters to make percentage change small
            ...List.generate(100, (i) => createPromoter(
              id: "current$i",
              createdAt: DateTime(2025, 7, 24, 10 + (i % 12), 0, 0),
            )),
            // Slightly fewer previous promoters
            ...List.generate(99, (i) => createPromoter(
              id: "previous$i",
              createdAt: DateTime(2025, 7, 17, 10 + (i % 12), 0, 0),
            )),
          ];

          final result = DashboardPromotersHelper.calculateTrend(
            promoters: promoters,
            timePeriod: TimePeriod.week,
            now: fixedNow,
          );

          // The percentage change should be small
          expect(result.percentageChange.abs(), lessThan(2.0));
          
          // With small change, it might be marked as stable depending on threshold
          if (result.percentageChange.abs() <= 1.0) {
            expect(result.isStable, isTrue);
            expect(result.isIncreasing, isFalse);
            expect(result.isDecreasing, isFalse);
          } else {
            expect(result.isStable, isFalse);
          }
        });

        test("should mark significant changes as non-stable", () {
          final promoters = [
            // Current week: 3 promoters
            createPromoter(id: 'current1', createdAt: DateTime(2025, 7, 24, 10, 0, 0)),
            createPromoter(id: 'current2', createdAt: DateTime(2025, 7, 25, 14, 0, 0)),
            createPromoter(id: 'current3', createdAt: DateTime(2025, 7, 26, 16, 0, 0)),
            // Previous week: 1 promoter (200% increase)
            createPromoter(id: 'previous1', createdAt: DateTime(2025, 7, 17, 10, 0, 0)),
          ];

          final result = DashboardPromotersHelper.calculateTrend(
            promoters: promoters,
            timePeriod: TimePeriod.week,
            now: fixedNow,
          );

          expect(result.percentageChange.abs(), greaterThan(1.0));
          expect(result.isStable, isFalse);
          expect(result.isIncreasing, isTrue);
        });
      });
    });
  });
}