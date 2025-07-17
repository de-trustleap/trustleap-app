import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/underlined_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RecommendationManagerListHeader extends StatefulWidget {
  final TextEditingController searchController;
  final Function onFilterPressed;
  final Function(RecommendationSearchOption) onSearchOptionChanged;
  const RecommendationManagerListHeader(
      {super.key,
      required this.searchController,
      required this.onFilterPressed,
      required this.onSearchOptionChanged});

  @override
  State<RecommendationManagerListHeader> createState() => _RecommendationManagerListHeaderState();
}

class _RecommendationManagerListHeaderState extends State<RecommendationManagerListHeader> {
  RecommendationSearchOption _selectedSearchOption = RecommendationSearchOption.promoterName;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.recommendation_manager_title,
          style: themeData.textTheme.headlineLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ResponsiveRowColumn(
          layout: ResponsiveBreakpoints.of(context).isDesktop
              ? ResponsiveRowColumnType.ROW
              : ResponsiveRowColumnType.COLUMN,
          rowCrossAxisAlignment: CrossAxisAlignment.center,
          columnCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResponsiveRowColumnItem(
              child: UnderlinedDropdown<RecommendationSearchOption>(
                value: _selectedSearchOption,
                items: RecommendationSearchOption.values.map((option) {
                  return DropdownMenuItem<RecommendationSearchOption>(
                    value: option,
                    child: Text(option.value),
                  );
                }).toList(),
                onChanged: (RecommendationSearchOption? newValue) {
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
              child: ResponsiveBreakpoints.of(context).isDesktop
                  ? const SizedBox(width: 16)
                  : const SizedBox(height: 16),
            ),
            ResponsiveRowColumnItem(
              rowFlex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: SearchBar(
                    controller: widget.searchController,
                    leading: const Icon(Icons.search),
                    trailing: [
                      IconButton(
                          onPressed: () {
                            widget.searchController.clear();
                          },
                          tooltip: localization
                              .recommendation_manager_search_close_tooltip,
                          icon: const Icon(Icons.close))
                    ],
                    hintText:
                        localization.recommendation_manager_search_placeholder,
                  )),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: IconButton(
                        onPressed: () => widget.onFilterPressed(),
                        tooltip:
                            localization.recommendation_manager_filter_tooltip,
                        icon: Icon(Icons.filter_list,
                            color: themeData.colorScheme.secondary, size: 32)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
