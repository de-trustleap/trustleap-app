import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/features/recommendations/domain/archived_recommendation_item.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_helper.dart';
import 'package:flutter/material.dart';

class RecommendationManagerArchiveListTileTitle extends StatelessWidget {
  final ArchivedRecommendationItem recommendation;
  final bool isPromoter;

  const RecommendationManagerArchiveListTileTitle({
    super.key,
    required this.recommendation,
    required this.isPromoter,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveHelper.of(context);
    final helper = RecommendationManagerHelper(localization: localization);

    return responsiveValue.isMobile 
        ? _buildMobileTitleWidget(helper, themeData, localization, context)
        : _buildDesktopTitleWidget(helper, themeData, context);
  }

  Widget _buildDesktopTitleWidget(RecommendationManagerHelper helper, ThemeData themeData, BuildContext context) {
    return Row(children: [
      Flexible(
          flex: 3,
          child: _buildCell(
              recommendation.promoterName ?? "",
              themeData)),
      Flexible(
          flex: 3,
          child: _buildCell(
              helper.getStringFromArchivedStatus(recommendation.success) ??
                  "",
              themeData)),
      Flexible(
          flex: 2,
          child: _buildCell(
              helper.getDateText(context, recommendation.finishedTimeStamp),
              themeData)),
      const SizedBox(width: 8)
    ]);
  }

  Widget _buildMobileTitleWidget(RecommendationManagerHelper helper, ThemeData themeData, AppLocalizations localization, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          recommendation.promoterName ?? "",
          style: themeData.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              helper.getStringFromArchivedStatus(recommendation.success) ?? "",
              style: themeData.textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              "${localization.recommendation_manager_finished_at_list_header}: ${helper.getDateText(context, recommendation.finishedTimeStamp)}",
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