// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/menu/menu_cubit.dart';
import 'package:finanzbegleiter/application/permissions/permission_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/infrastructure/extensions/modular_watch_extension.dart';
import 'package:finanzbegleiter/presentation/core/menu/menu_item.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/theme_switch.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final permissions = (context.watchModular<PermissionCubit>().state
            as PermissionSuccessState)
        .permissions;
    return BlocBuilder<MenuCubit, MenuState>(
      builder: (context, state) {
        return ListView(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 40),
            MenuItem(
                path: RoutePaths.profilePath,
                icon: Icons.person,
                type: MenuItems.profile,
                isCollapsed: collapsed,
                animationController: animationController),
            const SizedBox(height: 52),
            MenuItem(
                path: RoutePaths.dashboardPath,
                icon: Icons.dashboard,
                type: MenuItems.dashboard,
                isCollapsed: collapsed,
                animationController: animationController),
            const SizedBox(height: 28),
            MenuItem(
                path: RoutePaths.recommendationsPath,
                icon: Icons.thumb_up,
                type: MenuItems.recommendations,
                isCollapsed: collapsed,
                animationController: animationController),
            const SizedBox(height: 28),
            MenuItem(
                path: RoutePaths.recommendationManagerPath,
                icon: Icons.receipt,
                type: MenuItems.recommendationManager,
                isCollapsed: collapsed,
                animationController: animationController),
            const SizedBox(height: 28),
            if (permissions.hasShowPromoterMenuPermission()) ...[
              MenuItem(
                  path: RoutePaths.promotersPath,
                  icon: Icons.phone_bluetooth_speaker,
                  type: MenuItems.promoters,
                  isCollapsed: collapsed,
                  animationController: animationController),
              const SizedBox(height: 28),
            ],
            if (permissions.hasShowLandingPageMenuPermission()) ...[
              MenuItem(
                  path: RoutePaths.landingPagePath,
                  icon: Icons.airplanemode_active,
                  type: MenuItems.landingpage,
                  isCollapsed: collapsed,
                  animationController: animationController),
              const SizedBox(height: 28),
            ],
            MenuItem(
                path: RoutePaths.activitiesPath,
                icon: Icons.history,
                type: MenuItems.activities,
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
    );
  }
}
