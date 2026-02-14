import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/navigation/custom_navigator_base.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page.dart';
import 'package:finanzbegleiter/features/permissions/domain/permissions.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/environment.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageOverviewGridTileTopActionRow extends StatelessWidget {
  final LandingPage landingPage;
  final CustomUser user;
  final bool isDuplicationAllowed;
  final Function(String, String, List<String>) deletePressed;
  final Function(String) duplicatePressed;
  final Function(String, bool) isActivePressed;
  final Permissions permissions;

  const LandingPageOverviewGridTileTopActionRow({
    super.key,
    required this.landingPage,
    required this.user,
    required this.isDuplicationAllowed,
    required this.deletePressed,
    required this.duplicatePressed,
    required this.isActivePressed,
    required this.permissions,
  });

  bool _isDefaultPage() {
    return landingPage.isDefaultPage ?? false;
  }

  bool _isPending() {
    return landingPage.contentID == null && !_isDefaultPage();
  }

  TextStyle getDuplicateButtonTextStyle(
      ResponsiveBreakpointsData responsiveValue, ThemeData themeData) {
    if (responsiveValue.isMobile) {
      return isDuplicationAllowed
          ? themeData.textTheme.bodySmall!
          : themeData.textTheme.bodySmall!.copyWith(color: Colors.grey);
    } else {
      return isDuplicationAllowed
          ? themeData.textTheme.bodyMedium!
          : themeData.textTheme.bodyMedium!.copyWith(color: Colors.grey);
    }
  }

  IconButton _getEditButton(ThemeData themeData, AppLocalizations localizations,
      CustomNavigatorBase navigator) {
    return IconButton(
        onPressed: () {
          navigator.pushNamed(
              "${RoutePaths.homePath}${RoutePaths.landingPageCreatorPath}",
              arguments: {"landingPage": landingPage});
        },
        iconSize: 24,
        tooltip: localizations.landingpage_overview_edit_tooltip,
        icon:
            Icon(Icons.edit, color: themeData.colorScheme.secondary, size: 24));
  }

  IconButton _getPreviewButton(ThemeData themeData,
      AppLocalizations localizations, CustomNavigatorBase navigator) {
    return IconButton(
        onPressed: () {
          final baseURL = Environment().getLandingpageBaseURL();
          navigator.openURLInNewTab(
              "$baseURL?preview=true&id=${landingPage.id.value}");
        },
        iconSize: 24,
        tooltip: localizations.landingpage_overview_show_tooltip,
        icon: Icon(Icons.preview,
            color: themeData.colorScheme.secondary, size: 24));
  }

  PopupMenuButton _buildPopupMenu(
      ThemeData themeData,
      AppLocalizations localizations,
      ResponsiveBreakpointsData responsiveValue) {
    return PopupMenuButton(
        itemBuilder: (context) => [
              if (permissions.hasDeleteLandingPagePermission()) ...[
                PopupMenuItem(
                    value: "delete",
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.delete,
                              color: themeData.colorScheme.secondary, size: 24),
                          const SizedBox(width: 8),
                          Text(
                              localizations
                                  .landingpage_overview_context_menu_delete,
                              style: responsiveValue.isMobile
                                  ? themeData.textTheme.bodySmall
                                  : themeData.textTheme.bodyMedium)
                        ]))
              ],
              if (permissions.hasDuplicateLandingPagePermission()) ...[
                PopupMenuItem(
                    value: "duplicate",
                    enabled: isDuplicationAllowed,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.copy,
                              color: isDuplicationAllowed
                                  ? themeData.colorScheme.secondary
                                  : Colors.grey,
                              size: 24),
                          const SizedBox(width: 8),
                          Text(
                              localizations
                                  .landingpage_overview_context_menu_duplicate,
                              style: getDuplicateButtonTextStyle(
                                  responsiveValue, themeData))
                        ])),
              ],
              if (landingPage.ownerID == user.id)
                PopupMenuItem(
                    value: "toggleActivation",
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                              (landingPage.isActive ?? false)
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: themeData.colorScheme.secondary,
                              size: 24),
                          const SizedBox(width: 8),
                          Text(
                              (landingPage.isActive ?? false)
                                  ? localizations
                                      .landingpage_overview_context_menu_disable
                                  : localizations
                                      .landingpage_overview_context_menu_enable,
                              style: responsiveValue.isMobile
                                  ? themeData.textTheme.bodySmall
                                  : themeData.textTheme.bodyMedium)
                        ]))
            ],
        onSelected: (dynamic newValue) {
          if (newValue == "delete") {
            deletePressed(
                landingPage.id.value,
                landingPage.ownerID?.value ?? "",
                landingPage.associatedUsersIDs ?? []);
          } else if (newValue == "duplicate") {
            duplicatePressed(landingPage.id.value);
          } else if (newValue == "toggleActivation") {
            isActivePressed(
                landingPage.id.value, !(landingPage.isActive ?? false));
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    final navigator = CustomNavigator.of(context);

    if (_isPending()) {
      return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Spacer(),
            Icon(Icons.schedule,
                color: themeData.colorScheme.secondary, size: 24),
          ]);
    }

    if (_isDefaultPage()) {
      return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (permissions.hasEditDefaultLandingPagePermission()) ...[
              _getEditButton(themeData, localization, navigator),
            ] else ...[
              const SizedBox(height: 40)
            ],
            const Spacer(),
            _getPreviewButton(themeData, localization, navigator),
          ]);
    }

    if (!_isDefaultPage()) {
      return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (permissions.hasEditLandingPagePermission()) ...[
              _getEditButton(themeData, localization, navigator),
              const Spacer(),
            ],
            _getPreviewButton(themeData, localization, navigator),
            const Spacer(),
            _buildPopupMenu(themeData, localization, responsiveValue)
          ]);
    }

    return const Spacer();
  }
}
