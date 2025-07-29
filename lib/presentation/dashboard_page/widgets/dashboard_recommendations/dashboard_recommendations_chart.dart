import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_line_chart.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_recommendations/dashboard_recommendations_chart_data_processor.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_recommendations/dashboard_recommendations_helper.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_recommendations/dashboard_trend_arrow.dart';
import 'package:flutter/material.dart';

class DashboardRecommendationsChart extends StatelessWidget {
  final List<UserRecommendation> recommendations;
  final TimePeriod timePeriod;
  final int? statusLevel;
  final RecommendationTrend? trend;

  const DashboardRecommendationsChart({
    super.key,
    required this.recommendations,
    required this.timePeriod,
    this.statusLevel,
    this.trend,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final dataProcessor = DashboardRecommendationsChartDataProcessor(
      recommendations: recommendations,
      timePeriod: timePeriod,
      statusLevel: statusLevel,
    );

    final spots = dataProcessor.generateSpots();

    return Stack(
      children: [
        DashboardLineChart(
          spots: spots,
          maxX: (dataProcessor.getPeriodLength() - 1).toDouble(),
          maxY: dataProcessor.getMaxY(),
          xAxisInterval: dataProcessor.getXAxisInterval(),
          yAxisInterval: dataProcessor.getYAxisInterval(),
          getXAxisLabel: dataProcessor.getXAxisLabel,
          emptyStateMessage: localization.dashboard_recommendations_chart_no_recommendations,
          isEmpty: recommendations.isEmpty,
        ),
        if (trend != null && recommendations.isNotEmpty)
          Positioned(
            top: 8,
            right: 8,
            child: DashboardTrendArrow(trend: trend!),
          ),
      ],
    );
  }
}
