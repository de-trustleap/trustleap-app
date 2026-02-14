import 'package:finanzbegleiter/features/promoter/application/promoter_detail/promoter_detail_cubit.dart';
import 'package:finanzbegleiter/features/dashboard/domain/line_series_data.dart';
import 'package:finanzbegleiter/features/promoter/domain/promoter.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/custom_line_chart.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/underlined_dropdown.dart';
import 'package:finanzbegleiter/features/promoter/presentation/widgets/promoter_detail/promoter_detail_chart_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PromoterDetailChart extends StatefulWidget {
  final Promoter promoter;

  const PromoterDetailChart({super.key, required this.promoter});

  @override
  State<PromoterDetailChart> createState() => _PromoterDetailChartState();
}

class _PromoterDetailChartState extends State<PromoterDetailChart> {
  int _selectedDays = 30;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final promoterDetailCubit = Modular.get<PromoterDetailCubit>();

    return CardContainer(
      maxWidth: double.infinity,
      child: BlocBuilder<PromoterDetailCubit, PromoterDetailState>(
        bloc: promoterDetailCubit,
        builder: (context, state) {
          if (state is! PromoterDetailLoaded) {
            return const LoadingIndicator();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      localization.promoter_detail_chart_title,
                      style: themeData.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  UnderlinedDropdown<int>(
                    value: _selectedDays,
                    items: [
                      DropdownMenuItem(
                        value: 7,
                        child: Text(
                            localization.promoter_detail_chart_last_days('7')),
                      ),
                      DropdownMenuItem(
                        value: 30,
                        child: Text(
                            localization.promoter_detail_chart_last_days('30')),
                      ),
                      DropdownMenuItem(
                        value: 90,
                        child: Text(
                            localization.promoter_detail_chart_last_days('90')),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedDays = value);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                localization
                    .promoter_detail_chart_subtitle(_selectedDays.toString()),
                style: themeData.textTheme.bodySmall?.copyWith(
                  color:
                      themeData.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 12),
              _buildLegend(state, themeData, localization),
              const SizedBox(height: 16),
              if (state.recommendations != null)
                _buildChart(state, themeData, localization)
              else if (state.recommendationsFailure != null)
                Center(
                  child: Text(
                    localization.promoter_detail_error_loading,
                    style: themeData.textTheme.bodyMedium,
                  ),
                )
              else
                const LoadingIndicator(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLegend(
    PromoterDetailLoaded state,
    ThemeData themeData,
    AppLocalizations localization,
  ) {
    final locale = Localizations.localeOf(context).languageCode;
    final hasConversions = state.recommendations != null &&
        PromoterDetailChartHelper(
          recommendations: state.recommendations!,
          selectedDays: _selectedDays,
          locale: locale,
        ).hasConversionsInTimeframe;

    return Row(
      children: [
        _buildLegendItem(
          themeData.colorScheme.primary,
          localization.promoter_detail_chart_recommendations,
          themeData,
        ),
        if (hasConversions) ...[
          const SizedBox(width: 24),
          _buildLegendItem(
            themeData.colorScheme.secondary,
            localization.promoter_detail_conversions,
            themeData,
          ),
        ],
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label, ThemeData themeData) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: themeData.textTheme.bodySmall?.copyWith(
            color: themeData.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildChart(
    PromoterDetailLoaded state,
    ThemeData themeData,
    AppLocalizations localization,
  ) {
    final locale = Localizations.localeOf(context).languageCode;
    final helper = PromoterDetailChartHelper(
      recommendations: state.recommendations!,
      selectedDays: _selectedDays,
      locale: locale,
    );

    final recommendationSpots = helper.generateSpots(helper.nonSuccessful);
    final conversionSpots = helper.generateSpots(helper.conversions);
    final hasConversions = helper.hasConversionsInTimeframe;
    final maxY =
        helper.calculateMaxY([recommendationSpots, if (hasConversions) conversionSpots]);

    return CustomLineChart(
      series: [
        LineSeriesData(
          spots: recommendationSpots,
          color: themeData.colorScheme.primary,
        ),
        if (hasConversions)
          LineSeriesData(
            spots: conversionSpots,
            color: themeData.colorScheme.secondary,
          ),
      ],
      maxX: (_selectedDays - 1).toDouble(),
      maxY: maxY,
      xAxisInterval: helper.xAxisInterval,
      yAxisInterval: helper.getYAxisInterval(maxY),
      getXAxisLabel: helper.getXAxisLabel,
      emptyStateMessage:
          localization.dashboard_recommendations_chart_no_recommendations,
      isEmpty: state.recommendations!.isEmpty,
    );
  }
}
