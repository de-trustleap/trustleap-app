import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/dashboard_trend.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_line_chart.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_promoters/dashboard_promoters_chart_data_processor.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_recommendations/dashboard_trend_arrow.dart';
import 'package:flutter/material.dart';

class DashboardPromotersChart extends StatelessWidget {
  final List<CustomUser> promoters;
  final TimePeriod timePeriod;
  final DashboardTrend? trend;

  const DashboardPromotersChart({
    super.key,
    required this.promoters,
    required this.timePeriod,
    this.trend,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final dataProcessor = DashboardPromotersChartDataProcessor(
      promoters: promoters,
      timePeriod: timePeriod,
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
          emptyStateMessage: localization.dashboard_promoters_chart_no_promoters,
          isEmpty: promoters.isEmpty,
        ),
        if (trend != null && promoters.isNotEmpty)
          Positioned(
            top: 8,
            right: 8,
            child: DashboardTrendArrow(trend: trend!),
          ),
      ],
    );
  }
}