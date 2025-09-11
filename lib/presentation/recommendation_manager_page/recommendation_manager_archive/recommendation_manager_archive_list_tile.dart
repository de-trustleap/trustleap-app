import 'package:finanzbegleiter/domain/entities/archived_recommendation_item.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_archive/recommendation_manager_archive_list_tile_title.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_archive/recommendation_manager_archive_list_tile_content.dart';
import 'package:flutter/material.dart';

class RecommendationManagerArchiveListTile extends StatelessWidget {
  final ArchivedRecommendationItem recommendation;
  final bool isPromoter;
  const RecommendationManagerArchiveListTile(
      {super.key, required this.recommendation, required this.isPromoter});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

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
