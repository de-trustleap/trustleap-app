import 'package:finanzbegleiter/presentation/core/shared_elements/tab_bar/custom_tab.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/tab_bar/tabbar_content.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_archive_overview.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_manager_overview_wrapper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RecommendationManagerPage extends StatefulWidget {
  const RecommendationManagerPage({super.key});

  @override
  State<RecommendationManagerPage> createState() =>
      _RecommendationManagerTabBarPageState();
}

class _RecommendationManagerTabBarPageState
    extends State<RecommendationManagerPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return Padding(
        padding: EdgeInsets.only(top: responsiveValue.screenHeight * 0.02),
        child: tabbar(responsiveValue));
  }

  List<TabbarContent> getTabbarContent() {
    return [
      TabbarContent(
          tab: const CustomTab(
              title: "Aktive Empfehlungen", icon: Icons.thumb_up),
          content: const RecommendationManagerOverviewWrapper()),
      TabbarContent(
          tab: const CustomTab(title: "Archiv", icon: Icons.archive),
          content: const RecommendationManagerArchiveOverview())
    ];
  }

  Widget tabbar(ResponsiveBreakpointsData responsiveValue) {
    return Column(children: [
      SizedBox(
        width: responsiveValue.largerThan(TABLET)
            ? responsiveValue.screenWidth * 0.6
            : responsiveValue.screenWidth * 0.9,
        child: TabBar(
            controller: tabController,
            tabs: getTabbarContent().map((e) => e.tab).toList(),
            indicatorPadding: const EdgeInsets.only(bottom: 4)),
      ),
      Expanded(
          child: TabBarView(
              controller: tabController,
              physics: kIsWeb
                  ? const NeverScrollableScrollPhysics()
                  : const ScrollPhysics(),
              children: getTabbarContent().map((e) => e.content).toList()))
    ]);
  }
}
