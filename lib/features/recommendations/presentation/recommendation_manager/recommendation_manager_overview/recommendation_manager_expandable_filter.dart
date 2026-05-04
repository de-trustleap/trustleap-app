import 'package:finanzbegleiter/core/remote_config/app_remote_config_cubit.dart';
import 'package:finanzbegleiter/core/remote_config/app_remote_config_state.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/custom_dropdown.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

enum RecommendationStatusFilterState {
  recommendationSent,
  linkClicked,
  contactFormSent,
  appointment,
  manualIssued,
  voucherSent,
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
                          CustomDropdown<RecommendationSortByFilterState>(
                              textStyle: themeData.textTheme.bodySmall,
                              width: responsiveValue.largerThan(MOBILE)
                                  ? 250
                                  : 400,
                              label: localization
                                  .promoter_overview_filter_sortby_choose,
                              value: filterStates.sortByFilterState,
                              type: CustomDropdownType.standard,
                              useDialogPicker: responsiveValue.isMobile,
                              items: [
                                if (widget.isArchive) ...[
                                  CustomDropdownItem(
                                      value: RecommendationSortByFilterState
                                          .finishedAt,
                                      label: localization
                                          .recommendation_manager_filter_finished_at),
                                ] else ...[
                                  CustomDropdownItem(
                                      value: RecommendationSortByFilterState
                                          .expiresAt,
                                      label: localization
                                          .recommendation_manager_filter_expires_date),
                                  CustomDropdownItem(
                                      value: RecommendationSortByFilterState
                                          .lastUpdated,
                                      label: localization
                                          .recommendation_manager_filter_last_updated),
                                ],
                                CustomDropdownItem(
                                    value:
                                        RecommendationSortByFilterState.promoter,
                                    label: localization
                                        .recommendation_manager_filter_promoter),
                                CustomDropdownItem(
                                    value: RecommendationSortByFilterState
                                        .recommendationReceiver,
                                    label: localization
                                        .recommendation_manager_filter_recommendation_receiver),
                                CustomDropdownItem(
                                    value:
                                        RecommendationSortByFilterState.reason,
                                    label: localization
                                        .recommendation_manager_filter_reason),
                              ],
                              onChanged: (sortBy) {
                                setState(() {
                                  filterStates.sortByFilterState = sortBy ??
                                      RecommendationSortByFilterState.expiresAt;
                                  widget.onFilterChanged(filterStates);
                                });
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
                BlocBuilder<AppRemoteConfigCubit, AppRemoteConfigState>(
                    bloc: Modular.get<AppRemoteConfigCubit>(),
                    builder: (context, remoteConfig) {
                      return CustomDropdown<RecommendationStatusFilterState>(
                          textStyle: themeData.textTheme.bodySmall,
                          width: responsiveValue.largerThan(MOBILE) ? 250 : 400,
                          label: localization
                              .recommendation_manager_filter_sort_by_status,
                          value: filterStates.statusFilterState,
                          type: CustomDropdownType.standard,
                          useDialogPicker: responsiveValue.isMobile,
                          items: [
                            CustomDropdownItem(
                                value: RecommendationStatusFilterState.all,
                                label: localization
                                    .recommendation_manager_filter_status_all),
                            if (!widget.isArchive) ...[
                              CustomDropdownItem(
                                  value: RecommendationStatusFilterState
                                      .recommendationSent,
                                  label: localization
                                      .recommendation_manager_status_level_1),
                              CustomDropdownItem(
                                  value:
                                      RecommendationStatusFilterState.linkClicked,
                                  label: localization
                                      .recommendation_manager_status_level_2),
                              CustomDropdownItem(
                                  value: RecommendationStatusFilterState
                                      .contactFormSent,
                                  label: localization
                                      .recommendation_manager_status_level_3),
                              CustomDropdownItem(
                                  value:
                                      RecommendationStatusFilterState.appointment,
                                  label: localization
                                      .recommendation_manager_status_level_4),
                              CustomDropdownItem(
                                  value: RecommendationStatusFilterState
                                      .manualIssued,
                                  label: localization
                                      .compensation_status_manual_issued),
                              if (remoteConfig.tremendousEnabled)
                                CustomDropdownItem(
                                    value:
                                        RecommendationStatusFilterState.voucherSent,
                                    label: localization
                                        .compensation_status_voucher_sent),
                            ],
                            if (widget.isArchive) ...[
                              CustomDropdownItem(
                                  value:
                                      RecommendationStatusFilterState.successful,
                                  label: localization
                                      .recommendation_manager_status_level_5),
                              CustomDropdownItem(
                                  value: RecommendationStatusFilterState.failed,
                                  label: localization
                                      .recommendation_manager_status_level_6),
                            ],
                          ],
                          onChanged: (sortBy) {
                            setState(() {
                              filterStates.statusFilterState =
                                  sortBy ?? RecommendationStatusFilterState.all;
                              widget.onFilterChanged(filterStates);
                            });
                          });
                    }),
                if (!widget.isArchive) ...[
                  const SizedBox(height: 16),
                  CustomDropdown<RecommendationFavoriteFilterState>(
                      textStyle: themeData.textTheme.bodySmall,
                      width: responsiveValue.largerThan(MOBILE) ? 250 : 400,
                      label: localization
                          .recommendation_manager_filter_sort_by_favorites,
                      value: filterStates.favoriteFilterState,
                      type: CustomDropdownType.standard,
                      useDialogPicker: responsiveValue.isMobile,
                      items: [
                        CustomDropdownItem(
                            value: RecommendationFavoriteFilterState.all,
                            label: localization
                                .recommendation_manager_filter_status_all),
                        CustomDropdownItem(
                            value: RecommendationFavoriteFilterState.isFavorite,
                            label: localization
                                .recommendation_manager_filter_favorites),
                        CustomDropdownItem(
                            value:
                                RecommendationFavoriteFilterState.isNotFavorite,
                            label: localization
                                .recommendation_manager_filter_no_favorites),
                      ],
                      onChanged: (sortBy) {
                        setState(() {
                          filterStates.favoriteFilterState =
                              sortBy ?? RecommendationFavoriteFilterState.all;
                          widget.onFilterChanged(filterStates);
                        });
                      }),
                  const SizedBox(height: 16),
                  CustomDropdown<RecommendationPriorityFilterState>(
                      textStyle: themeData.textTheme.bodySmall,
                      width: responsiveValue.largerThan(MOBILE) ? 250 : 400,
                      label: localization
                          .recommendation_manager_filter_sort_by_priorities,
                      value: filterStates.priorityFilterState,
                      type: CustomDropdownType.standard,
                      useDialogPicker: responsiveValue.isMobile,
                      items: [
                        CustomDropdownItem(
                            value: RecommendationPriorityFilterState.all,
                            label: localization
                                .recommendation_manager_filter_status_all),
                        CustomDropdownItem(
                            value: RecommendationPriorityFilterState.high,
                            label: localization.recommendation_priority_high),
                        CustomDropdownItem(
                            value: RecommendationPriorityFilterState.medium,
                            label: localization.recommendation_priority_medium),
                        CustomDropdownItem(
                            value: RecommendationPriorityFilterState.low,
                            label: localization.recommendation_priority_low),
                      ],
                      onChanged: (sortBy) {
                        setState(() {
                          filterStates.priorityFilterState =
                              sortBy ?? RecommendationPriorityFilterState.all;
                          widget.onFilterChanged(filterStates);
                        });
                      }),
                ]
              ],
            ),
          ),
        ]);
  }
}
