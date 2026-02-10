import 'package:finanzbegleiter/application/promoter/promoter_detail/promoter_detail_cubit.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/domain/entities/promoter_stats.dart';
import 'package:finanzbegleiter/domain/statistics/promoter_statistics.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PromoterDetailPerformanceCard extends StatelessWidget {
  final Promoter promoter;

  const PromoterDetailPerformanceCard({super.key, required this.promoter});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final promoterDetailCubit = Modular.get<PromoterDetailCubit>();

    return BlocBuilder<PromoterDetailCubit, PromoterDetailState>(
      bloc: promoterDetailCubit,
      builder: (context, state) {
        PromoterStats stats = const PromoterStats(shares: 0, conversions: 0);

        if (state is PromoterDetailRecommendationsSuccess &&
            state.promoterRecommendations != null) {
          final statistics = PromoterStatistics(
            promoterRecommendations: state.promoterRecommendations!,
          );
          stats = statistics.getStatsForPromoter(promoter.id.value);
        }

        return CardContainer(
          maxWidth: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localization.promoter_detail_performance_overview,
                style: themeData.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatBox(
                      themeData,
                      stats.shares.toString(),
                      localization.promoter_detail_shared_pages,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatBox(
                      themeData,
                      stats.conversions.toString(),
                      localization.promoter_detail_conversions,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: themeData.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localization.promoter_detail_conversion_rate
                              .toUpperCase(),
                          style: themeData.textTheme.labelSmall?.copyWith(
                            color: themeData.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(stats.performance * 100).toStringAsFixed(1)}%',
                          style: themeData.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: themeData.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.show_chart,
                      color: themeData.colorScheme.primary,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatBox(ThemeData themeData, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeData.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: themeData.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: themeData.textTheme.bodySmall?.copyWith(
              color: themeData.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
