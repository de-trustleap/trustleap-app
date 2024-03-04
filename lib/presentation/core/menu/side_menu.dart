import 'package:finanzbegleiter/application/menu/menu_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/presentation/core/menu/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<MenuBloc>(context),
      child: BlocConsumer<MenuBloc, MenuState>(
        listener: (context, state) {},
        builder: (context, state) {
          return NavigationListener(builder: (context, child) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Row(children: [
                    if (ResponsiveBreakpoints.of(context)
                        .largerThan(TABLET)) ...[
                      MenuItem(
                          path: RoutePaths.profilePath,
                          icon: Icons.person,
                          type: MenuItems.profile,
                          selectedMenuItem: state.selectedMenuItem,
                          isURLMatching:
                              Modular.to.path.endsWith(RoutePaths.profilePath))
                    ] else ...[
                      MenuItem(
                          path: RoutePaths.profilePath,
                          icon: Icons.person,
                          type: MenuItems.profile,
                          selectedMenuItem: state.selectedMenuItem,
                          isURLMatching:
                              Modular.to.path.endsWith(RoutePaths.profilePath)),
                      const Spacer(),
                      IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.close,
                              color: Theme.of(context).iconTheme.color,
                              size: 24)),
                      const SizedBox(width: 16)
                    ]
                  ]),
                  const SizedBox(height: 52),
                  MenuItem(
                      path: RoutePaths.dashboardPath,
                      icon: Icons.dashboard,
                      type: MenuItems.dashboard,
                      selectedMenuItem: state.selectedMenuItem,
                      isURLMatching:
                          Modular.to.path.endsWith(RoutePaths.dashboardPath)),
                  const SizedBox(height: 28),
                  MenuItem(
                      path: RoutePaths.recommendationsPath,
                      icon: Icons.thumb_up,
                      type: MenuItems.recommendations,
                      selectedMenuItem: state.selectedMenuItem,
                      isURLMatching: Modular.to.path
                          .endsWith(RoutePaths.recommendationsPath)),
                  const SizedBox(height: 28),
                  MenuItem(
                      path: RoutePaths.promotersPath,
                      icon: Icons.phone_bluetooth_speaker,
                      type: MenuItems.promoters,
                      selectedMenuItem: state.selectedMenuItem,
                      isURLMatching:
                          Modular.to.path.endsWith(RoutePaths.promotersPath)),
                  const SizedBox(height: 28),
                  MenuItem(
                      path: RoutePaths.landingPagePath,
                      icon: Icons.airplanemode_active,
                      type: MenuItems.landingpage,
                      selectedMenuItem: state.selectedMenuItem,
                      isURLMatching:
                          Modular.to.path.endsWith(RoutePaths.landingPagePath)),
                  const SizedBox(height: 28),
                  MenuItem(
                      path: RoutePaths.activitiesPath,
                      icon: Icons.history,
                      type: MenuItems.activities,
                      selectedMenuItem: state.selectedMenuItem,
                      isURLMatching:
                          Modular.to.path.endsWith(RoutePaths.activitiesPath))
                ]);
          });
        },
      ),
    );
  }
}
