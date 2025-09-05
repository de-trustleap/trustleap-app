import 'package:finanzbegleiter/application/company_request/company_request/company_request_cubit.dart';
import 'package:finanzbegleiter/application/images/company/company_image_bloc.dart';
import 'package:finanzbegleiter/application/images/profile/profile_image_bloc.dart';
import 'package:finanzbegleiter/application/permissions/permission_cubit.dart';
import 'package:finanzbegleiter/application/profile/company/company_cubit.dart';
import 'package:finanzbegleiter/application/profile/company_observer/company_observer_cubit.dart';
import 'package:finanzbegleiter/application/user_observer/user_observer_cubit.dart';
import 'package:finanzbegleiter/domain/entities/permissions.dart';
import 'package:finanzbegleiter/infrastructure/extensions/modular_watch_extension.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/tab_bar/custom_tabbar.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/company/profile_company_view.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/delete_account/profile_delete_account_view.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/password_update/profile_password_update_view.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/profile_general_view.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProfilePage extends StatefulWidget {
  final String? registeredCompany;

  const ProfilePage({super.key, this.registeredCompany});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    // Redirect /profile to /profile/general
    final currentRoute = Modular.to.path;
    if (currentRoute == RoutePaths.profilePath) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Modular.to.navigate(
            "${RoutePaths.homePath}${RoutePaths.profilePath}${RoutePaths.profileGeneralPath}");
      });
    }

    if (widget.registeredCompany == "true") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        CustomSnackBar.of(context).showCustomSnackBar(
            AppLocalizations.of(context)
                .profile_page_snackbar_company_registered);
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final permissions = (context.watchModular<PermissionCubit>().state
            as PermissionSuccessState)
        .permissions;
    final localization = AppLocalizations.of(context);
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => Modular.get<CompanyObserverCubit>()),
          BlocProvider(create: (context) => Modular.get<CompanyCubit>()),
          BlocProvider(create: (context) => Modular.get<ProfileImageBloc>()),
          BlocProvider(create: (context) => Modular.get<CompanyImageBloc>()),
          BlocProvider(create: (context) => Modular.get<CompanyRequestCubit>())
        ],
        child: BlocBuilder<UserObserverCubit, UserObserverState>(
          builder: (context, state) {
            return CustomTabBar(
              tabs: getCustomTabItems(state, permissions, localization),
            );
          },
        ));
  }

  bool _canAccessCompanyProfile(
      UserObserverSuccess state, Permissions permissions) {
    if (permissions.hasReadCompanyPermission() &&
        state.user.companyID != null) {
      return true;
    } else {
      return false;
    }
  }

  List<CustomTabItem> getCustomTabItems(
      UserObserverState state, Permissions permissions, AppLocalizations localization) {
    return [
      CustomTabItem(
          title: localization.profile_general_tab,
          icon: Icons.person,
          route:
              "${RoutePaths.homePath}${RoutePaths.profilePath}${RoutePaths.profileGeneralPath}",
          content: const ProfileGeneralView()),
      if (state is UserObserverSuccess &&
          _canAccessCompanyProfile(state, permissions)) ...[
        CustomTabItem(
            title: localization.profile_company_tab,
            icon: Icons.home,
            route:
                "${RoutePaths.homePath}${RoutePaths.profilePath}${RoutePaths.profileCompanyPath}",
            content: ProfileCompanyView(
                user: state.user, companyID: state.user.companyID!))
      ],
      CustomTabItem(
          title: localization.profile_password_tab,
          icon: Icons.lock,
          route:
              "${RoutePaths.homePath}${RoutePaths.profilePath}${RoutePaths.profilePasswordPath}",
          content: const ProfilePasswordUpdateView()),
      CustomTabItem(
          title: localization.profile_delete_tab,
          icon: Icons.delete_forever,
          route:
              "${RoutePaths.homePath}${RoutePaths.profilePath}${RoutePaths.profileDeletePath}",
          content: const ProfileDeleteAccountView())
    ];
  }
}
