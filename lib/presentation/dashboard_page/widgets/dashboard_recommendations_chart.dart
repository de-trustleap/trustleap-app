import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardRecommendationsChart extends StatelessWidget {
  final List<UserRecommendation> recommendations;
  final TimePeriod timePeriod;
  final int? statusLevel;

  const DashboardRecommendationsChart({
    super.key,
    required this.recommendations,
    required this.timePeriod,
    this.statusLevel,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeData.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeData.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: recommendations.isEmpty
          ? Center(
              child: Text(
                "Keine Empfehlungen vorhanden",
                style: themeData.textTheme.bodyMedium?.copyWith(
                  color: themeData.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          : _buildChart(themeData),
    );
  }

  Widget _buildChart(ThemeData themeData) {
    final spots = _generateSpots();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: themeData.colorScheme.outline.withValues(alpha: 0.1),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    interval: _getXAxisInterval(),
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _getXAxisLabel(value.toInt()),
                          style: themeData.textTheme.bodySmall?.copyWith(
                            color: themeData.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: _getYAxisInterval(),
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: themeData.textTheme.bodySmall?.copyWith(
                          color: themeData.colorScheme.onSurfaceVariant,
                        ),
                      );
                    },
                  ),
                ),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  curveSmoothness: 0.3,
                  color: themeData.colorScheme.primary,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    checkToShowDot: (spot, barData) {
                      return spot.y > 0; // Nur Punkte zeigen wenn Wert > 0
                    },
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: themeData.colorScheme.primary,
                        strokeWidth: 2,
                        strokeColor: themeData.colorScheme.surface,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        themeData.colorScheme.primary.withValues(alpha: 0.2),
                        themeData.colorScheme.primary.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ],
              minX: 0,
              maxX: (_getPeriodLength() - 1).toDouble(),
              minY: 0,
              maxY: _getMaxY(),
            ),
          ),
        ),
      ],
    );
  }

  List<FlSpot> _generateSpots() {
    final spots = <FlSpot>[];
    final now = DateTime.now();
    final recommendationsByPeriod = _groupRecommendationsByPeriod();

    final periodLength = _getPeriodLength();
    
    for (int i = 0; i < periodLength; i++) {
      final date = _getDateForIndex(i, now);
      final count = recommendationsByPeriod[date] ?? 0;
      spots.add(FlSpot(i.toDouble(), count.toDouble()));
    }

    return spots;
  }
  
  int _getPeriodLength() {
    switch (timePeriod) {
      case TimePeriod.day:
        return 24; // 24 hours
      case TimePeriod.week:
        return 7; // 7 days
      case TimePeriod.month:
        return 30; // 30 days
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
        final day = now.subtract(Duration(days: 29 - index));
        return DateTime(day.year, day.month, day.day);
    }
  }

  Map<DateTime, int> _groupRecommendationsByPeriod() {
    final Map<DateTime, int> groupedData = {};
    
    // Filter recommendations by status level if specified
    final filteredRecommendations = statusLevel != null 
        ? recommendations.where((rec) => rec.recommendation?.statusLevel?.index == (statusLevel! - 1)).toList()
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
        return DateTime(timestamp.year, timestamp.month, timestamp.day, timestamp.hour);
      case TimePeriod.week:
      case TimePeriod.month:
        return DateTime(timestamp.year, timestamp.month, timestamp.day);
    }
  }
  
  String _getXAxisLabel(int index) {
    final now = DateTime.now();
    
    switch (timePeriod) {
      case TimePeriod.day:
        // Zeige runde Stunden: 00:00, 04:00, 08:00, etc.
        return '${index.toString().padLeft(2, '0')}:00';
      case TimePeriod.week:
        final day = now.subtract(Duration(days: 6 - index));
        return DateFormat('E', 'de_DE').format(day); // Mo, Di, Mi, etc.
      case TimePeriod.month:
        final day = now.subtract(Duration(days: 29 - index));
        return DateFormat('dd.MM').format(day); // 01.01, 02.01, etc.
    }
  }
  
  double _getXAxisInterval() {
    switch (timePeriod) {
      case TimePeriod.day:
        return 6; // Alle 6 Stunden (4 Labels: 0, 6, 12, 18)
      case TimePeriod.week:
        return 1; // Jeden Tag
      case TimePeriod.month:
        return 5; // Alle 5 Tage (6 Labels: 0, 5, 10, 15, 20, 25)
    }
  }

  double _getMaxY() {
    final recommendationsByPeriod = _groupRecommendationsByPeriod();
    if (recommendationsByPeriod.isEmpty) return 10;
    final maxValue = recommendationsByPeriod.values
        .fold(0, (max, count) => count > max ? count : max);
    // Add some padding to the top
    return (maxValue + (maxValue * 0.2)).clamp(5.0, double.infinity);
  }

  double _getYAxisInterval() {
    final maxY = _getMaxY();
    if (maxY <= 10) return 2;
    if (maxY <= 20) return 5;
    if (maxY <= 50) return 10;
    return 20;
  }
}
