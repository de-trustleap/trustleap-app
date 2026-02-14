// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/features/permissions/application/permission_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/core/modular_watch_extension.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/animated_tile_grid.dart';
import 'package:finanzbegleiter/features/landing_pages/presentation/widgets/landing_page_overview/add_new_landing_page_grid_tile.dart';
import 'package:finanzbegleiter/features/landing_pages/presentation/widgets/landing_page_overview/landing_page_overview_grid_tile.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageOverviewGrid extends StatelessWidget {
  final List<LandingPage> landingpages;
  final CustomUser user;
  final Function(String, String, List<String>) deletePressed;
  final Function(String) duplicatePressed;
  final Function(String, bool) isActivePressed;

  const LandingPageOverviewGrid({
    super.key,
    required this.landingpages,
    required this.user,
    required this.deletePressed,
    required this.duplicatePressed,
    required this.isActivePressed,
  });

  static const maxLandingPageCount = 11;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    final navigator = CustomNavigator.of(context);
    final permissions = (context.watchModular<PermissionCubit>().state
            as PermissionSuccessState)
        .permissions;

    final hasCreatePermission = permissions.hasCreateLandingPagePermission();
    final itemCount = landingpages.length + (hasCreatePermission ? 1 : 0);

    return AnimatedTileGrid(
      itemCount: itemCount,
      gridName: 'landingpage-grid',
      desktopAspectRatio: 0.7,
      mobileAspectRatio: 0.55,
      itemBuilder: (index, tileWidth, tileHeight) {
        if (hasCreatePermission && index == 0) {
          return landingpages.length >= maxLandingPageCount
              ? Center(
                  child: SelectableText(
                    localization.landingpage_overview_max_count_msg,
                    style: themeData.textTheme.labelSmall!.copyWith(
                      fontSize: responsiveValue.isMobile ? 10 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : AddNewLandingPageGridTile(
                  onPressed: () => navigator.navigate(
                    RoutePaths.homePath + RoutePaths.landingPageCreatorPath,
                  ),
                );
        }

        final landingPageIndex = index - (hasCreatePermission ? 1 : 0);

        return LandingPageOverviewGridTile(
          landingPage: landingpages[landingPageIndex],
          user: user,
          isDuplicationAllowed: landingpages.length < maxLandingPageCount,
          deletePressed: deletePressed,
          duplicatePressed: duplicatePressed,
          isActivePressed: isActivePressed,
        );
      },
    );
  }
}
