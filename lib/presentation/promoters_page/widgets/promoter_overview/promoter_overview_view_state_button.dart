// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoters_overview_page.dart';
import 'package:flutter/material.dart';

class PromoterOverviewViewStateButton extends StatefulWidget {
  final Function(PromotersOverviewViewState) onSelected;

  const PromoterOverviewViewStateButton({
    super.key,
    required this.onSelected,
  });

  @override
  State<PromoterOverviewViewStateButton> createState() =>
      _PromoterOverviewViewStateButtonState();
}

class _PromoterOverviewViewStateButtonState
    extends State<PromoterOverviewViewStateButton> {
  Set<PromotersOverviewViewState> selected = {PromotersOverviewViewState.grid};
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
        selected: selected,
        onSelectionChanged: (Set<PromotersOverviewViewState> newSelectedValue) {
          setState(() {
            selected = newSelectedValue;
            widget.onSelected(selected.first);
          });
        });
  }
}
