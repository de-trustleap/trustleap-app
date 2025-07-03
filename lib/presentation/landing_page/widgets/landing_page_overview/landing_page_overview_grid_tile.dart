// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:finanzbegleiter/application/permissions/permission_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/helpers/date_time_formatter.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/environment.dart';
import 'package:finanzbegleiter/infrastructure/extensions/modular_watch_extension.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/placeholder_image.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageOverviewGridTile extends StatelessWidget {
  final LandingPage landingPage;
  final CustomUser user;
  final bool isDuplicationAllowed;
  final Function(String, String, List<String>) deletePressed;
  final Function(String) duplicatePressed;
  final Function(String, bool) isActivePressed;

  const LandingPageOverviewGridTile(
      {super.key,
      required this.landingPage,
      required this.user,
      required this.isDuplicationAllowed,
      required this.deletePressed,
      required this.duplicatePressed,
      required this.isActivePressed});

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

  IconButton _getEditButton(
      ThemeData themeData, AppLocalizations localizations) {
    return IconButton(
        onPressed: () {
          CustomNavigator.pushNamed(
              "${RoutePaths.homePath}${RoutePaths.landingPageCreatorPath}",
              arguments: {"landingPage": landingPage});
        },
        iconSize: 24,
        tooltip: localizations.landingpage_overview_edit_tooltip,
        icon:
            Icon(Icons.edit, color: themeData.colorScheme.secondary, size: 24));
  }

  bool _isDefaultPage() {
    return landingPage.isDefaultPage ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localizations = AppLocalizations.of(context);
    final permissions = (context.watchModular<PermissionCubit>().state
            as PermissionSuccessState)
        .permissions;

    if ((landingPage.ownerID == user.id ||
            (permissions.hasEditLandingPagePermission())) &&
        !_isDefaultPage()) {
      return InkWell(
          onTap: () => CustomNavigator.navigate(
              "${RoutePaths.homePath}${RoutePaths.landingPageBuilderPath}/${landingPage.id.value}"),
          child: buildTile(themeData, responsiveValue, localizations, context));
    } else {
      return buildTile(themeData, responsiveValue, localizations, context);
    }
  }

  Widget buildTile(
      ThemeData themeData,
      ResponsiveBreakpointsData responsiveValue,
      AppLocalizations localizations,
      BuildContext context) {
    final permissions =
        (context.watch<PermissionCubit>().state as PermissionSuccessState)
            .permissions;
    return Container(
      width: responsiveValue.largerThan(MOBILE) ? 200 : 170,
      height: 300,
      decoration: BoxDecoration(
          color: (landingPage.isDefaultPage ?? false)
              ? themeData.colorScheme.primary.withValues(alpha: 0.5)
              : themeData.colorScheme.surface,
          border: Border.all(color: Colors.transparent),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (!_isDefaultPage()) ...[
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (permissions.hasEditLandingPagePermission()) ...[
                        _getEditButton(themeData, localizations),
                        const Spacer(),
                      ],
                      IconButton(
                          onPressed: () {
                            final baseURL =
                                Environment().getLandingpageBaseURL();
                            CustomNavigator.openURLInNewTab(
                                "$baseURL?preview=true&id=${landingPage.id.value}");
                          },
                          iconSize: 24,
                          tooltip:
                              localizations.landingpage_overview_show_tooltip,
                          icon: Icon(Icons.preview,
                              color: themeData.colorScheme.secondary,
                              size: 24)),
                      const Spacer(),
                      PopupMenuButton(
                          itemBuilder: (context) => [
                                if (permissions
                                    .hasDeleteLandingPagePermission()) ...[
                                  PopupMenuItem(
                                      value: "delete",
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(Icons.delete,
                                                color: themeData
                                                    .colorScheme.secondary,
                                                size: 24),
                                            const SizedBox(width: 8),
                                            Text(
                                                localizations
                                                    .landingpage_overview_context_menu_delete,
                                                style: responsiveValue.isMobile
                                                    ? themeData
                                                        .textTheme.bodySmall
                                                    : themeData
                                                        .textTheme.bodyMedium)
                                          ]))
                                ],
                                if (permissions
                                    .hasDuplicateLandingPagePermission()) ...[
                                  PopupMenuItem(
                                      value: "duplicate",
                                      enabled: isDuplicationAllowed,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(Icons.copy,
                                                color: isDuplicationAllowed
                                                    ? themeData
                                                        .colorScheme.secondary
                                                    : Colors.grey,
                                                size: 24),
                                            const SizedBox(width: 8),
                                            Text(
                                                localizations
                                                    .landingpage_overview_context_menu_duplicate,
                                                style:
                                                    getDuplicateButtonTextStyle(
                                                        responsiveValue,
                                                        themeData))
                                          ])),
                                ],
                                if (landingPage.ownerID == user.id)
                                  PopupMenuItem(
                                      value: "toggleActivation",
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                                (landingPage.isActive ?? false)
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: themeData
                                                    .colorScheme.secondary,
                                                size: 24),
                                            const SizedBox(width: 8),
                                            Text(
                                                (landingPage.isActive ?? false)
                                                    ? localizations
                                                        .landingpage_overview_context_menu_disable
                                                    : localizations
                                                        .landingpage_overview_context_menu_enable,
                                                style: responsiveValue.isMobile
                                                    ? themeData
                                                        .textTheme.bodySmall
                                                    : themeData
                                                        .textTheme.bodyMedium)
                                          ]))
                              ],
                          onSelected: (String newValue) {
                            if (newValue == "delete") {
                              deletePressed(
                                  landingPage.id.value,
                                  landingPage.ownerID?.value ?? "",
                                  landingPage.associatedUsersIDs ?? []);
                            } else if (newValue == "duplicate") {
                              duplicatePressed(landingPage.id.value);
                            } else if (newValue == "toggleActivation") {
                              isActivePressed(landingPage.id.value,
                                  !(landingPage.isActive ?? false));
                            }
                          })
                    ]),
              ] else if (_isDefaultPage()) ...[
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (permissions
                          .hasEditDefaultLandingPagePermission()) ...[
                        _getEditButton(themeData, localizations),
                      ] else ...[
                        const SizedBox(height: 40)
                      ],
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            final baseURL =
                                Environment().getLandingpageBaseURL();
                            CustomNavigator.openURLInNewTab(
                                "$baseURL?preview=true&id=${landingPage.id.value}");
                          },
                          iconSize: 24,
                          tooltip:
                              localizations.landingpage_overview_show_tooltip,
                          icon: Icon(Icons.preview,
                              color: themeData.colorScheme.secondary,
                              size: 24)),
                    ])
              ] else ...[
                const Spacer()
              ],
              CachedNetworkImage(
                width: responsiveValue.largerThan(MOBILE) ? 120 : 140,
                height: responsiveValue.largerThan(MOBILE) ? 120 : 140,
                imageUrl: landingPage.thumbnailDownloadURL ?? "",
                imageBuilder: (context, imageProvider) {
                  return Container(
                      decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ));
                },
                placeholder: (context, url) {
                  return Stack(children: [
                    placeHolderImage(responsiveValue),
                    const LoadingIndicator()
                  ]);
                },
                errorWidget: (context, url, error) {
                  return placeHolderImage(responsiveValue);
                },
              ),
              const SizedBox(height: 8),
              SelectableText(landingPage.name ?? "",
                  style: themeData.textTheme.bodySmall!
                      .copyWith(overflow: TextOverflow.ellipsis),
                  textAlign: TextAlign.center,
                  maxLines: 2),
              if (landingPage.createdAt != null &&
                  landingPage.lastUpdatedAt == null) ...[
                const SizedBox(height: 16),
                SelectableText(
                    "Erstellt am ${DateTimeFormatter().getStringFromDate(context, landingPage.createdAt!)}",
                    style: themeData.textTheme.bodySmall!.copyWith(
                        fontSize: 12,
                        color: themeData.colorScheme.surfaceTint
                            .withValues(alpha: 0.6)),
                    maxLines: 1),
              ] else if (landingPage.lastUpdatedAt != null) ...[
                const SizedBox(height: 8),
                SelectableText(
                    "Geändert am ${DateTimeFormatter().getStringFromDate(context, landingPage.lastUpdatedAt!)}",
                    style: themeData.textTheme.bodySmall!.copyWith(
                        fontSize: 12,
                        color: themeData.colorScheme.surfaceTint
                            .withValues(alpha: 0.6)),
                    maxLines: 1)
              ],
              if (!(landingPage.isActive ?? false) &&
                  !(landingPage.isDefaultPage ?? false)) ...[
                SelectableText("DEAKTIVIERT",
                    style: themeData.textTheme.bodySmall!.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 255, 0, 0)),
                    maxLines: 1),
              ],
              const Spacer()
            ],
          )),
    );
  }

  Widget placeHolderImage(ResponsiveBreakpointsData responsiveValue) {
    return PlaceholderImage(
        imageSize: Size(responsiveValue.largerThan(MOBILE) ? 120 : 140,
            responsiveValue.largerThan(MOBILE) ? 120 : 140),
        hovered: false);
  }
}
