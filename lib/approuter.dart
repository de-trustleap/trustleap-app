import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/presentation/activity_page/activity_page.dart';
import 'package:finanzbegleiter/presentation/authentication/login_page.dart';
import 'package:finanzbegleiter/presentation/authentication/register_page.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/dashboard_page.dart';
import 'package:finanzbegleiter/presentation/landing_page/landing_page.dart';
import 'package:finanzbegleiter/presentation/profile_page/profile_page.dart';
import 'package:finanzbegleiter/presentation/promoters_page/promoters_page.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/recommendations_page.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class AppRouter {
  static final AppRouter _singleton = AppRouter._internal();

  factory AppRouter() {
    return _singleton;
  }

  AppRouter._internal();

  RouteMap getRoutes(bool isAuthenticated) {
    print("ISAUTHENTICATED: $isAuthenticated");
    if (isAuthenticated) {
      return RouteMap(
          onUnknownRoute: (route) {
            return const MaterialPage(child: Placeholder(color: Colors.red));
          },
          routes: {
            RoutePaths.initialPath: (_) =>
                const Redirect(RoutePaths.dashboardPath),
            RoutePaths.registerPath: (_) =>
                const Redirect(RoutePaths.dashboardPath),
            RoutePaths.dashboardPath: (_) =>
                const MaterialPage(child: DashboardPage()),
            RoutePaths.profilePath: (_) =>
                const MaterialPage(child: ProfilePage()),
            RoutePaths.recommendationsPath: (_) =>
                const MaterialPage(child: RecommendationsPage()),
            RoutePaths.promotersPath: (_) =>
                const MaterialPage(child: PromotersPage()),
            RoutePaths.landingPagePath: (_) =>
                const MaterialPage(child: LandingPage()),
            RoutePaths.activitiesPath: (_) =>
                const MaterialPage(child: ActivityPage()),
          });
    } else {
      return RouteMap(
        onUnknownRoute: (_) => const Redirect(RoutePaths.initialPath),
        routes: {
          RoutePaths.initialPath: (_) => const MaterialPage(child: LoginPage()),
          RoutePaths.registerPath: (_) =>
              const MaterialPage(child: RegisterPage()),
          RoutePaths.loginPath: (_) => const MaterialPage(child: LoginPage()),
        },
      );
    }
  }
}
