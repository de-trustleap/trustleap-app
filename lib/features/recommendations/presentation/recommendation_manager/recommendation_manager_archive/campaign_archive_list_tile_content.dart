import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/features/recommendations/domain/archived_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/campaign_recommendation_overview/campaign_recommendation_funnel_indicator.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class CampaignArchiveListTileContent extends StatelessWidget {
  final ArchivedRecommendationItem recommendation;

  const CampaignArchiveListTileContent({
    super.key,
    required this.recommendation,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveHelper.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        responsiveValue.isMobile
            ? _buildMobilePromoterReason(themeData, localization)
            : _buildDesktopPromoterReason(themeData, localization),
        const SizedBox(height: 16),
        CampaignRecommendationFunnelIndicator(
          statusCounts: recommendation.statusCounts,
        ),
      ],
    );
  }

  Widget _buildMobilePromoterReason(
      ThemeData themeData, AppLocalizations localization) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabelValue(
          localization.recommendation_manager_list_header_promoter,
          recommendation.promoterName ?? "",
          themeData,
        ),
        const SizedBox(height: 16),
        _buildLabelValue(
          localization.recommendation_manager_list_tile_reason,
          recommendation.reason ?? "",
          themeData,
        ),
      ],
    );
  }

  Widget _buildDesktopPromoterReason(
      ThemeData themeData, AppLocalizations localization) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLabelValue(
          localization.recommendation_manager_list_header_promoter,
          recommendation.promoterName ?? "",
          themeData,
        ),
        const Spacer(),
        _buildLabelValue(
          localization.recommendation_manager_list_tile_reason,
          recommendation.reason ?? "",
          themeData,
        ),
      ],
    );
  }

  Widget _buildLabelValue(String label, String value, ThemeData themeData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: themeData.textTheme.bodyMedium),
        const SizedBox(height: 4),
        Text(value,
            style: themeData.textTheme.bodyMedium!
                .copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
