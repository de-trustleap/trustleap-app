import 'package:finanzbegleiter/core/helpers/conversion_rate_formatter.dart';
import 'package:finanzbegleiter/features/recommendations/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/features/recommendations/domain/campaign_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_helper.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_overview/recommendation_manager_favorite_button.dart';
import 'package:flutter/material.dart';

class CampaignRecommendationListTileTitle extends StatelessWidget {
  final UserRecommendation recommendation;
  final Function(UserRecommendation) onFavoritePressed;
  final RecommendationManagerTileCubit cubit;

  const CampaignRecommendationListTileTitle({
    super.key,
    required this.recommendation,
    required this.onFavoritePressed,
    required this.cubit,
  });

  String _getConversionRate() {
    final reco = recommendation.recommendation;
    if (reco is CampaignRecommendationItem && reco.statusCounts != null) {
      return ConversionRateFormatter.format(
        total: reco.statusCounts!.linkClicked,
        successful: reco.statusCounts!.successful,
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
        ? _buildMobileTitleWidget(helper, themeData, localization)
        : _buildDesktopTitleWidget(helper, themeData);
  }

  Widget _buildDesktopTitleWidget(
      RecommendationManagerHelper helper, ThemeData themeData) {
    return Row(children: [
      Flexible(
        flex: 3,
        child: _buildCell(
            recommendation.recommendation?.displayName ?? "", themeData),
      ),
      Flexible(
        flex: 2,
        child: _buildCell(_getConversionRate(), themeData),
      ),
      Flexible(
        flex: 2,
        child: _buildCell(
            helper.getExpiresInDaysCount(
                recommendation.recommendation?.expiresAt ?? DateTime.now()),
            themeData),
      ),
      Flexible(
        flex: 1,
        child: RecommendationManagerFavoriteButton(
            isFavorite: cubit.currentFavoriteRecommendationIDs
                .contains(recommendation.id.value),
            onPressed: () => onFavoritePressed(recommendation)),
      ),
      const SizedBox(width: 8),
    ]);
  }

  Widget _buildMobileTitleWidget(RecommendationManagerHelper helper,
      ThemeData themeData, AppLocalizations localization) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                recommendation.recommendation?.displayName ?? "",
                style: themeData.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            RecommendationManagerFavoriteButton(
              isFavorite: cubit.currentFavoriteRecommendationIDs
                  .contains(recommendation.id.value),
              onPressed: () => onFavoritePressed(recommendation),
            ),
          ],
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
              helper.getExpiresInDaysCount(
                  recommendation.recommendation?.expiresAt ?? DateTime.now()),
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
