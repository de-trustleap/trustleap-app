import 'package:finanzbegleiter/application/menu/menu_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    handleNavigation();
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) {
      handleNavigation();
    }
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) {
      handleNavigation();
    }
    super.didPop(route, previousRoute);
  }

  void handleNavigation() {
    final path = Modular.to.path;

    final MenuCubit menuCubit = Modular.get<MenuCubit>();

    if (path.contains(RoutePaths.profilePath)) {
      menuCubit.selectMenu(MenuItems.profile);
    } else if (path.contains(RoutePaths.dashboardPath)) {
      menuCubit.selectMenu(MenuItems.dashboard);
    } else if (path.contains(RoutePaths.recommendationsPath)) {
      menuCubit.selectMenu(MenuItems.recommendations);
    } else if (path.contains(RoutePaths.recommendationManagerPath)) {
      menuCubit.selectMenu(MenuItems.recommendationManager);
    } else if (path.contains(RoutePaths.promotersPath)) {
      menuCubit.selectMenu(MenuItems.promoters);
    } else if (path.contains(RoutePaths.landingPagePath)) {
      menuCubit.selectMenu(MenuItems.landingpage);
    } else if (path.contains(RoutePaths.activitiesPath)) {
      menuCubit.selectMenu(MenuItems.activities);
    } else {
      menuCubit.selectMenu(MenuItems.none);
    }
  }
}
