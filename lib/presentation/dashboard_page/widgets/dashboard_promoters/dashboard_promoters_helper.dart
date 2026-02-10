import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/chart_trend.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';

class DashboardPromotersHelper {
  static ChartTrend calculateTrend({
    required List<CustomUser> promoters,
    required TimePeriod timePeriod,
    DateTime? now,
  }) {
    final currentTime = now ?? DateTime.now();

    final (currentPeriodStart, currentPeriodEnd) =
        _getPeriodBoundaries(currentTime, timePeriod);

    final (previousPeriodStart, previousPeriodEnd) = _getPeriodBoundaries(
        _getPreviousPeriodReference(currentTime, timePeriod), timePeriod);

    final currentPeriodCount = _countPromotersInPeriod(
        promoters, currentPeriodStart, currentPeriodEnd);

    final previousPeriodCount = _countPromotersInPeriod(
        promoters, previousPeriodStart, previousPeriodEnd);

    double percentageChange = 0.0;
    bool isIncreasing = false;
    bool isDecreasing = false;

    if (previousPeriodCount == 0) {
      if (currentPeriodCount > 0) {
        percentageChange = currentPeriodCount * 100.0;
        isIncreasing = true;
      }
    } else {
      percentageChange =
          ((currentPeriodCount - previousPeriodCount) / previousPeriodCount) *
              100;

      // Do not show changes under 1%
      const threshold = 1.0;
      if (percentageChange.abs() > threshold) {
        isIncreasing = percentageChange > 0;
        isDecreasing = percentageChange < 0;
      }
    }

    return ChartTrend(
      currentPeriodCount: currentPeriodCount,
      previousPeriodCount: previousPeriodCount,
      percentageChange: percentageChange,
      isIncreasing: isIncreasing,
      isDecreasing: isDecreasing,
    );
  }

  static (DateTime, DateTime) _getPeriodBoundaries(
      DateTime referenceDate, TimePeriod timePeriod) {
    switch (timePeriod) {
      case TimePeriod.month:
        final endOfMonth = referenceDate;
        final startOfMonth = endOfMonth.subtract(const Duration(days: 29));
        return (
          DateTime(startOfMonth.year, startOfMonth.month, startOfMonth.day),
          DateTime(
              endOfMonth.year, endOfMonth.month, endOfMonth.day, 23, 59, 59)
        );

      case TimePeriod.year:
        final endOfYear = referenceDate;
        final startOfYear =
            DateTime(endOfYear.year - 1, endOfYear.month, endOfYear.day);
        return (
          startOfYear,
          DateTime(endOfYear.year, endOfYear.month, endOfYear.day, 23, 59, 59)
        );

      case TimePeriod.week:
      default:
        final endOfWeek = referenceDate;
        final startOfWeek = endOfWeek.subtract(const Duration(days: 6));
        return (
          DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
          DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59)
        );
    }
  }

  static DateTime _getPreviousPeriodReference(
      DateTime currentReference, TimePeriod timePeriod) {
    switch (timePeriod) {
      case TimePeriod.month:
        return currentReference.subtract(const Duration(days: 30));
      case TimePeriod.year:
        return DateTime(currentReference.year - 1, currentReference.month,
            currentReference.day);
      case TimePeriod.week:
      default:
        return currentReference.subtract(const Duration(days: 7));
    }
  }

  static int _countPromotersInPeriod(
    List<CustomUser> promoters,
    DateTime periodStart,
    DateTime periodEnd,
  ) {
    return promoters.where((promoter) {
      if (promoter.createdAt == null) return false;
      final createdAt = promoter.createdAt!;
      return createdAt.isAfter(periodStart) && createdAt.isBefore(periodEnd);
    }).length;
  }
}
