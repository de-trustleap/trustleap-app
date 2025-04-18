import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_helper.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_manager_status_progress_indicator.dart';
import 'package:flutter/material.dart';

class RecommendationManagerListTile extends StatelessWidget {
  final RecommendationItem recommendation;
  final bool isPromoter;
  const RecommendationManagerListTile(
      {super.key, required this.recommendation, required this.isPromoter});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final helper = RecommendationManagerHelper(localization: localization);
    return CollapsibleTile(
        backgroundColor: themeData.colorScheme.surface,
        showDivider: false,
        titleWidget: Row(children: [
          Flexible(
              flex: 3,
              child: _buildCell(
                  isPromoter
                      ? recommendation.name ?? ""
                      : recommendation.promoterName ?? "",
                  themeData)),
          Flexible(
              flex: 3,
              child: _buildCell(
                  helper.getStringFromStatusLevel(recommendation.statusLevel) ??
                      "",
                  themeData)),
          Flexible(
              flex: 2,
              child: _buildCell(
                  helper.getExpiresInDaysCount(recommendation.expiresAt),
                  themeData)),
          const SizedBox(width: 8)
        ]),
        children: [
          const Text("TEST"),
          RecommendationManagerStatusProgressIndicator(
              level: recommendation.statusLevel ?? 0,
              statusTimestamps: recommendation.statusTimestamps ?? {})
        ]);
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
