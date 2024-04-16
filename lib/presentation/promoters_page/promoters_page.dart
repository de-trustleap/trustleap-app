import 'package:finanzbegleiter/application/promoter/promoter/promoter_cubit.dart';
import 'package:finanzbegleiter/application/promoter/promoter_observer/promoter_observer_cubit.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/tab_bar/custom_tab.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/tab_bar/tabbar_content.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoters_overview_wrapper.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_registration/register_promoters_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PromotersPage extends StatefulWidget {
  const PromotersPage({super.key});

  @override
  State<PromotersPage> createState() => _PromotersPageState();
}

class _PromotersPageState extends State<PromotersPage>
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
  void dispose() {
    tabController.dispose();
    super.dispose();
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
                Modular.get<PromoterCubit>()..getCurrentUser()),
        BlocProvider(
            create: (context) =>
                Modular.get<PromoterObserverCubit>()..observeAllPromoters())
      ],
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: tabbar(responsiveValue),
      ),
    );
  }

  List<TabbarContent> getTabbarContent() {
    return [
      TabbarContent(
          tab: const CustomTab(icon: Icons.people, title: "Meine Promoter"),
          content: PromotersOverviewWrapper(tabController: tabController)),
      TabbarContent(
          tab: const CustomTab(
              icon: Icons.person_add, title: "Promoter registrieren"),
          content: const RegisterPromotersView())
    ];
  }

  Widget tabbar(ResponsiveBreakpointsData responsiveValue) {
    return Column(
      children: [
        SizedBox(
            width: responsiveValue.largerThan(TABLET)
                ? responsiveValue.screenWidth * 0.6
                : responsiveValue.screenWidth * 0.9,
            child: TabBar(
                controller: tabController,
                tabs: getTabbarContent().map((e) => e.tab).toList(),
                indicatorPadding: const EdgeInsets.only(bottom: 4))),
        Expanded(
            child: TabBarView(
                controller: tabController,
                physics: kIsWeb
                    ? const NeverScrollableScrollPhysics()
                    : const ScrollPhysics(),
                children: getTabbarContent().map((e) => e.content).toList()))
      ],
    );
  }
}
