import 'package:finanzbegleiter/core/helpers/conversion_rate_formatter.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/features/recommendations/domain/archived_recommendation_item.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_helper.dart';
import 'package:flutter/material.dart';

class CampaignArchiveListTileTitle extends StatelessWidget {
  final ArchivedRecommendationItem recommendation;

  const CampaignArchiveListTileTitle({
    super.key,
    required this.recommendation,
  });

  String _getConversionRate() {
    final counts = recommendation.statusCounts;
    if (counts != null) {
      return ConversionRateFormatter.format(
        total: counts.linkClicked,
        successful: counts.successful,
      );
    }
    return ConversionRateFormatter.format(total: 0, successful: 0);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveHelper.of(context);
    final helper = RecommendationManagerHelper(localization: localization);

    return responsiveValue.isMobile
        ? _buildMobileTitle(helper, themeData, localization, context)
        : _buildDesktopTitle(helper, themeData, context);
  }

  Widget _buildDesktopTitle(
      RecommendationManagerHelper helper, ThemeData themeData, BuildContext context) {
    return Row(children: [
      Flexible(
          flex: 3,
          child: _buildCell(recommendation.campaignName ?? "", themeData)),
      Flexible(
          flex: 2,
          child: _buildCell(_getConversionRate(), themeData)),
      Flexible(
          flex: 2,
          child: _buildCell(
              helper.getDateText(context, recommendation.finishedTimeStamp),
              themeData)),
      const SizedBox(width: 8)
    ]);
  }

  Widget _buildMobileTitle(
      RecommendationManagerHelper helper,
      ThemeData themeData,
      AppLocalizations localization,
      BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          recommendation.campaignName ?? "",
          style: themeData.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              "${localization.campaign_manager_list_header_conversion_rate}: ${_getConversionRate()}",
              style: themeData.textTheme.bodyMedium,
            ),
            const SizedBox(width: 16),
            Text(
              helper.getDateText(context, recommendation.finishedTimeStamp),
              style: themeData.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCell(String text, ThemeData themeData) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.left,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: themeData.textTheme.bodyMedium,
      ),
    );
  }
}
