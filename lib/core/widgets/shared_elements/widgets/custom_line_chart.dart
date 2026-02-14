import 'package:fl_chart/fl_chart.dart';
import 'package:finanzbegleiter/features/dashboard/domain/line_series_data.dart';
import 'package:flutter/material.dart';

class CustomLineChart extends StatelessWidget {
  final List<LineSeriesData> series;
  final double maxX;
  final double maxY;
  final double xAxisInterval;
  final double yAxisInterval;
  final String Function(int) getXAxisLabel;
  final String emptyStateMessage;
  final bool isEmpty;

  const CustomLineChart({
    super.key,
    required this.series,
    required this.maxX,
    required this.maxY,
    required this.xAxisInterval,
    required this.yAxisInterval,
    required this.getXAxisLabel,
    required this.emptyStateMessage,
    required this.isEmpty,
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
      child: isEmpty
          ? Center(
              child: Text(
                emptyStateMessage,
                style: themeData.textTheme.bodyMedium?.copyWith(
                  color: themeData.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          : _buildChart(themeData),
    );
  }

  Widget _buildChart(ThemeData themeData) {
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
                    color:
                        themeData.colorScheme.outline.withValues(alpha: 0.1),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    interval: xAxisInterval,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          getXAxisLabel(value.toInt()),
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
                    interval: yAxisInterval,
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
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: series
                  .map((s) => _buildLineBarData(s, themeData))
                  .toList(),
              minX: 0,
              maxX: maxX,
              minY: 0,
              maxY: maxY,
            ),
          ),
        ),
      ],
    );
  }

  LineChartBarData _buildLineBarData(
      LineSeriesData seriesData, ThemeData themeData) {
    return LineChartBarData(
      spots: seriesData.spots,
      isCurved: true,
      curveSmoothness: 0.3,
      color: seriesData.color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        checkToShowDot: (spot, barData) {
          return spot.y > 0;
        },
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: seriesData.color,
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
            seriesData.color.withValues(alpha: 0.2),
            seriesData.color.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}
