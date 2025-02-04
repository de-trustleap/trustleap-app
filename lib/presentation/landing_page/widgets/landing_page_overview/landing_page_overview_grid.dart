// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/permissions/permission_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/infrastructure/extensions/modular_watch_extension.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_overview/add_new_landing_page_grid_tile.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_overview/landing_page_overview_grid_tile.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageOverviewGrid extends StatelessWidget {
  final List<LandingPage> landingpages;
  final CustomUser user;
  final Function(String, String) deletePressed;
  final Function(String) duplicatePressed;
  final Function(String, bool) isActivePressed;
  const LandingPageOverviewGrid(
      {super.key,
      required this.landingpages,
      required this.user,
      required this.deletePressed,
      required this.duplicatePressed,
      required this.isActivePressed});

  final maxLandingPageCount = 11;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    final permissions = (context.watchModular<PermissionCubit>().state
            as PermissionSuccessState)
        .permissions;

    return Container(
      constraints: const BoxConstraints(maxHeight: 600),
      child: AnimationLimiter(
        child: GridView.count(
          crossAxisCount: responsiveValue.largerThan(MOBILE) ? 3 : 2,
          crossAxisSpacing: responsiveValue.largerThan(MOBILE) ? 24 : 12,
          mainAxisSpacing: responsiveValue.largerThan(MOBILE) ? 24 : 12,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const ScrollPhysics(),
          childAspectRatio: calculateChildAspectRatio(responsiveValue),
          children: List.generate(
            landingpages.length +
                (permissions.hasCreateLandingPagePermission() ? 1 : 0),
            (index) {
              if (permissions.hasCreateLandingPagePermission() && index == 0) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 150),
                  columnCount: responsiveValue.largerThan(MOBILE) ? 3 : 2,
                  child: ScaleAnimation(
                    child: Center(
                      child: GridTile(
                        child: landingpages.length >= maxLandingPageCount
                            ? Center(
                                child: SelectableText(
                                  localization
                                      .landingpage_overview_max_count_msg,
                                  style:
                                      themeData.textTheme.labelSmall!.copyWith(
                                    fontSize:
                                        responsiveValue.isMobile ? 10 : 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : AddNewLandingPageGridTile(
                                onPressed: () => CustomNavigator.navigate(
                                  RoutePaths.homePath +
                                      RoutePaths.landingPageCreatorPath,
                                ),
                              ),
                      ),
                    ),
                  ),
                );
              }

              // Wenn der Index größer als 0 ist, zeigen wir eine Landing Page an und verschieben den Index um 1
              int landingPageIndex = index -
                  (permissions.hasCreateLandingPagePermission() ? 1 : 0);

              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 150),
                columnCount: responsiveValue.largerThan(MOBILE) ? 3 : 2,
                child: ScaleAnimation(
                  child: Center(
                    child: GridTile(
                      child: LandingPageOverviewGridTile(
                        landingPage: landingpages[landingPageIndex],
                        user: user,
                        isDuplicationAllowed:
                            landingpages.length < maxLandingPageCount,
                        deletePressed: deletePressed,
                        duplicatePressed: duplicatePressed,
                        isActivePressed: isActivePressed,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

double calculateChildAspectRatio(ResponsiveBreakpointsData responsiveValue) {
  if (responsiveValue.isDesktop) {
    return 0.85;
  } else if (responsiveValue.isTablet) {
    return 0.67;
  } else {
    return 0.6;
  }
}
