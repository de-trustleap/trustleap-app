import 'package:finanzbegleiter/application/authentication/user/user_cubit.dart';
import 'package:finanzbegleiter/application/images/images_bloc.dart';
import 'package:finanzbegleiter/application/profile/observer/profile_observer_bloc.dart';
import 'package:finanzbegleiter/application/profile/profile/profile_cubit.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/tab_bar/custom_tab.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/tab_bar/tabbar_content.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/password_update/profile_password_update_view.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/profile_general_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late double screenHeight;
  late double topPadding;
  late TabController tabController;
  final List<TabbarContent> tabViews = [
    TabbarContent(
        tab: const CustomTab(icon: Icons.person, title: "Allgemein"),
        content: const ProfileGeneralView()),
    TabbarContent(
        tab: const CustomTab(icon: Icons.lock, title: "Passwort ändern"),
        content: const ProfilePasswordUpdateView())
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabViews.length, vsync: this);
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
    final profileObserverBloc = Modular.get<ProfileObserverBloc>()
      ..add(ProfileObserveAllEvent());
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => profileObserverBloc),
          BlocProvider(
              create: (context) => Modular.get<ProfileCubit>()
                ..verifyEmail()
                ..getCurrentUser()),
          BlocProvider(create: (context) => Modular.get<UserCubit>()),
          BlocProvider(create: (context) => Modular.get<ImagesBloc>()),
        ],
        child: Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: tabbar(responsiveValue),
        ));
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
                tabs: tabViews.map((e) => e.tab).toList(),
                indicatorPadding: const EdgeInsets.only(bottom: 4))),
        Expanded(
            child: TabBarView(
                controller: tabController,
                physics: kIsWeb
                    ? const NeverScrollableScrollPhysics()
                    : const ScrollPhysics(),
                children: tabViews.map((e) => e.content).toList()))
      ],
    );
  }
}
