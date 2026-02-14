// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/promoter/presentation/widgets/promoter_overview/promoters_overview_page.dart';
import 'package:flutter/material.dart';

class PromoterOverviewViewStateButton extends StatelessWidget {
  final PromotersOverviewViewState currentViewState;
  final Function(PromotersOverviewViewState) onSelected;

  const PromoterOverviewViewStateButton({
    super.key,
    required this.currentViewState,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return SegmentedButton<PromotersOverviewViewState>(
        segments: [
          ButtonSegment<PromotersOverviewViewState>(
              value: PromotersOverviewViewState.grid,
              tooltip: localization.promoter_overview_view_switch_grid_tooltip,
              icon: const Icon(Icons.grid_on)),
          ButtonSegment<PromotersOverviewViewState>(
              value: PromotersOverviewViewState.list,
              tooltip: localization.promoter_overview_view_switch_table_tooltip,
              icon: const Icon(Icons.format_list_bulleted))
        ],
        showSelectedIcon: false,
        selected: {currentViewState},
        onSelectionChanged: (Set<PromotersOverviewViewState> newSelectedValue) {
          onSelected(newSelectedValue.first);
        });
  }
}
