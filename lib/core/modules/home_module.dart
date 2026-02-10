import 'package:finanzbegleiter/core/page_transitions.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/home_page.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/dashboard_page.dart';
import 'package:finanzbegleiter/presentation/landing_page/landing_page.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_detail/landing_page_detail_page.dart';
import 'package:finanzbegleiter/presentation/legals_page/legals_page.dart';
import 'package:finanzbegleiter/presentation/page_builder/landing_page_builder_view.dart';
import 'package:finanzbegleiter/presentation/profile_page/profile_page.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/company_registration/company_registration_page.dart';
import 'package:finanzbegleiter/presentation/promoters_page/promoters_page.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_detail/promoter_detail_page.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_edit/promoter_edit_page.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_page.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/recommendations_page.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  void routes(r) {
    r.child(Modular.initialRoute,
        child: (_) => const HomePage(),
        transition: TransitionType.custom,
        customTransition: PageTransitions.fadePageTransition,
        children: [
          ChildRoute(RoutePaths.dashboardPath,
              child: (_) => const DashboardPage()),
          ChildRoute(RoutePaths.profilePath,
              child: (_) => ProfilePage(
                  registeredCompany: r.args.queryParams["registeredCompany"]),
              children: [
                ChildRoute(RoutePaths.profileGeneralPath,
                    child: (_) => ProfilePage(
                        registeredCompany:
                            r.args.queryParams["registeredCompany"])),
                ChildRoute(RoutePaths.profileCompanyPath,
                    child: (_) => ProfilePage(
                        registeredCompany:
                            r.args.queryParams["registeredCompany"])),
                ChildRoute(RoutePaths.profilePasswordPath,
                    child: (_) => ProfilePage(
                        registeredCompany:
                            r.args.queryParams["registeredCompany"])),
                ChildRoute(RoutePaths.profileDeletePath,
                    child: (_) => ProfilePage(
                        registeredCompany:
                            r.args.queryParams["registeredCompany"])),
              ]),
          ChildRoute(RoutePaths.companyRegistration,
              child: (_) => const CompanyRegistrationPage()),
          ChildRoute(RoutePaths.recommendationsPath,
              child: (_) => const RecommendationsPage()),
          ChildRoute(RoutePaths.recommendationManagerPath,
              child: (_) => const RecommendationManagerPage(),
              children: [
                ChildRoute(RoutePaths.recommendationManagerActivePath,
                    child: (_) => const RecommendationManagerPage()),
                ChildRoute(RoutePaths.recommendationManagerArchivePath,
                    child: (_) => const RecommendationManagerPage()),
              ]),
          ChildRoute(RoutePaths.promotersPath,
              child: (_) => PromotersPage(
                    editedPromoter: r.args.queryParams["editedPromoter"],
                  ),
              children: [
                ChildRoute(RoutePaths.promotersOverviewPath,
                    child: (_) => PromotersPage(
                        editedPromoter: r.args.queryParams["editedPromoter"])),
                ChildRoute(RoutePaths.promotersRegisterPath,
                    child: (_) => PromotersPage(
                        editedPromoter: r.args.queryParams["editedPromoter"])),
              ]),
          ChildRoute("${RoutePaths.editPromoterPath}/:id",
              child: (_) =>
                  PromoterEditPage(promoterID: r.args.params["id"] ?? "")),
          ChildRoute("${RoutePaths.promoterDetailPath}/:id",
              child: (_) => PromoterDetailPage(
                    promoterId: r.args.params["id"] ?? "",
                  )),
          ChildRoute(RoutePaths.landingPagePath,
              child: (_) => LandingPageView(
                    createdNewPage: r.args.queryParams["createdNewPage"],
                    editedPage: r.args.queryParams["editedPage"],
                  )),
          ChildRoute("${RoutePaths.landingPageDetailPath}/:id",
              child: (_) => LandingPageDetailPage(
                    landingPageId: r.args.params["id"] ?? "",
                  )),
          ChildRoute(RoutePaths.landingPageCreatorPath, child: (_) {
            final args = r.args.data as Map<String, dynamic>?;
            return LandingPageCreator(
                landingPage: args?["landingPage"],
                createDefaultPage: args?["createDefaultPage"] ?? false);
          }, children: [
            ChildRoute(RoutePaths.landingPageCreatorStep1Path, child: (_) {
              final args = r.args.data as Map<String, dynamic>?;
              return LandingPageCreator(
                  landingPage: args?["landingPage"],
                  createDefaultPage: args?["createDefaultPage"] ?? false);
            }),
            ChildRoute(RoutePaths.landingPageCreatorStep2Path, child: (_) {
              final args = r.args.data as Map<String, dynamic>?;
              return LandingPageCreator(
                  landingPage: args?["landingPage"],
                  createDefaultPage: args?["createDefaultPage"] ?? false);
            }),
            ChildRoute(RoutePaths.landingPageCreatorStep3Path, child: (_) {
              final args = r.args.data as Map<String, dynamic>?;
              return LandingPageCreator(
                  landingPage: args?["landingPage"],
                  createDefaultPage: args?["createDefaultPage"] ?? false);
            }),
            ChildRoute(RoutePaths.landingPageCreatorStep4Path, child: (_) {
              final args = r.args.data as Map<String, dynamic>?;
              return LandingPageCreator(
                  landingPage: args?["landingPage"],
                  createDefaultPage: args?["createDefaultPage"] ?? false);
            }),
          ])
        ]);
    r.child("${Modular.initialRoute}${RoutePaths.landingPageBuilderPath}/:id",
        child: (_) => const LandingPageBuilderView());
    r.child("${Modular.initialRoute}${RoutePaths.privacyPolicy}",
        child: (_) => const LegalsPage());
    r.child("${Modular.initialRoute}${RoutePaths.termsAndCondition}",
        child: (_) => const LegalsPage());
    r.child("${Modular.initialRoute}${RoutePaths.imprint}",
        child: (_) => const LegalsPage());
    r.wildcard(child: (_) => const DashboardPage());
  }
}
