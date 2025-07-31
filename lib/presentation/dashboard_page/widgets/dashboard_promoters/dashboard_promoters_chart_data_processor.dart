import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class DashboardPromotersChartDataProcessor {
  final List<CustomUser> promoters;
  final TimePeriod timePeriod;

  DashboardPromotersChartDataProcessor({
    required this.promoters,
    required this.timePeriod,
  });

  List<FlSpot> generateSpots() {
    final spots = <FlSpot>[];
    final now = DateTime.now();
    final promotersByPeriod = _groupPromotersByPeriod();

    final periodLength = getPeriodLength();

    for (int i = 0; i < periodLength; i++) {
      final date = _getDateForIndex(i, now);
      final count = promotersByPeriod[date] ?? 0;
      spots.add(FlSpot(i.toDouble(), count.toDouble()));
    }

    return spots;
  }

  int getPeriodLength() {
    switch (timePeriod) {
      case TimePeriod.day:
      case TimePeriod.week:
        return 7;
      case TimePeriod.month:
      case TimePeriod.quarter:
        return 30;
      case TimePeriod.year:
        return 12;
    }
  }

  DateTime _getDateForIndex(int index, DateTime now) {
    switch (timePeriod) {
      case TimePeriod.day:
      case TimePeriod.week:
        final day = now.subtract(Duration(days: 6 - index));
        return DateTime(day.year, day.month, day.day);
      case TimePeriod.month:
      case TimePeriod.quarter:
        final day = now.subtract(Duration(days: 29 - index));
        return DateTime(day.year, day.month, day.day);
      case TimePeriod.year:
        final month = DateTime(now.year, now.month - (11 - index), 1);
        return DateTime(month.year, month.month, 1);
    }
  }

  Map<DateTime, int> _groupPromotersByPeriod() {
    final Map<DateTime, int> groupedData = {};

    for (final promoter in promoters) {
      if (promoter.createdAt != null) {
        final dateKey = _getDateKeyForTimestamp(promoter.createdAt!);
        groupedData[dateKey] = (groupedData[dateKey] ?? 0) + 1;
      }
    }

    return groupedData;
  }

  DateTime _getDateKeyForTimestamp(DateTime timestamp) {
    switch (timePeriod) {
      case TimePeriod.day:
      case TimePeriod.week:
      case TimePeriod.month:
      case TimePeriod.quarter:
        return DateTime(timestamp.year, timestamp.month, timestamp.day);
      case TimePeriod.year:
        return DateTime(timestamp.year, timestamp.month, 1);
    }
  }

  String getXAxisLabel(int index) {
    final now = DateTime.now();

    switch (timePeriod) {
      case TimePeriod.day:
      case TimePeriod.week:
        final day = now.subtract(Duration(days: 6 - index));
        return DateFormat('E', 'de_DE').format(day);
      case TimePeriod.month:
      case TimePeriod.quarter:
        final day = now.subtract(Duration(days: 29 - index));
        return DateFormat('dd.MM').format(day);
      case TimePeriod.year:
        final month = DateTime(now.year, now.month - (11 - index), 1);
        return DateFormat('MMM', 'de_DE').format(month);
    }
  }

  double getXAxisInterval() {
    switch (timePeriod) {
      case TimePeriod.day:
      case TimePeriod.week:
        return 1; // Jeden Tag
      case TimePeriod.month:
      case TimePeriod.quarter:
        return 5; // Alle 5 Tage
      case TimePeriod.year:
        return 2; // Alle 2 Monate
    }
  }

  double getMaxY() {
    final promotersByPeriod = _groupPromotersByPeriod();
    if (promotersByPeriod.isEmpty) return 10;
    final maxValue = promotersByPeriod.values
        .fold(0, (max, count) => count > max ? count : max);
    // Add some padding to the top
    return (maxValue + (maxValue * 0.2)).clamp(5.0, double.infinity);
  }

  double getYAxisInterval() {
    final maxY = getMaxY();
    if (maxY <= 10) return 2;
    if (maxY <= 20) return 5;
    if (maxY <= 50) return 10;
    return 20;
  }
}
