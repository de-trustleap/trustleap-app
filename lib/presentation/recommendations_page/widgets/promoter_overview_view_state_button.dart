// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/presentation/recommendations_page/widgets/promoters_overview_grid.dart';
import 'package:flutter/material.dart';

class PromoterOverviewViewStateButton extends StatefulWidget {
  final Function(PromotersOverviewViewState) onSelected;

  const PromoterOverviewViewStateButton({
    Key? key,
    required this.onSelected,
  }) : super(key: key);

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
        selected: selected,
        onSelectionChanged: (Set<PromotersOverviewViewState> newSelectedValue) {
          setState(() {
            selected = newSelectedValue;
            widget.onSelected(selected.first);
          });
        });
  }
}
