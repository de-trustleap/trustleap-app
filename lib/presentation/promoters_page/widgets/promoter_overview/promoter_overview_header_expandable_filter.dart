// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

enum PromoterRegistrationFilterState { all, registered, unregistered }

enum PromoterSortByFilterState { createdAt, firstName, lastName, email }

enum PromoterSortOrderFilterState { asc, desc }

class PromoterOverviewFilterStates {
  PromoterRegistrationFilterState registrationFilterState =
      PromoterRegistrationFilterState.all;
  PromoterSortByFilterState sortByFilterState =
      PromoterSortByFilterState.createdAt;
  PromoterSortOrderFilterState sortOrderFilterState =
      PromoterSortOrderFilterState.desc;
}

class PromoterOverviewHeaderExpandableFilter extends StatefulWidget {
  final Function(PromoterOverviewFilterStates filterStates) onFilterChanged;

  const PromoterOverviewHeaderExpandableFilter({
    Key? key,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  State<PromoterOverviewHeaderExpandableFilter> createState() =>
      _PromoterOverviewHeaderExpandableFilterState();
}

class _PromoterOverviewHeaderExpandableFilterState
    extends State<PromoterOverviewHeaderExpandableFilter> {
  PromoterOverviewFilterStates filterStates = PromoterOverviewFilterStates();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);

    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Expanded(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                  title: Text(localization.promoter_overview_filter_show_all,
                      style: themeData.textTheme.bodySmall),
                  value: PromoterRegistrationFilterState.all,
                  groupValue: filterStates.registrationFilterState,
                  onChanged: (value) {
                    setState(() {
                      filterStates.registrationFilterState =
                          value ?? PromoterRegistrationFilterState.all;
                      widget.onFilterChanged(filterStates);
                    });
                  }),
              const SizedBox(height: 8),
              RadioListTile(
                  title: Text(localization.promoter_overview_filter_show_registered,
                      style: themeData.textTheme.bodySmall),
                  value: PromoterRegistrationFilterState.registered,
                  groupValue: filterStates.registrationFilterState,
                  onChanged: (value) {
                    setState(() {
                      filterStates.registrationFilterState =
                          value ?? PromoterRegistrationFilterState.all;
                      widget.onFilterChanged(filterStates);
                    });
                  }),
              const SizedBox(height: 8),
              RadioListTile(
                  title: Text(localization.promoter_overview_filter_show_unregistered,
                      style: themeData.textTheme.bodySmall),
                  value: PromoterRegistrationFilterState.unregistered,
                  groupValue: filterStates.registrationFilterState,
                  onChanged: (value) {
                    setState(() {
                      filterStates.registrationFilterState =
                          value ?? PromoterRegistrationFilterState.all;
                      widget.onFilterChanged(filterStates);
                    });
                  }),
            ]),
      ),
      Expanded(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownMenu<PromoterSortByFilterState>(
                  textStyle: themeData.textTheme.bodySmall,
                  width: responsiveValue.largerThan(MOBILE) ? 250 : 190,
                  label: Text(localization.promoter_overview_filter_sortby_choose,
                      style: themeData.textTheme.bodySmall!
                          .copyWith(fontSize: 12)),
                  initialSelection: PromoterSortByFilterState.createdAt,
                  enableSearch: false,
                  requestFocusOnTap: false,
                  dropdownMenuEntries: [
                    DropdownMenuEntry(
                        value: PromoterSortByFilterState.createdAt,
                        label: localization.promoter_overview_filter_sortby_date),
                    DropdownMenuEntry(
                        value: PromoterSortByFilterState.firstName,
                        label: localization.promoter_overview_filter_sortby_firstname),
                    DropdownMenuEntry(
                        value: PromoterSortByFilterState.lastName,
                        label: localization.promoter_overview_filter_sortby_lastname),
                    DropdownMenuEntry(
                        value: PromoterSortByFilterState.email,
                        label: localization.promoter_overview_filter_sortby_email)
                  ],
                  onSelected: (sortBy) {
                    filterStates.sortByFilterState =
                        sortBy ?? PromoterSortByFilterState.createdAt;
                    widget.onFilterChanged(filterStates);
                  }),
              RadioListTile(
                  title:
                      Text(localization.promoter_overview_filter_sortorder_desc, style: themeData.textTheme.bodySmall),
                  value: PromoterSortOrderFilterState.desc,
                  groupValue: filterStates.sortOrderFilterState,
                  onChanged: (value) {
                    setState(() {
                      filterStates.sortOrderFilterState =
                          value ?? PromoterSortOrderFilterState.desc;
                      widget.onFilterChanged(filterStates);
                    });
                  }),
              RadioListTile(
                  title:
                      Text(localization.promoter_overview_filter_sortorder_asc, style: themeData.textTheme.bodySmall),
                  value: PromoterSortOrderFilterState.asc,
                  groupValue: filterStates.sortOrderFilterState,
                  onChanged: (value) {
                    setState(() {
                      filterStates.sortOrderFilterState =
                          value ?? PromoterSortOrderFilterState.desc;
                      widget.onFilterChanged(filterStates);
                    });
                  }),
            ]),
      )
    ]);
  }
}
