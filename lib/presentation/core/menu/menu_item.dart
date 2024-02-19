// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/menu/menu_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routemaster/routemaster.dart';

class MenuItem extends StatelessWidget {
  final String path;
  final IconData icon;
  final MenuItems type;
  final MenuItems selectedMenuItem;

  const MenuItem(
      {Key? key,
      required this.path,
      required this.icon,
      required this.type,
      required this.selectedMenuItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    String getLocalizedMenuItem() {
      switch (type) {
        case MenuItems.profile:
          return localization.menuitems_profile;
        case MenuItems.dashboard:
          return localization.menuitems_dashboard;
        case MenuItems.recommendations:
          return localization.menuitems_recommendations;
        case MenuItems.promoters:
          return localization.menuitems_promoters;
        case MenuItems.landingpage:
          return localization.menuitems_landingpage;
        case MenuItems.activities:
          return localization.menuitems_activities;
      }
    }

    return BlocProvider.value(
      value: BlocProvider.of<MenuBloc>(context),
      child: BlocConsumer<MenuBloc, MenuState>(
        listener: (context, state) {},
        builder: (context, state) {
          return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  BlocProvider.of<MenuBloc>(context).add(
                      SelectedMenuItemChangedEvent(selectedMenuItem: type));
                  Routemaster.of(context).replace(path);
                },
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: selectedMenuItem == type
                              ? themeData.colorScheme.primary
                              : themeData.colorScheme.background),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                        child: Row(children: [
                          Icon(icon,
                              color: selectedMenuItem == type
                                  ? themeData.colorScheme.background
                                  : themeData.iconTheme.color),
                          const SizedBox(width: 12),
                          Text(getLocalizedMenuItem(),
                              style: selectedMenuItem == type
                                  ? themeData.textTheme.headlineLarge!.copyWith(
                                      color: themeData.colorScheme.background)
                                  : themeData.textTheme.headlineLarge)
                        ]),
                      ),
                    )),
              ));
        },
      ),
    );
  }
}
