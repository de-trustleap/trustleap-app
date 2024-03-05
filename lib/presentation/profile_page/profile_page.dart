import 'package:finanzbegleiter/application/authentication/user/user_cubit.dart';
import 'package:finanzbegleiter/application/profile/observer/profile_observer_bloc.dart';
import 'package:finanzbegleiter/application/profile/profile_bloc/profile_cubit.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/profile_general_view.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/profile_password_forgotten_view.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/tab_bar/custom_tab.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/tab_bar/custom_tabbar.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/tab_bar/tabbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final List<TabbarContent> tabViews = [
    TabbarContent(
        tab: const CustomTab(title: "Allgemein"),
        content: const ProfileGeneralView()),
    TabbarContent(
        tab: const CustomTab(title: "Passwort vergessen"),
        content: const ProfilePasswordForgottenView())
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabViews.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final profileObserverBloc = Modular.get<ProfileObserverBloc>()
      ..add(ProfileObserveAllEvent());
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => profileObserverBloc),
      BlocProvider(
          create: (context) => Modular.get<ProfileCubit>()
            ..verifyEmail()
            ..getCurrentUser()),
      BlocProvider(create: (context) => Modular.get<UserCubit>())
    ], child: desktopView());
  }

  Widget desktopView() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomTabbar(
              controller: tabController,
              tabs: tabViews.map((e) => e.tab).toList()),
          Container(
              height: 400,
              child: TabBarView(
                  controller: tabController,
                  children: tabViews.map((e) => e.content).toList()))
        ]);
  }

  Widget mobileView() {
    return const Column();
  }
}
