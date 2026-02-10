import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/domain/statistics/promoter_statistics.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/subtle_button.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_detail/assign_landing_page_dialog.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_detail/promoter_detail_landing_page_tile.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PromoterDetailLandingPagesSection extends StatelessWidget {
  final Promoter promoter;
  final List<LandingPage> landingPages;
  final List<UserRecommendation> recommendations;
  final VoidCallback onChanged;

  const PromoterDetailLandingPagesSection({
    super.key,
    required this.promoter,
    required this.landingPages,
    required this.recommendations,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final navigator = CustomNavigator.of(context);
    final isCompact =
        ResponsiveBreakpoints.of(context).smallerOrEqualTo(TABLET);

    return CardContainer(
      maxWidth: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localization.promoter_detail_landing_pages_title,
                      style: themeData.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      localization.promoter_detail_landing_pages_subtitle,
                      style: themeData.textTheme.bodySmall?.copyWith(
                        color: themeData.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              SubtleButton(
                title: localization.promoter_detail_assign_page,
                icon: Icons.add,
                onTap: () => _showAssignDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (landingPages.isEmpty)
            _buildEmptyState(themeData, localization)
          else ...[
            if (!isCompact) _buildTableHeader(themeData, localization),
            ...landingPages.map((lp) {
              final statistics =
                  const PromoterStatistics(promoterRecommendations: []);
              final stats =
                  statistics.getStatsForLandingPage(recommendations, lp.name);
              return PromoterDetailLandingPageTile(
                landingPage: lp,
                stats: stats,
                onTap: () => navigator.navigate(
                    "${RoutePaths.homePath}${RoutePaths.landingPageDetailPath}/${lp.id.value}"),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildTableHeader(ThemeData themeData, AppLocalizations localization) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              localization.promoter_detail_landing_page_name.toUpperCase(),
              style: themeData.textTheme.labelSmall?.copyWith(
                color: themeData.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              localization.promoter_detail_status.toUpperCase(),
              style: themeData.textTheme.labelSmall?.copyWith(
                color: themeData.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              localization.promoter_detail_chart_recommendations.toUpperCase(),
              style: themeData.textTheme.labelSmall?.copyWith(
                color: themeData.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              localization.promoter_detail_conversions.toUpperCase(),
              style: themeData.textTheme.labelSmall?.copyWith(
                color: themeData.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              localization.promoter_detail_conversion_rate.toUpperCase(),
              style: themeData.textTheme.labelSmall?.copyWith(
                color: themeData.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData themeData, AppLocalizations localization) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.airplanemode_active,
                color: themeData.colorScheme.secondary, size: 48),
            const SizedBox(height: 12),
            Text(
              localization.promoter_detail_no_landing_pages,
              style: TextStyle(color: themeData.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showAssignDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: AssignLandingPageDialog(
          promoter: promoter,
          currentlyAssigned: landingPages,
          onAssigned: onChanged,
        ),
      ),
    );
  }
}
