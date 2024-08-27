// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/menu/menu_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/presentation/core/menu/menu_item.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/theme_switch.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SideMenu extends StatelessWidget {
  final bool collapsed;
  final AnimationController? animationController;
  final Animation<double>? widthAnimation;

  const SideMenu({
    super.key,
    this.collapsed = false,
    this.animationController,
    this.widthAnimation,
  });

  @override
  Widget build(BuildContext context) {
    bool shouldShowThemeSwitcher = widthAnimation != null &&
        widthAnimation!.value >= MenuDimensions.menuOpenWidth;
    return BlocProvider.value(
      value: BlocProvider.of<MenuCubit>(context),
      child: BlocBuilder<MenuCubit, MenuState>(
        builder: (context, state) {
          return ListView(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 40),
              MenuItem(
                  path: RoutePaths.profilePath,
                  icon: Icons.person,
                  type: MenuItems.profile,
                  isURLMatching:
                      Modular.to.path.endsWith(RoutePaths.profilePath),
                  isCollapsed: collapsed,
                  animationController: animationController),
              const SizedBox(height: 52),
              MenuItem(
                  path: RoutePaths.dashboardPath,
                  icon: Icons.dashboard,
                  type: MenuItems.dashboard,
                  isURLMatching:
                      Modular.to.path.endsWith(RoutePaths.dashboardPath),
                  isCollapsed: collapsed,
                  animationController: animationController),
              const SizedBox(height: 28),
              MenuItem(
                  path: RoutePaths.recommendationsPath,
                  icon: Icons.thumb_up,
                  type: MenuItems.recommendations,
                  isURLMatching:
                      Modular.to.path.endsWith(RoutePaths.recommendationsPath),
                  isCollapsed: collapsed,
                  animationController: animationController),
              const SizedBox(height: 28),
              MenuItem(
                  path: RoutePaths.promotersPath,
                  icon: Icons.phone_bluetooth_speaker,
                  type: MenuItems.promoters,
                  isURLMatching:
                      Modular.to.path.endsWith(RoutePaths.promotersPath),
                  isCollapsed: collapsed,
                  animationController: animationController),
              const SizedBox(height: 28),
              MenuItem(
                  path: RoutePaths.landingPagePath,
                  icon: Icons.airplanemode_active,
                  type: MenuItems.landingpage,
                  isURLMatching:
                      Modular.to.path.endsWith(RoutePaths.landingPagePath),
                  isCollapsed: collapsed,
                  animationController: animationController),
              const SizedBox(height: 28),
              MenuItem(
                  path: RoutePaths.activitiesPath,
                  icon: Icons.history,
                  type: MenuItems.activities,
                  isURLMatching:
                      Modular.to.path.endsWith(RoutePaths.activitiesPath),
                  isCollapsed: collapsed,
                  animationController: animationController),
              const SizedBox(height: 56),
              AnimatedOpacity(
                  opacity: shouldShowThemeSwitcher ? 1.0 : 0,
                  duration: const Duration(milliseconds: 100),
                  child: IgnorePointer(
                    ignoring: !shouldShowThemeSwitcher,
                    child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [ThemeSwitch()]),
                  )),
            ]),
          ]);
        },
      ),
    );
  }
}
