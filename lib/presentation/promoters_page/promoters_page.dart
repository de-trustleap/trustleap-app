import 'package:finanzbegleiter/application/permissions/permission_cubit.dart';
import 'package:finanzbegleiter/domain/entities/permissions.dart';
import 'package:finanzbegleiter/infrastructure/extensions/modular_watch_extension.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/tab_bar/custom_tabbar.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoters_overview_wrapper.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_registration/register_promoters_view.dart';
import 'package:flutter/material.dart';

class PromotersPage extends StatefulWidget {
  final String? editedPromoter;

  const PromotersPage({super.key, this.editedPromoter});

  @override
  State<PromotersPage> createState() => _PromotersPageState();
}

class _PromotersPageState extends State<PromotersPage> {
  bool initialSnackbarAlreadyShown = false;
  final _overviewKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    // Redirect /promoters to /promoters/overview
    final currentRoute = Modular.to.path;
    if (currentRoute == RoutePaths.promotersPath) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Modular.to.navigate("${RoutePaths.homePath}${RoutePaths.promotersPath}${RoutePaths.promotersOverviewPath}");
      });
    }

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialSnackbarAlreadyShown) {
      if (widget.editedPromoter == "true") {
        final localization = AppLocalizations.of(context);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          CustomSnackBar.of(context).showCustomSnackBar(
              localization.promoter_page_edit_promoter_snackbar_title);
        });
      }
      initialSnackbarAlreadyShown = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final permissions = (context.watchModular<PermissionCubit>().state
            as PermissionSuccessState)
        .permissions;

    return CustomTabBar(
      tabs: getCustomTabItems(permissions, localization),
    );
  }

  List<CustomTabItem> getCustomTabItems(
      Permissions permissions, AppLocalizations localization) {
    return [
      CustomTabItem(
          title: localization.my_promoters_tab_title,
          icon: Icons.people,
          route: "${RoutePaths.homePath}${RoutePaths.promotersPath}${RoutePaths.promotersOverviewPath}",
          content: PromotersOverviewWrapper(key: _overviewKey)),
      if (_canAccessPromoterRegistration(permissions)) ...[
        CustomTabItem(
            title: localization.promoter_register_tab_title,
            icon: Icons.person_add,
            route: "${RoutePaths.homePath}${RoutePaths.promotersPath}${RoutePaths.promotersRegisterPath}",
            content: RegisterPromotersView(
                newPromoterCreated: () {
                  CustomSnackBar.of(context).showCustomSnackBar(
                      AppLocalizations.of(context)
                          .register_promoter_snackbar_success);
                }))
      ]
    ];
  }


  bool _canAccessPromoterRegistration(Permissions permissions) {
    if (permissions.hasRegisterPromoterPermission()) {
      return true;
    } else {
      return false;
    }
  }
}
