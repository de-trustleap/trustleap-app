import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/bottom_sheet_wrapper.dart';
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

    return BottomSheetWrapper(
      title: isCampaign
          ? localization.campaign_manager_filter_title
          : localization.recommendation_manager_filter_title,
      child: RecommendationManagerExpandableFilter(
        onFilterChanged: onFilterChanged,
        isArchive: isArchive,
      ),
    );
  }
}
