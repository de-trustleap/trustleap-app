// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/expanded_section.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/underlined_dropdown.dart';
import 'package:finanzbegleiter/features/promoter/presentation/widgets/promoter_overview/promoter_overview_filter_bottom_sheet.dart';
import 'package:finanzbegleiter/features/promoter/presentation/widgets/promoter_overview/promoter_overview_header_expandable_filter.dart';
import 'package:finanzbegleiter/features/promoter/presentation/widgets/promoter_overview/promoter_overview_view_state_button.dart';
import 'package:finanzbegleiter/features/promoter/presentation/widgets/promoter_overview/promoters_overview_page.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PromoterOverviewHeader extends StatefulWidget {
  final TextEditingController searchController;
  final Function(String?) onSearchQueryChanged;
  final Function clearSearch;
  final Function(PromoterOverviewFilterStates filterStates) onFilterChanged;
  final PromotersOverviewViewState currentViewState;
  final Function(PromotersOverviewViewState) onViewStateButtonPressed;
  final Function(PromoterSearchOption) onSearchOptionChanged;
  const PromoterOverviewHeader(
      {super.key,
      required this.searchController,
      required this.onSearchQueryChanged,
      required this.clearSearch,
      required this.onFilterChanged,
      required this.currentViewState,
      required this.onViewStateButtonPressed,
      required this.onSearchOptionChanged});

  @override
  State<PromoterOverviewHeader> createState() => _PromoterOverviewHeaderState();
}

class _PromoterOverviewHeaderState extends State<PromoterOverviewHeader> {
  bool _isExpanded = false;
  PromoterSearchOption _selectedSearchOption = PromoterSearchOption.fullName;
  PromoterOverviewFilterStates _filterStates = PromoterOverviewFilterStates();

  void onFilterPressed(ResponsiveBreakpointsData responsiveValue) {
    if (responsiveValue.isMobile) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => PromoterOverviewFilterBottomSheet(
          filterStates: _filterStates,
          onFilterChanged: (PromoterOverviewFilterStates filterStates) {
            setState(() {
              _filterStates = filterStates;
            });
            widget.onFilterChanged(filterStates);
          },
        ),
      );
    } else {
      setState(() {
        _isExpanded = !_isExpanded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsiveValue = ResponsiveHelper.of(context);
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SelectableText(localization.promoter_overview_title,
              style: themeData.textTheme.headlineLarge!
                  .copyWith(fontWeight: FontWeight.bold)),
          PromoterOverviewViewStateButton(
            currentViewState: widget.currentViewState,
            onSelected: (selectedValue) {
              widget.onViewStateButtonPressed(selectedValue);
            },
          ),
        ]),
        const SizedBox(height: 16),
        ResponsiveRowColumn(
          layout: responsiveValue.isDesktop
              ? ResponsiveRowColumnType.ROW
              : ResponsiveRowColumnType.COLUMN,
          rowCrossAxisAlignment: CrossAxisAlignment.center,
          columnCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResponsiveRowColumnItem(
              child: UnderlinedDropdown<PromoterSearchOption>(
                value: _selectedSearchOption,
                items: PromoterSearchOption.values.map((option) {
                  return DropdownMenuItem<PromoterSearchOption>(
                    value: option,
                    child: Text(option.value),
                  );
                }).toList(),
                onChanged: (PromoterSearchOption? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedSearchOption = newValue;
                    });
                    widget.onSearchOptionChanged(newValue);
                  }
                },
              ),
            ),
            ResponsiveRowColumnItem(
              child: responsiveValue.isDesktop
                  ? const SizedBox(width: 24)
                  : const SizedBox(height: 16),
            ),
            ResponsiveRowColumnItem(
              rowFlex: 1,
              child: Row(
                children: [
                  Expanded(
                    child: SearchBar(
                      controller: widget.searchController,
                      leading: const Icon(Icons.search),
                      onChanged: widget.onSearchQueryChanged,
                      trailing: [
                        IconButton(
                            onPressed: () => widget.clearSearch(),
                            tooltip: localization
                                .promoter_overview_reset_search_tooltip,
                            icon: const Icon(Icons.close))
                      ],
                      hintText:
                          localization.promoter_overview_search_placeholder,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: IconButton(
                        onPressed: () => onFilterPressed(responsiveValue),
                        tooltip: localization.promoter_overview_filter_tooltip,
                        icon: Icon(Icons.filter_list,
                            color: themeData.colorScheme.secondary, size: 32)),
                  ),
                ],
              ),
            ),
          ],
        ),
        ExpandedSection(
            expand: _isExpanded,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  PromoterOverviewHeaderExpandableFilter(onFilterChanged:
                      (PromoterOverviewFilterStates filterStates) {
                    setState(() {
                      _filterStates = filterStates;
                    });
                    widget.onFilterChanged(filterStates);
                  })
                ]))
      ],
    );
  }
}
