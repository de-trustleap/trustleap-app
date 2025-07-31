import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class DashboardRecommendationsChartDataProcessor {
  final List<UserRecommendation> recommendations;
  final TimePeriod timePeriod;
  final int? statusLevel;

  DashboardRecommendationsChartDataProcessor({
    required this.recommendations,
    required this.timePeriod,
    this.statusLevel,
  });

  List<FlSpot> generateSpots() {
    final spots = <FlSpot>[];
    final now = DateTime.now();
    final recommendationsByPeriod = _groupRecommendationsByPeriod();

    final periodLength = getPeriodLength();

    for (int i = 0; i < periodLength; i++) {
      final date = _getDateForIndex(i, now);
      final count = recommendationsByPeriod[date] ?? 0;
      spots.add(FlSpot(i.toDouble(), count.toDouble()));
    }

    return spots;
  }

  int getPeriodLength() {
    switch (timePeriod) {
      case TimePeriod.day:
        return 24;
      case TimePeriod.week:
        return 7;
      case TimePeriod.month:
      case TimePeriod.quarter:
      case TimePeriod.year:
        return 30;
    }
  }

  DateTime _getDateForIndex(int index, DateTime now) {
    switch (timePeriod) {
      case TimePeriod.day:
        final hour = now.subtract(Duration(hours: 23 - index));
        return DateTime(hour.year, hour.month, hour.day, hour.hour);
      case TimePeriod.week:
        final day = now.subtract(Duration(days: 6 - index));
        return DateTime(day.year, day.month, day.day);
      case TimePeriod.month:
      case TimePeriod.quarter:
      case TimePeriod.year:
        final day = now.subtract(Duration(days: 29 - index));
        return DateTime(day.year, day.month, day.day);
    }
  }

  Map<DateTime, int> _groupRecommendationsByPeriod() {
    final Map<DateTime, int> groupedData = {};

    final filteredRecommendations = statusLevel != null
        ? recommendations
            .where((rec) =>
                rec.recommendation?.statusLevel?.index == (statusLevel! - 1))
            .toList()
        : recommendations;

    for (final recommendation in filteredRecommendations) {
      final statusTimestamp =
          recommendation.recommendation?.statusTimestamps?[0];
      if (statusTimestamp != null) {
        final dateKey = _getDateKeyForTimestamp(statusTimestamp);
        groupedData[dateKey] = (groupedData[dateKey] ?? 0) + 1;
      }
    }

    return groupedData;
  }

  DateTime _getDateKeyForTimestamp(DateTime timestamp) {
    switch (timePeriod) {
      case TimePeriod.day:
        return DateTime(
            timestamp.year, timestamp.month, timestamp.day, timestamp.hour);
      case TimePeriod.week:
      case TimePeriod.month:
      case TimePeriod.quarter:
      case TimePeriod.year:
        return DateTime(timestamp.year, timestamp.month, timestamp.day);
    }
  }

  String getXAxisLabel(int index) {
    final now = DateTime.now();

    switch (timePeriod) {
      case TimePeriod.day:
        return '${index.toString().padLeft(2, '0')}:00';
      case TimePeriod.week:
        final day = now.subtract(Duration(days: 6 - index));
        return DateFormat('E', 'de_DE').format(day);
      case TimePeriod.month:
      case TimePeriod.quarter:
      case TimePeriod.year:
        final day = now.subtract(Duration(days: 29 - index));
        return DateFormat('dd.MM').format(day);
    }
  }

  double getXAxisInterval() {
    switch (timePeriod) {
      case TimePeriod.day:
        return 6; // Alle 6 Stunden (4 Labels: 0, 6, 12, 18)
      case TimePeriod.week:
        return 1; // Jeden Tag
      case TimePeriod.month:
      case TimePeriod.quarter:
      case TimePeriod.year:
        return 5; // Alle 5 Tage (6 Labels: 0, 5, 10, 15, 20, 25)
    }
  }

  double getMaxY() {
    final recommendationsByPeriod = _groupRecommendationsByPeriod();
    if (recommendationsByPeriod.isEmpty) return 10;
    final maxValue = recommendationsByPeriod.values
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
