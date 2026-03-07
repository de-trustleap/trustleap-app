import 'package:finanzbegleiter/core/refresh/refreshable_state_mixin.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/tab_bar/custom_tabbar.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_archive/recommendation_manager_archive_overview_wrapper.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_overview/recommendation_manager_overview_wrapper.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:flutter/material.dart';

class RecommendationManagerPage extends StatefulWidget {
  const RecommendationManagerPage({super.key});

  @override
  State<RecommendationManagerPage> createState() =>
      _RecommendationManagerTabBarPageState();
}

class _RecommendationManagerTabBarPageState
    extends State<RecommendationManagerPage>
    with RefreshableStateMixin {
  Key _contentKey = UniqueKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      CustomNavigator.of(context).redirectToSubRoute(
        RoutePaths.recommendationManagerPath,
        "${RoutePaths.homePath}${RoutePaths.recommendationManagerPath}${RoutePaths.recommendationManagerActivePath}",
      );
    });
  }

  @override
  Future<void> onRefresh() async {
    setState(() => _contentKey = UniqueKey());
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return KeyedSubtree(
      key: ValueKey(_contentKey),
      child: CustomTabBar(
        tabs: getCustomTabItems(localization),
      ),
    );
  }

  List<CustomTabItem> getCustomTabItems(AppLocalizations localization) {
    return [
      CustomTabItem(
          title: localization.recommendation_manager_active_recommendations_tab,
          icon: Icons.thumb_up,
          route:
              "${RoutePaths.homePath}${RoutePaths.recommendationManagerPath}${RoutePaths.recommendationManagerActivePath}",
          content: const RecommendationManagerOverviewWrapper()),
      CustomTabItem(
          title: localization.recommendation_manager_achive_tab,
          icon: Icons.archive,
          route:
              "${RoutePaths.homePath}${RoutePaths.recommendationManagerPath}${RoutePaths.recommendationManagerArchivePath}",
          content: const RecommendationManagerArchiveOverviewWrapper())
    ];
  }
}
