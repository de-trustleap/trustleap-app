import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

enum RecommendationStatusFilterState {
  recommendationSent,
  linkClicked,
  contactFormSent,
  appointment,
  successful,
  failed,
  all
}

enum RecommendationSortByFilterState {
  promoter,
  recommendationReceiver,
  reason,
  lastUpdated,
  expiresAt,
  finishedAt
}

enum RecommendationFavoriteFilterState { all, isFavorite, isNotFavorite }

enum RecommendationPriorityFilterState { all, high, medium, low }

enum RecommendationSortOrderFilterState { asc, desc }

class RecommendationOverviewFilterStates {
  RecommendationStatusFilterState statusFilterState =
      RecommendationStatusFilterState.all;
  late RecommendationSortByFilterState sortByFilterState;
  RecommendationSortOrderFilterState sortOrderFilterState =
      RecommendationSortOrderFilterState.desc;
  RecommendationFavoriteFilterState favoriteFilterState =
      RecommendationFavoriteFilterState.all;
  RecommendationPriorityFilterState priorityFilterState =
      RecommendationPriorityFilterState.all;

  RecommendationOverviewFilterStates({required bool isArchive}) {
    sortByFilterState = isArchive
        ? RecommendationSortByFilterState.finishedAt
        : RecommendationSortByFilterState.expiresAt;
  }
}

class RecommendationManagerExpandableFilter extends StatefulWidget {
  final bool isArchive;
  final Function(RecommendationOverviewFilterStates filterStates)
      onFilterChanged;
  const RecommendationManagerExpandableFilter(
      {super.key, required this.onFilterChanged, required this.isArchive});

  @override
  State<RecommendationManagerExpandableFilter> createState() =>
      _RecommendationManagerExpandableFilterState();
}

class _RecommendationManagerExpandableFilterState
    extends State<RecommendationManagerExpandableFilter> {
  late RecommendationOverviewFilterStates filterStates;

  @override
  void initState() {
    super.initState();
    filterStates =
        RecommendationOverviewFilterStates(isArchive: widget.isArchive);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);

    return ResponsiveRowColumn(
        rowCrossAxisAlignment: CrossAxisAlignment.start,
        layout: responsiveValue.largerThan(MOBILE)
            ? ResponsiveRowColumnType.ROW
            : ResponsiveRowColumnType.COLUMN,
        rowSpacing: 16.0,
        columnSpacing: 16.0,
        children: [
          ResponsiveRowColumnItem(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: responsiveValue.isMobile ? 500 : 300),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownMenu<RecommendationSortByFilterState>(
                              textStyle: themeData.textTheme.bodySmall,
                              width: responsiveValue.largerThan(MOBILE)
                                  ? 250
                                  : 400,
                              label: Text(
                                  localization
                                      .promoter_overview_filter_sortby_choose,
                                  style: themeData.textTheme.bodySmall!
                                      .copyWith(fontSize: 12)),
                              initialSelection:
                                  RecommendationSortByFilterState.expiresAt,
                              enableSearch: false,
                              requestFocusOnTap: false,
                              dropdownMenuEntries: [
                                if (widget.isArchive) ...[
                                  DropdownMenuEntry(
                                      value: RecommendationSortByFilterState
                                          .finishedAt,
                                      label: localization
                                          .recommendation_manager_filter_finished_at),
                                ] else ...[
                                  DropdownMenuEntry(
                                      value: RecommendationSortByFilterState
                                          .expiresAt,
                                      label: localization
                                          .recommendation_manager_filter_expires_date),
                                  DropdownMenuEntry(
                                      value: RecommendationSortByFilterState
                                          .lastUpdated,
                                      label: localization
                                          .recommendation_manager_filter_last_updated),
                                ],
                                DropdownMenuEntry(
                                    value: RecommendationSortByFilterState
                                        .promoter,
                                    label: localization
                                        .recommendation_manager_filter_promoter),
                                DropdownMenuEntry(
                                    value: RecommendationSortByFilterState
                                        .recommendationReceiver,
                                    label: localization
                                        .recommendation_manager_filter_recommendation_receiver),
                                DropdownMenuEntry(
                                    value:
                                        RecommendationSortByFilterState.reason,
                                    label: localization
                                        .recommendation_manager_filter_reason)
                              ],
                              onSelected: (sortBy) {
                                filterStates.sortByFilterState = sortBy ??
                                    RecommendationSortByFilterState.expiresAt;
                                widget.onFilterChanged(filterStates);
                              }),
                          RadioGroup<RecommendationSortOrderFilterState>(
                            groupValue: filterStates.sortOrderFilterState,
                            onChanged: (RecommendationSortOrderFilterState? value) {
                              if (value != null) {
                                setState(() {
                                  filterStates.sortOrderFilterState = value;
                                  widget.onFilterChanged(filterStates);
                                });
                              }
                            },
                            child: Column(
                              children: [
                                RadioListTile<RecommendationSortOrderFilterState>(
                                    title: SelectableText(
                                        localization
                                            .recommendation_manager_filter_descending,
                                        style: themeData.textTheme.bodySmall),
                                    value: RecommendationSortOrderFilterState.desc,
                                ),
                                RadioListTile<RecommendationSortOrderFilterState>(
                                    title: SelectableText(
                                        localization
                                            .recommendation_manager_filter_ascending,
                                        style: themeData.textTheme.bodySmall),
                                    value: RecommendationSortOrderFilterState.asc,
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ]),
            ),
          ),
          ResponsiveRowColumnItem(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownMenu<RecommendationStatusFilterState>(
                    textStyle: themeData.textTheme.bodySmall,
                    width: responsiveValue.largerThan(MOBILE) ? 250 : 400,
                    label: Text(
                        localization
                            .recommendation_manager_filter_sort_by_status,
                        style: themeData.textTheme.bodySmall!
                            .copyWith(fontSize: 12)),
                    initialSelection: RecommendationStatusFilterState.all,
                    enableSearch: false,
                    requestFocusOnTap: false,
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                          value: RecommendationStatusFilterState.all,
                          label: localization
                              .recommendation_manager_filter_status_all),
                      if (!widget.isArchive) ...[
                        DropdownMenuEntry(
                            value: RecommendationStatusFilterState
                                .recommendationSent,
                            label: localization
                                .recommendation_manager_status_level_1),
                        DropdownMenuEntry(
                            value: RecommendationStatusFilterState.linkClicked,
                            label: localization
                                .recommendation_manager_status_level_2),
                        DropdownMenuEntry(
                            value:
                                RecommendationStatusFilterState.contactFormSent,
                            label: localization
                                .recommendation_manager_status_level_3),
                        DropdownMenuEntry(
                            value: RecommendationStatusFilterState.appointment,
                            label: localization
                                .recommendation_manager_status_level_4)
                      ],
                      DropdownMenuEntry(
                          value: RecommendationStatusFilterState.successful,
                          label: localization
                              .recommendation_manager_status_level_5),
                      DropdownMenuEntry(
                          value: RecommendationStatusFilterState.failed,
                          label: localization
                              .recommendation_manager_status_level_6)
                    ],
                    onSelected: (sortBy) {
                      filterStates.statusFilterState =
                          sortBy ?? RecommendationStatusFilterState.all;
                      widget.onFilterChanged(filterStates);
                    }),
                if (!widget.isArchive) ...[
                  const SizedBox(height: 16),
                  DropdownMenu<RecommendationFavoriteFilterState>(
                      textStyle: themeData.textTheme.bodySmall,
                      width: responsiveValue.largerThan(MOBILE) ? 250 : 400,
                      label: Text(
                          localization
                              .recommendation_manager_filter_sort_by_favorites,
                          style: themeData.textTheme.bodySmall!
                              .copyWith(fontSize: 12)),
                      initialSelection: RecommendationFavoriteFilterState.all,
                      enableSearch: false,
                      requestFocusOnTap: false,
                      dropdownMenuEntries: [
                        DropdownMenuEntry(
                            value: RecommendationFavoriteFilterState.all,
                            label: localization
                                .recommendation_manager_filter_status_all),
                        DropdownMenuEntry(
                            value: RecommendationFavoriteFilterState.isFavorite,
                            label: localization
                                .recommendation_manager_filter_favorites),
                        DropdownMenuEntry(
                            value:
                                RecommendationFavoriteFilterState.isNotFavorite,
                            label: localization
                                .recommendation_manager_filter_no_favorites),
                      ],
                      onSelected: (sortBy) {
                        filterStates.favoriteFilterState =
                            sortBy ?? RecommendationFavoriteFilterState.all;
                        widget.onFilterChanged(filterStates);
                      }),
                  const SizedBox(height: 16),
                  DropdownMenu<RecommendationPriorityFilterState>(
                      textStyle: themeData.textTheme.bodySmall,
                      width: responsiveValue.largerThan(MOBILE) ? 250 : 400,
                      label: Text(
                          localization
                              .recommendation_manager_filter_sort_by_priorities,
                          style: themeData.textTheme.bodySmall!
                              .copyWith(fontSize: 12)),
                      initialSelection: RecommendationPriorityFilterState.all,
                      enableSearch: false,
                      requestFocusOnTap: false,
                      dropdownMenuEntries: [
                        DropdownMenuEntry(
                            value: RecommendationPriorityFilterState.all,
                            label: localization
                                .recommendation_manager_filter_status_all),
                        DropdownMenuEntry(
                            value: RecommendationPriorityFilterState.high,
                            label: localization.recommendation_priority_high),
                        DropdownMenuEntry(
                            value: RecommendationPriorityFilterState.medium,
                            label: localization.recommendation_priority_medium),
                        DropdownMenuEntry(
                            value: RecommendationPriorityFilterState.low,
                            label: localization.recommendation_priority_low),
                      ],
                      onSelected: (sortBy) {
                        filterStates.priorityFilterState =
                            sortBy ?? RecommendationPriorityFilterState.all;
                        widget.onFilterChanged(filterStates);
                      }),
                ]
              ],
            ),
          ),
        ]);
  }
}
