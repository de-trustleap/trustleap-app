import 'package:finanzbegleiter/features/recommendations/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/features/recommendations/domain/personalized_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_helper.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_overview/recommendation_manager_favorite_button.dart';
import 'package:flutter/material.dart';

class RecommendationManagerListTileTitle extends StatelessWidget {
  final UserRecommendation recommendation;
  final bool isPromoter;
  final Function(UserRecommendation) onFavoritePressed;
  final RecommendationManagerTileCubit cubit;

  const RecommendationManagerListTileTitle({
    super.key,
    required this.recommendation,
    required this.isPromoter,
    required this.onFavoritePressed,
    required this.cubit,
  });

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

  Widget _buildDesktopTitleWidget(RecommendationManagerHelper helper, ThemeData themeData) {
    final reco = recommendation.recommendation;
    final personalizedReco = reco is PersonalizedRecommendationItem ? reco : null;
    return Row(children: [
      Flexible(
          flex: 1,
          child: _buildPriorityCell(recommendation.priority, themeData)),
      Flexible(
          flex: 3,
          child: _buildCell(
              isPromoter
                  ? reco?.displayName ?? ""
                  : reco?.promoterName ?? "",
              themeData)),
      Flexible(
          flex: 3,
          child: _buildCell(
              helper.getStringFromStatusLevel(personalizedReco?.statusLevel) ?? "",
              themeData)),
      Flexible(
          flex: 2,
          child: _buildCell(
              helper.getExpiresInDaysCount(
                  recommendation.recommendation?.expiresAt ??
                      DateTime.now()),
              themeData)),
      Flexible(
          flex: 1,
          child: RecommendationManagerFavoriteButton(
              isFavorite: cubit.currentFavoriteRecommendationIDs
                  .contains(recommendation.id.value),
              onPressed: () => onFavoritePressed(recommendation))),
      const SizedBox(width: 8)
    ]);
  }

  Widget _buildMobileTitleWidget(RecommendationManagerHelper helper, ThemeData themeData, AppLocalizations localization) {
    final reco = recommendation.recommendation;
    final personalizedReco = reco is PersonalizedRecommendationItem ? reco : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _getPriorityIcon(recommendation.priority, themeData),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isPromoter
                    ? reco?.displayName ?? ""
                    : reco?.promoterName ?? "",
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              helper.getStringFromStatusLevel(personalizedReco?.statusLevel) ?? "",
              style: themeData.textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              "${localization.recommendation_manager_list_header_expiration_date}: ${helper.getExpiresInDaysCount(recommendation.recommendation?.expiresAt ?? DateTime.now())}",
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

  Widget _buildPriorityCell(RecommendationPriority? priority, ThemeData themeData) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: _getPriorityIcon(priority, themeData));
  }

  Widget _getPriorityIcon(RecommendationPriority? priority, ThemeData themeData) {
    switch (priority) {
      case RecommendationPriority.low:
        return Icon(Icons.arrow_downward,
            size: 24, color: themeData.colorScheme.primary);
      case RecommendationPriority.high:
        return Icon(Icons.arrow_upward,
            size: 24, color: themeData.colorScheme.error);
      default:
        return const Icon(Icons.remove, size: 24, color: Colors.lightBlue);
    }
  }
}