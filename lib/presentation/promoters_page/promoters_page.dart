import 'package:finanzbegleiter/application/permissions/permission_cubit.dart';
import 'package:finanzbegleiter/domain/entities/permissions.dart';
import 'package:finanzbegleiter/infrastructure/extensions/modular_watch_extension.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/tab_bar/custom_tab.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/tab_bar/tabbar_content.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoters_overview_wrapper.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_registration/register_promoters_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PromotersPage extends StatefulWidget {
  final String? editedPromoter;

  const PromotersPage({super.key, this.editedPromoter});

  @override
  State<PromotersPage> createState() => _PromotersPageState();
}

class _PromotersPageState extends State<PromotersPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  bool initialSnackbarAlreadyShown = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final permissions = (context.watchModular<PermissionCubit>().state
              as PermissionSuccessState)
          .permissions;

      if (mounted) {
        setState(() {
          tabController = TabController(
              length: permissions.hasRegisterPromoterPermission() ? 2 : 1,
              vsync: this);
        });
      }
    });
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
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    final permissions = (context.watchModular<PermissionCubit>().state
            as PermissionSuccessState)
        .permissions;

    return Padding(
      padding: EdgeInsets.only(top: responsiveValue.screenHeight * 0.02),
      child: tabController != null
          ? tabbar(responsiveValue, permissions, localization)
          : const SizedBox.shrink(),
    );
  }

  List<TabbarContent> getTabbarContent(
      Permissions permissions, AppLocalizations localization) {
    return [
      TabbarContent(
          tab: CustomTab(
              icon: Icons.people, title: localization.my_promoters_tab_title),
          content: PromotersOverviewWrapper(tabController: tabController)),
      if (_canAccessPromoterRegistration(permissions) &&
          tabController != null) ...[
        TabbarContent(
            tab: CustomTab(
                icon: Icons.person_add,
                title: localization.promoter_register_tab_title),
            content: RegisterPromotersView(
                tabController: tabController!,
                newPromoterCreated: () {
                  CustomSnackBar.of(context).showCustomSnackBar(
                      AppLocalizations.of(context)
                          .register_promoter_snackbar_success);
                }))
      ]
    ];
  }

  Widget tabbar(ResponsiveBreakpointsData responsiveValue,
      Permissions permissions, AppLocalizations localization) {
    return Column(
      children: [
        SizedBox(
            width: responsiveValue.largerThan(TABLET)
                ? responsiveValue.screenWidth * 0.6
                : responsiveValue.screenWidth * 0.9,
            child: TabBar(
                controller: tabController,
                tabs: getTabbarContent(permissions, localization)
                    .map((e) => e.tab)
                    .toList(),
                indicatorPadding: const EdgeInsets.only(bottom: 4))),
        Expanded(
            child: TabBarView(
                controller: tabController,
                physics: kIsWeb
                    ? const NeverScrollableScrollPhysics()
                    : const ScrollPhysics(),
                children: getTabbarContent(permissions, localization)
                    .map((e) => e.content)
                    .toList()))
      ],
    );
  }

  bool _canAccessPromoterRegistration(Permissions permissions) {
    if (permissions.hasRegisterPromoterPermission()) {
      return true;
    } else {
      return false;
    }
  }
}
