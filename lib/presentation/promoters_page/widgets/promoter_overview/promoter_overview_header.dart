// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoter_overview_view_state_button.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoters_overview_page.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class PromoterOverviewHeader extends StatefulWidget {
  final TextEditingController searchController;
  final Function(String?) onSearchQueryChanged;
  final Function clearSearch;
  final Function(PromotersOverviewViewState) onViewStateButtonPressed;
  const PromoterOverviewHeader(
      {Key? key,
      required this.searchController,
      required this.onSearchQueryChanged,
      required this.clearSearch,
      required this.onViewStateButtonPressed})
      : super(key: key);

  @override
  State<PromoterOverviewHeader> createState() => _PromoterOverviewHeaderState();
}

class _PromoterOverviewHeaderState extends State<PromoterOverviewHeader> {
  @override
  Widget build(BuildContext context) {
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final themeData = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Flexible(
            flex: responsiveValue.isDesktop ? 3 : 0,
            child: Text("Meine Promoter",
                style: themeData.textTheme.headlineLarge!
                    .copyWith(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          if (responsiveValue.isDesktop) ...[
            const Spacer(),
            Flexible(
                flex: 5,
                child: SearchBar(
                  controller: widget.searchController,
                  leading: const Icon(Icons.search),
                  onChanged: widget.onSearchQueryChanged,
                  trailing: [
                    IconButton(
                        onPressed: () => widget.clearSearch(),
                        icon: const Icon(Icons.close))
                  ],
                  hintText: "Suche...",
                )),
          ],
          const Spacer(),
          Flexible(
            flex: responsiveValue.isDesktop ? 2 : 0,
            child: PromoterOverviewViewStateButton(onSelected: (selectedValue) {
              widget.onViewStateButtonPressed(selectedValue);
            }),
          )
        ]),
        if (responsiveValue.smallerThan(DESKTOP)) ...[
          const SizedBox(height: 12),
          SearchBar(
            controller: widget.searchController,
            leading: const Icon(Icons.search),
            onChanged: widget.onSearchQueryChanged,
            trailing: [
              IconButton(
                  onPressed: () => widget.clearSearch(),
                  icon: const Icon(Icons.close))
            ],
            hintText: "Suche...",
          )
        ],
      ],
    );
  }
}
