import 'package:finanzbegleiter/application/recommendations/recommendations_cubit.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/tab_bar/custom_tab.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/tab_bar/custom_tabbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/tab_bar/tabbar_content.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/widgets/register_recommendors_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class RecommendationsPage extends StatefulWidget {
  const RecommendationsPage({super.key});

  @override
  State<RecommendationsPage> createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late double screenHeight;
  late double topPadding;
  final List<TabbarContent> tabViews = [
    TabbarContent(
        tab: const CustomTab(title: "Test"), content: const Placeholder()),
    TabbarContent(
        tab: const CustomTab(title: "Empfehlungsgeber registrieren"),
        content: const RegisterRecommendorsView())
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabViews.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final responsiveValue = ResponsiveBreakpoints.of(context);
    screenHeight = responsiveValue.screenHeight;
    topPadding = responsiveValue.screenHeight * 0.02;
    return BlocProvider(
      create: (context) => Modular.get<RecommendationsCubit>(),
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: tabbar(),
      ),
    );
  }

  Widget tabbar() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomTabbar(
              controller: tabController,
              tabs: tabViews.map((e) => e.tab).toList()),
          SizedBox(
              height: screenHeight * 0.85,
              child: TabBarView(
                  controller: tabController,
                  children: tabViews.map((e) => e.content).toList()))
        ]);
  }
}
