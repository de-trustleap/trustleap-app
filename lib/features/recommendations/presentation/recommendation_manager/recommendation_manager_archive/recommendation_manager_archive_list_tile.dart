import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/features/recommendations/domain/archived_recommendation_detail_args.dart';
import 'package:finanzbegleiter/features/recommendations/domain/archived_recommendation_item.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_archive/recommendation_manager_archive_list_tile_title.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_archive/recommendation_manager_archive_list_tile_content.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';

class RecommendationManagerArchiveListTile extends StatelessWidget {
  final ArchivedRecommendationItem recommendation;
  final bool isPromoter;
  const RecommendationManagerArchiveListTile(
      {super.key, required this.recommendation, required this.isPromoter});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveHelper.of(context);
    final navigator = CustomNavigator.of(context);

    if (responsiveValue.isMobile) {
      return InkWell(
        onTap: () => navigator.pushNamed(
          RoutePaths.homePath +
              RoutePaths.recommendationManagerArchiveDetailPath,
          arguments: ArchivedRecommendationDetailArgs(
            recommendation: recommendation,
            isPromoter: isPromoter,
            isCampaign: false,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: RecommendationManagerArchiveListTileTitle(
                  recommendation: recommendation,
                  isPromoter: isPromoter,
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      );
    }

    return CollapsibleTile(
        backgroundColor: themeData.colorScheme.surface,
        showDivider: false,
        titleWidget: RecommendationManagerArchiveListTileTitle(
          recommendation: recommendation,
          isPromoter: isPromoter,
        ),
        children: [
          RecommendationManagerArchiveListTileContent(
            recommendation: recommendation,
          ),
        ]);
  }
}
