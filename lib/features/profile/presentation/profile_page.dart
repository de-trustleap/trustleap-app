import 'package:finanzbegleiter/features/permissions/application/permission_cubit.dart';
import 'package:finanzbegleiter/features/user_observer/user_observer_cubit.dart';
import 'package:finanzbegleiter/features/permissions/domain/permissions.dart';
import 'package:finanzbegleiter/core/modular_watch_extension.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/tab_bar/custom_tabbar.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/company/profile_company_view.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/delete_account/profile_delete_account_view.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/password_update/profile_password_update_view.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/profile_general_view.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProfilePage extends StatefulWidget {
  final String? registeredCompany;

  const ProfilePage({super.key, this.registeredCompany});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      CustomNavigator.of(context).redirectToSubRoute(
        RoutePaths.profilePath,
        "${RoutePaths.homePath}${RoutePaths.profilePath}${RoutePaths.profileGeneralPath}",
      );
    });

    if (widget.registeredCompany == "true") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        CustomSnackBar.of(context).showCustomSnackBar(
            AppLocalizations.of(context)
                .profile_page_snackbar_company_registered);
      });
    }
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final permissions = (context.watchModular<PermissionCubit>().state
            as PermissionSuccessState)
        .permissions;
    final localization = AppLocalizations.of(context);
    return BlocBuilder<UserObserverCubit, UserObserverState>(
      bloc: Modular.get<UserObserverCubit>(),
      builder: (context, state) {
        return CustomTabBar(
          tabs: getCustomTabItems(state, permissions, localization),
        );
      },
    );
  }

  bool _canAccessCompanyProfile(
      UserObserverSuccess state, Permissions permissions) {
    if (permissions.hasReadCompanyPermission() &&
        state.user.companyID != null &&
        state.user.companyID!.isNotEmpty) {
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
