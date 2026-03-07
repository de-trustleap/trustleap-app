import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_overview/recommendation_manager_expandable_filter.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class RecommendationManagerFilterBottomSheet extends StatelessWidget {
  final bool isArchive;
  final bool isCampaign;
  final Function(RecommendationOverviewFilterStates) onFilterChanged;

  const RecommendationManagerFilterBottomSheet({
    super.key,
    required this.isArchive,
    required this.isCampaign,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).padding.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isCampaign
                    ? localization.campaign_manager_filter_title
                    : localization.recommendation_manager_filter_title,
                style: themeData.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),
          RecommendationManagerExpandableFilter(
            onFilterChanged: onFilterChanged,
            isArchive: isArchive,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
