import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class RecommendationManagerListTileContent extends StatelessWidget {
  final UserRecommendation recommendation;

  const RecommendationManagerListTileContent({
    super.key,
    required this.recommendation,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveHelper.of(context);

    return responsiveValue.isMobile
        ? _buildMobileContent(themeData, localization)
        : _buildDesktopContent(themeData, localization);
  }

  Widget _buildMobileContent(ThemeData themeData, AppLocalizations localization) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  localization.recommendation_manager_list_tile_receiver,
                  style: themeData.textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text(recommendation.recommendation?.name ?? "",
                  style: themeData.textTheme.bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold))
            ]),
        const SizedBox(height: 16),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  localization.recommendation_manager_list_tile_reason,
                  style: themeData.textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text(recommendation.recommendation?.reason ?? "",
                  style: themeData.textTheme.bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold))
            ]),
      ],
    );
  }

  Widget _buildDesktopContent(ThemeData themeData, AppLocalizations localization) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    localization.recommendation_manager_list_tile_receiver,
                    style: themeData.textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text(recommendation.recommendation?.name ?? "",
                    style: themeData.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold))
              ]),
          const Spacer(),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    localization.recommendation_manager_list_tile_reason,
                    style: themeData.textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text(recommendation.recommendation?.reason ?? "",
                    style: themeData.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold))
              ])
        ]);
  }
}