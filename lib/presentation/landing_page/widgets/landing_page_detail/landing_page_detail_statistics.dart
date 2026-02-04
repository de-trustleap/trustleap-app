import 'package:finanzbegleiter/application/dashboard/recommendation/dashboard_recommendations_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_recommendations/dashboard_recommendations_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageDetailStatistics extends StatelessWidget {
  final int visitsTotal;
  final String landingPageId;
  final CustomUser user;

  const LandingPageDetailStatistics({
    super.key,
    required this.visitsTotal,
    required this.landingPageId,
    required this.user,
  });

  int _getCompletedRecommendationsCount(
      DashboardRecommendationsGetRecosSuccessState state) {
    final recommendations =
        DashboardRecommendationsHelper.getFilteredRecommendations(
      state: state,
      selectedPromoterId: null,
      userRole: user.role ?? Role.none,
      selectedLandingPageId: landingPageId,
    );

    return recommendations
        .where(
            (rec) => rec.recommendation?.statusLevel == StatusLevel.successful)
        .length;
  }

  double _getConversionRate(int completedRecommendations) {
    if (visitsTotal == 0) return 0;
    return (completedRecommendations / visitsTotal) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    final recommendationsCubit = Modular.get<DashboardRecommendationsCubit>();

    return BlocBuilder<DashboardRecommendationsCubit,
        DashboardRecommendationsState>(
      bloc: recommendationsCubit,
      builder: (context, state) {
        final completedRecommendations =
            state is DashboardRecommendationsGetRecosSuccessState
                ? _getCompletedRecommendationsCount(state)
                : 0;
        final conversionRate = _getConversionRate(completedRecommendations);

        if (responsiveValue.largerThan(MOBILE)) {
          return Row(
            children: [
              Expanded(
                child: _StatisticCard(
                  icon: Icons.people_outline,
                  title: localization.landing_page_detail_total_visits,
                  value: visitsTotal.toString(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatisticCard(
                  icon: Icons.trending_up,
                  title: localization.landing_page_detail_conversion_rate,
                  value: "${conversionRate.toStringAsFixed(1)}%",
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              _StatisticCard(
                icon: Icons.people_outline,
                title: localization.landing_page_detail_total_visits,
                value: visitsTotal.toString(),
              ),
              const SizedBox(height: 16),
              _StatisticCard(
                icon: Icons.trending_up,
                title: localization.landing_page_detail_conversion_rate,
                value: "${conversionRate.toStringAsFixed(1)}%",
              ),
            ],
          );
        }
      },
    );
  }
}

class _StatisticCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _StatisticCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return CardContainer(
      maxWidth: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: themeData.colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: themeData.colorScheme.secondary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                title,
                style: themeData.textTheme.bodySmall?.copyWith(
                  color: themeData.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              SelectableText(
                value,
                style: themeData.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
