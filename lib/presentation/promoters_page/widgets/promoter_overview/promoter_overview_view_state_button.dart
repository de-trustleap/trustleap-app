// ignore_for_file: public_member_api_docs, sort_constructors_first
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
    return SegmentedButton<PromotersOverviewViewState>(
        segments: const [
          ButtonSegment<PromotersOverviewViewState>(
              value: PromotersOverviewViewState.grid,
              icon: Icon(Icons.grid_on)),
          ButtonSegment<PromotersOverviewViewState>(
              value: PromotersOverviewViewState.list,
              icon: Icon(Icons.format_list_bulleted))
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
