import 'package:finanzbegleiter/application/authentication/user/user_cubit.dart';
import 'package:finanzbegleiter/application/images/company/company_image_bloc.dart';
import 'package:finanzbegleiter/application/images/profile/profile_image_bloc.dart';
import 'package:finanzbegleiter/application/profile/company/company_cubit.dart';
import 'package:finanzbegleiter/application/profile/company_observer/company_observer_cubit.dart';
import 'package:finanzbegleiter/application/profile/profile_observer/profile_observer_bloc.dart';
import 'package:finanzbegleiter/application/profile/profile/profile_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/tab_bar/custom_tab.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/tab_bar/tabbar_content.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/company/profile_company_view.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/delete_account/profile_delete_account_view.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/password_update/profile_password_update_view.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/profile_general_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late double screenHeight;
  late double topPadding;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
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
      ..add(ProfileObserveUserEvent());
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => profileObserverBloc),
          BlocProvider(
              create: (context) => Modular.get<ProfileCubit>()
                ..verifyEmail()
                ..getCurrentUser()),
          BlocProvider(create: (context) => Modular.get<CompanyObserverCubit>()),
          BlocProvider(create: (context) => Modular.get<CompanyCubit>()),
          BlocProvider(create: (context) => Modular.get<UserCubit>()),
          BlocProvider(create: (context) => Modular.get<ProfileImageBloc>()),
          BlocProvider(create: (context) => Modular.get<CompanyImageBloc>())
        ],
        child: BlocBuilder<ProfileObserverBloc, ProfileObserverState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: tabbar(responsiveValue, state),
            );
          },
        ));
  }

  bool canAccessCompanyProfile(ProfileUserObserverSuccess state) {
    if (state.user.role == Role.company && state.user.companyID != null) {
      return true;
    } else if (state.user.role == Role.serviceProvider && state.user.companyID != null) {
      return true;
    } else {
      return false;
    }
  }

  List<TabbarContent> getTabbarContent(ProfileObserverState state) {
    return [
      TabbarContent(
          tab: const CustomTab(icon: Icons.person, title: "Persönliche Daten"),
          content: const ProfileGeneralView()),
      if (state is ProfileUserObserverSuccess && canAccessCompanyProfile(state)) ...[
        TabbarContent(
            tab: const CustomTab(icon: Icons.home, title: "Unternehmen"),
            content: ProfileCompanyView(user: state.user, companyID: state.user.companyID!))
      ],
      TabbarContent(
          tab: const CustomTab(icon: Icons.lock, title: "Passwort ändern"),
          content: const ProfilePasswordUpdateView()),
      TabbarContent(
          tab: const CustomTab(
              icon: Icons.delete_forever, title: "Account löschen"),
          content: const ProfileDeleteAccountView())
    ];
  }

  Widget tabbar(
      ResponsiveBreakpointsData responsiveValue, ProfileObserverState state) {
    List<TabbarContent> tabViews = getTabbarContent(state);
    tabController = TabController(length: tabViews.length, vsync: this);
    return Column(
      children: [
        SizedBox(
            width: responsiveValue.largerThan(TABLET)
                ? responsiveValue.screenWidth * 0.9
                : responsiveValue.screenWidth * 0.9,
            child: TabBar(
                controller: tabController,
                tabAlignment: responsiveValue.isMobile
                    ? TabAlignment.start
                    : TabAlignment.fill,
                isScrollable: responsiveValue.isMobile ? true : false,
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
