// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

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

    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Expanded(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                  title: Text("Alle anzeigen",
                      style: themeData.textTheme.headlineLarge!
                          .copyWith(fontSize: 14)),
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
                  title: Text("Registrierte anzeigen",
                      style: themeData.textTheme.headlineLarge!
                          .copyWith(fontSize: 14)),
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
                  title: Text("Unregistrierte anzeigen",
                      style: themeData.textTheme.headlineLarge!
                          .copyWith(fontSize: 14)),
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
                  textStyle:
                      themeData.textTheme.headlineLarge!.copyWith(fontSize: 14),
                  width: 250,
                  label: Text("Sortieren nach",
                      style: themeData.textTheme.headlineLarge!
                          .copyWith(fontSize: 12)),
                  initialSelection: PromoterSortByFilterState.createdAt,
                  enableSearch: false,
                  requestFocusOnTap: false,
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(
                        value: PromoterSortByFilterState.createdAt,
                        label: "Erstellungsdatum"),
                    DropdownMenuEntry(
                        value: PromoterSortByFilterState.firstName,
                        label: "Vorname"),
                    DropdownMenuEntry(
                        value: PromoterSortByFilterState.lastName,
                        label: "Nachname"),
                    DropdownMenuEntry(
                        value: PromoterSortByFilterState.email,
                        label: "E-Mail Adresse")
                  ],
                  onSelected: (sortBy) {
                    filterStates.sortByFilterState = sortBy ?? PromoterSortByFilterState.createdAt;
                    widget.onFilterChanged(filterStates);
                  }),
              RadioListTile(
                  title: Text("Absteigend",
                      style: themeData.textTheme.headlineLarge!
                          .copyWith(fontSize: 14)),
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
                  title: Text("Aufsteigend",
                      style: themeData.textTheme.headlineLarge!
                          .copyWith(fontSize: 14)),
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
