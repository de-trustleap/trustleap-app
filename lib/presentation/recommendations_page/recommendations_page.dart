import 'package:finanzbegleiter/application/recommendations/recommendations/recommendations_cubit.dart';
import 'package:finanzbegleiter/application/recommendations/recommendations_observer/recommendations_observer_cubit.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/tab_bar/custom_tab.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/tab_bar/custom_tabbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/tab_bar/tabbar_content.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/widgets/promoters_overview.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/widgets/register_promoters_view.dart';
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

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final responsiveValue = ResponsiveBreakpoints.of(context);
    screenHeight = responsiveValue.screenHeight;
    topPadding = responsiveValue.screenHeight * 0.02;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                Modular.get<RecommendationsCubit>()..getCurrentUser()),
        BlocProvider(
            create: (context) => Modular.get<RecommendationsObserverCubit>()
              ..observeAllPromoters())
      ],
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: tabbar(),
      ),
    );
  }

  List<TabbarContent> getTabbarContent() {
    return [
      TabbarContent(
          tab: const CustomTab(title: "Meine Empfehlungsgeber"),
          content: PromotersOverview(tabController: tabController)),
      TabbarContent(
          tab: const CustomTab(title: "Empfehlungsgeber registrieren"),
          content: const RegisterPromotersView())
    ];
  }

  Widget tabbar() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomTabbar(
              controller: tabController,
              tabs: getTabbarContent().map((e) => e.tab).toList()),
          SizedBox(
              height: screenHeight * 0.85,
              child: TabBarView(
                  controller: tabController,
                  children: getTabbarContent().map((e) => e.content).toList()))
        ]);
  }
}
