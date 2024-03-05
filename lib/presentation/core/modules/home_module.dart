import 'package:finanzbegleiter/route_paths.dart';
import 'package:finanzbegleiter/presentation/activity_page/activity_page.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/home_page.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/dashboard_page.dart';
import 'package:finanzbegleiter/presentation/landing_page/landing_page.dart';
import 'package:finanzbegleiter/presentation/profile_page/profile_page.dart';
import 'package:finanzbegleiter/presentation/promoters_page/promoters_page.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/recommendations_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  void routes(r) {
    r.child(Modular.initialRoute,
        child: (_) => const HomePage(),
        transition: TransitionType.noTransition,
        children: [
          ChildRoute(RoutePaths.dashboardPath,
              child: (_) => const DashboardPage()),
          ChildRoute(RoutePaths.profilePath, child: (_) => const ProfilePage()),
          ChildRoute(RoutePaths.recommendationsPath,
              child: (_) => const RecommendationsPage()),
          ChildRoute(RoutePaths.promotersPath,
              child: (_) => const PromotersPage()),
          ChildRoute(RoutePaths.landingPagePath,
              child: (_) => const LandingPage()),
          ChildRoute(RoutePaths.activitiesPath,
              child: (_) => const ActivityPage()),
        ]);
    r.wildcard(child: (_) => const DashboardPage());
  }
}
