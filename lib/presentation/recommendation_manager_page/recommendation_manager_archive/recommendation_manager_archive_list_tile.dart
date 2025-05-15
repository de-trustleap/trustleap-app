import 'package:finanzbegleiter/domain/entities/archived_recommendation_item.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_helper.dart';
import 'package:flutter/material.dart';

class RecommendationManagerArchiveListTile extends StatelessWidget {
  final ArchivedRecommendationItem recommendation;
  final bool isPromoter;
  const RecommendationManagerArchiveListTile(
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
                  helper.getStringFromArchivedStatus(recommendation.success) ??
                      "",
                  themeData)),
          Flexible(
              flex: 2,
              child: _buildCell(
                  helper.getDateText(context, recommendation.finishedTimeStamp),
                  themeData)),
          const SizedBox(width: 8)
        ]),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(localization.recommendation_manager_list_tile_receiver,
                    style: themeData.textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text(recommendation.name ?? "",
                    style: themeData.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold))
              ]),
              const Spacer(),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(localization.recommendation_manager_list_tile_reason,
                    style: themeData.textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text(recommendation.reason ?? "",
                    style: themeData.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold))
              ])
            ],
          )
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
