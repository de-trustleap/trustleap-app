import 'package:finanzbegleiter/features/recommendations/domain/archived_recommendation_item.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_archive/campaign_archive_list_tile_title.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_archive/campaign_archive_list_tile_content.dart';
import 'package:flutter/material.dart';

class CampaignArchiveListTile extends StatelessWidget {
  final ArchivedRecommendationItem recommendation;
  const CampaignArchiveListTile({super.key, required this.recommendation});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return CollapsibleTile(
        backgroundColor: themeData.colorScheme.surface,
        showDivider: false,
        titleWidget: CampaignArchiveListTileTitle(
          recommendation: recommendation,
        ),
        children: [
          CampaignArchiveListTileContent(
            recommendation: recommendation,
          ),
        ]);
  }
}
