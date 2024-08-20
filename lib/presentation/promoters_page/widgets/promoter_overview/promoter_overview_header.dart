// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/expanded_section.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoter_overview_header_expandable_filter.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoter_overview_view_state_button.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoters_overview_page.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PromoterOverviewHeader extends StatefulWidget {
  final TextEditingController searchController;
  final Function(String?) onSearchQueryChanged;
  final Function clearSearch;
  final Function(PromoterOverviewFilterStates filterStates) onFilterChanged;
  final Function(PromotersOverviewViewState) onViewStateButtonPressed;
  const PromoterOverviewHeader(
      {super.key,
      required this.searchController,
      required this.onSearchQueryChanged,
      required this.clearSearch,
      required this.onFilterChanged,
      required this.onViewStateButtonPressed});

  @override
  State<PromoterOverviewHeader> createState() => _PromoterOverviewHeaderState();
}

class _PromoterOverviewHeaderState extends State<PromoterOverviewHeader> {
  bool _isExpanded = false;

  void onFilterPressed() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Flexible(
            flex: responsiveValue.isDesktop ? 2 : 0,
            child: SelectableText(localization.promoter_overview_title,
                style: themeData.textTheme.headlineLarge!
                    .copyWith(fontWeight: FontWeight.bold)),
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
                  hintText: localization.promoter_overview_search_placeholder,
                )),
            const SizedBox(width: 8),
            SizedBox(
              width: 48,
              height: 48,
              child: IconButton(
                  onPressed: () => onFilterPressed(),
                  icon: Icon(Icons.filter_list,
                      color: themeData.colorScheme.secondary, size: 32)),
            ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SearchBar(
                  controller: widget.searchController,
                  leading: const Icon(Icons.search),
                  onChanged: widget.onSearchQueryChanged,
                  trailing: [
                    IconButton(
                        onPressed: () => widget.clearSearch(),
                        icon: const Icon(Icons.close))
                  ],
                  hintText: localization.promoter_overview_search_placeholder,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 48,
                height: 48,
                child: IconButton(
                    onPressed: () => onFilterPressed(),
                    icon: Icon(Icons.filter_list,
                        color: themeData.colorScheme.secondary, size: 32)),
              )
            ],
          )
        ],
        ExpandedSection(
            expand: _isExpanded,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  PromoterOverviewHeaderExpandableFilter(
                      onFilterChanged: widget.onFilterChanged)
                ]))
      ],
    );
  }
}
