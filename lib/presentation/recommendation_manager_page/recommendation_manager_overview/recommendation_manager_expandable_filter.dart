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
  expiresAt
}

enum RecommendationSortOrderFilterState { asc, desc }

class RecommendationOverviewFilterStates {
  RecommendationStatusFilterState statusFilterState =
      RecommendationStatusFilterState.all;
  RecommendationSortByFilterState sortByFilterState =
      RecommendationSortByFilterState.expiresAt;
  RecommendationSortOrderFilterState sortOrderFilterState =
      RecommendationSortOrderFilterState.desc;
}

class RecommendationManagerExpandableFilter extends StatefulWidget {
  final Function(RecommendationOverviewFilterStates filterStates)
      onFilterChanged;
  const RecommendationManagerExpandableFilter(
      {super.key, required this.onFilterChanged});

  @override
  State<RecommendationManagerExpandableFilter> createState() =>
      _RecommendationManagerExpandableFilterState();
}

class _RecommendationManagerExpandableFilterState
    extends State<RecommendationManagerExpandableFilter> {
  RecommendationOverviewFilterStates filterStates =
      RecommendationOverviewFilterStates();

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
                                DropdownMenuEntry(
                                    value: RecommendationSortByFilterState
                                        .expiresAt,
                                    label: "Ablaufdatum"),
                                DropdownMenuEntry(
                                    value: RecommendationSortByFilterState
                                        .lastUpdated,
                                    label: "Zuletzt aktualisiert"),
                                DropdownMenuEntry(
                                    value: RecommendationSortByFilterState
                                        .promoter,
                                    label: "Promoter"),
                                DropdownMenuEntry(
                                    value: RecommendationSortByFilterState
                                        .recommendationReceiver,
                                    label: "Empfänger"),
                                DropdownMenuEntry(
                                    value:
                                        RecommendationSortByFilterState.reason,
                                    label: "Grund")
                              ],
                              onSelected: (sortBy) {
                                filterStates.sortByFilterState = sortBy ??
                                    RecommendationSortByFilterState.expiresAt;
                                widget.onFilterChanged(filterStates);
                              }),
                          RadioListTile(
                              title: SelectableText("Absteigend",
                                  style: themeData.textTheme.bodySmall),
                              value: RecommendationSortOrderFilterState.desc,
                              groupValue: filterStates.sortOrderFilterState,
                              onChanged: (value) {
                                setState(() {
                                  filterStates.sortOrderFilterState = value ??
                                      RecommendationSortOrderFilterState.desc;
                                  widget.onFilterChanged(filterStates);
                                });
                              }),
                          RadioListTile(
                              title: SelectableText("Aufsteigend",
                                  style: themeData.textTheme.bodySmall),
                              value: RecommendationSortOrderFilterState.asc,
                              groupValue: filterStates.sortOrderFilterState,
                              onChanged: (value) {
                                setState(() {
                                  filterStates.sortOrderFilterState = value ??
                                      RecommendationSortOrderFilterState.desc;
                                  widget.onFilterChanged(filterStates);
                                });
                              }),
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
                        localization.promoter_overview_filter_sortby_choose,
                        style: themeData.textTheme.bodySmall!
                            .copyWith(fontSize: 12)),
                    initialSelection: RecommendationStatusFilterState.all,
                    enableSearch: false,
                    requestFocusOnTap: false,
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                          value: RecommendationStatusFilterState.all,
                          label: "Alle"),
                      DropdownMenuEntry(
                          value: RecommendationStatusFilterState
                              .recommendationSent,
                          label: "Empfehlung ausgesprochen"),
                      DropdownMenuEntry(
                          value: RecommendationStatusFilterState.linkClicked,
                          label: "Link geklickt"),
                      DropdownMenuEntry(
                          value:
                              RecommendationStatusFilterState.contactFormSent,
                          label: "Kontakt aufgenommen"),
                      DropdownMenuEntry(
                          value: RecommendationStatusFilterState.appointment,
                          label: "Empfehlung terminiert"),
                      DropdownMenuEntry(
                          value: RecommendationStatusFilterState.successful,
                          label: "Abgeschlossen"),
                      DropdownMenuEntry(
                          value: RecommendationStatusFilterState.failed,
                          label: "Nicht abgeschlossen")
                    ],
                    onSelected: (sortBy) {
                      filterStates.statusFilterState =
                          sortBy ?? RecommendationStatusFilterState.all;
                      widget.onFilterChanged(filterStates);
                    }),
              ],
            ),
          )
        ]);
  }
}

//TODO: FILTER FUNKTION IMPLEMENTIEREN!
//TODO: MEINE EMPFEHLUNGEN BEI MOBILE ÜBER DER SUCHE ANZEIGEN. WIE BEI PROMOTERN
