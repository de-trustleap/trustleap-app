import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/dashboard/domain/chart_trend.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/dashboard/domain/line_series_data.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/custom_line_chart.dart';
import 'package:finanzbegleiter/features/dashboard/presentation/widgets/dashboard_recommendations/dashboard_recommendations_chart_data_processor.dart';
import 'package:finanzbegleiter/features/dashboard/presentation/widgets/dashboard_recommendations/dashboard_trend_arrow.dart';
import 'package:flutter/material.dart';

class DashboardRecommendationsChart extends StatelessWidget {
  final List<UserRecommendation> recommendations;
  final TimePeriod timePeriod;
  final int? statusLevel;
  final ChartTrend? trend;

  const DashboardRecommendationsChart({
    super.key,
    required this.recommendations,
    required this.timePeriod,
    this.statusLevel,
    this.trend,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final dataProcessor = DashboardRecommendationsChartDataProcessor(
      recommendations: recommendations,
      timePeriod: timePeriod,
      statusLevel: statusLevel,
      locale: locale,
    );

    final spots = dataProcessor.generateSpots();

    return Stack(
      children: [
        CustomLineChart(
          series: [LineSeriesData(spots: spots, color: themeData.colorScheme.primary)],
          maxX: (dataProcessor.getPeriodLength() - 1).toDouble(),
          maxY: dataProcessor.getMaxY(),
          xAxisInterval: dataProcessor.getXAxisInterval(),
          yAxisInterval: dataProcessor.getYAxisInterval(),
          getXAxisLabel: dataProcessor.getXAxisLabel,
          emptyStateMessage:
              localization.dashboard_recommendations_chart_no_recommendations,
          isEmpty: recommendations.isEmpty,
        ),
        if (trend != null && recommendations.isNotEmpty)
          Positioned(
            top: 8,
            right: 8,
            child: ChartTrendArrow(trend: trend!),
          ),
      ],
    );
  }
}
