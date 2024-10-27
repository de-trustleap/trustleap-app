import 'package:finanzbegleiter/presentation/activity_page/activity_page.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/home_page.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/dashboard_page.dart';
import 'package:finanzbegleiter/presentation/landing_page/landing_page.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_site/landing_page_site.dart';
import 'package:finanzbegleiter/presentation/page_builder/landing_page_builder_view.dart';
import 'package:finanzbegleiter/presentation/profile_page/profile_page.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/company_registration/company_registration_page.dart';
import 'package:finanzbegleiter/presentation/promoters_page/promoters_page.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/recommendations_page.dart';
import 'package:finanzbegleiter/route_paths.dart';
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
          ChildRoute(RoutePaths.profilePath,
              child: (_) => ProfilePage(
                  registeredCompany: r.args.queryParams["registeredCompany"])),
          ChildRoute(RoutePaths.companyRegistration,
              child: (_) => const CompanyRegistrationPage()),
          ChildRoute(RoutePaths.recommendationsPath,
              child: (_) => const RecommendationsPage()),
          ChildRoute(RoutePaths.promotersPath,
              child: (_) => const PromotersPage()),
          ChildRoute(RoutePaths.landingPagePath,
              child: (_) => LandingPageView(
                    createdNewPage: r.args.queryParams["createdNewPage"],
                    editedPage: r.args.queryParams["editedPage"],
                  )),
          ChildRoute(RoutePaths.landingPageCreatorPath,
              child: (_) => LandingPageCreator(landingPage: r.args.data)),
          ChildRoute(RoutePaths.activitiesPath,
              child: (_) => const ActivityPage()),
        ]);
    r.child(
        "${Modular.initialRoute}${RoutePaths.landingPagePath}/:landingPageId",
        child: (_) =>
            LandingPageSite(landingPageId: r.args.params['landingPageId']));
    r.child("${Modular.initialRoute}${RoutePaths.landingPageBuilderPath}/:id",
        child: (_) => LandingPageBuilderView());
    r.wildcard(child: (_) => const DashboardPage());
  }
}
