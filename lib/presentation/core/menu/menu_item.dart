// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/menu/menu_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MenuItem extends StatefulWidget {
  final String path;
  final IconData icon;
  final MenuItems type;
  final bool isURLMatching;

  const MenuItem(
      {Key? key,
      required this.path,
      required this.icon,
      required this.type,
      required this.isURLMatching})
      : super(key: key);

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    String getLocalizedMenuItem() {
      switch (widget.type) {
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
        case MenuItems.none:
          return "";
      }
    }

    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      const height = 56.0;
      const padding = 12.0;
      return BlocProvider.value(
        value: BlocProvider.of<MenuBloc>(context),
        child: BlocBuilder<MenuBloc, MenuState>(
          builder: (context, state) {
            return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    BlocProvider.of<MenuBloc>(context).add(
                        SelectedMenuItemChangedEvent(
                            selectedMenuItem: widget.type));
                    Modular.to.navigate(RoutePaths.homePath + widget.path);
                  },
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Stack(children: [
                        Stack(children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width:
                                widget.isURLMatching ? width - padding * 2 : 0,
                            height: height,
                            curve: const Cubic(0.5, 0.8, 0.4, 1),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: widget.isURLMatching
                                    ? themeData.colorScheme.primary
                                    : themeData.colorScheme.background),
                          ),
                          Container(
                            width: width - padding * 2,
                            height: height,
                            padding: const EdgeInsets.symmetric(
                                horizontal: padding, vertical: 16),
                            child: Row(children: [
                              Icon(widget.icon,
                                  color: widget.isURLMatching
                                      ? themeData.colorScheme.background
                                      : themeData.iconTheme.color),
                              const SizedBox(width: 12),
                              Text(getLocalizedMenuItem(),
                                  style: widget.isURLMatching
                                      ? themeData.textTheme.headlineLarge!
                                          .copyWith(
                                              color: themeData
                                                  .colorScheme.background)
                                      : themeData.textTheme.headlineLarge)
                            ]),
                          ),
                        ]),
                      ])),
                ));
          },
        ),
      );
    });
  }
}
