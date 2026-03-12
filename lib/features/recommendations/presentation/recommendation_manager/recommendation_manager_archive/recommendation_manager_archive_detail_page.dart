import 'package:finanzbegleiter/features/recommendations/domain/archived_recommendation_detail_args.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_archive/campaign_archive_list_tile_content.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_archive/recommendation_manager_archive_list_tile_content.dart';
import 'package:flutter/material.dart';

class RecommendationManagerArchiveDetailPage extends StatelessWidget {
  final ArchivedRecommendationDetailArgs args;

  const RecommendationManagerArchiveDetailPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: args.isCampaign
          ? CampaignArchiveListTileContent(recommendation: args.recommendation)
          : RecommendationManagerArchiveListTileContent(
              recommendation: args.recommendation),
    );
  }
}
