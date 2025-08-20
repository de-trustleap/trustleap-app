import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/tab_bar/custom_tabbar.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_archive/recommendation_manager_archive_overview_wrapper.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_manager_overview_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RecommendationManagerPage extends StatefulWidget {
  const RecommendationManagerPage({super.key});

  @override
  State<RecommendationManagerPage> createState() =>
      _RecommendationManagerTabBarPageState();
}

class _RecommendationManagerTabBarPageState
    extends State<RecommendationManagerPage> {

  @override
  void initState() {
    super.initState();
    
    // Redirect /recommendation-manager to /recommendation-manager/active
    final currentRoute = Modular.to.path;
    if (currentRoute == RoutePaths.recommendationManagerPath) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Modular.to.navigate("${RoutePaths.homePath}${RoutePaths.recommendationManagerPath}${RoutePaths.recommendationManagerActivePath}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);

    return Padding(
        padding: EdgeInsets.only(top: responsiveValue.screenHeight * 0.02),
        child: CustomTabBar(
          tabs: getCustomTabItems(localization),
        ));
  }

  List<CustomTabItem> getCustomTabItems(AppLocalizations localization) {
    return [
      CustomTabItem(
          title: localization.recommendation_manager_active_recommendations_tab,
          icon: Icons.thumb_up,
          route: "${RoutePaths.homePath}${RoutePaths.recommendationManagerPath}${RoutePaths.recommendationManagerActivePath}",
          content: const RecommendationManagerOverviewWrapper()),
      CustomTabItem(
          title: localization.recommendation_manager_achive_tab,
          icon: Icons.archive,
          route: "${RoutePaths.homePath}${RoutePaths.recommendationManagerPath}${RoutePaths.recommendationManagerArchivePath}",
          content: const RecommendationManagerArchiveOverviewWrapper())
    ];
  }
}
