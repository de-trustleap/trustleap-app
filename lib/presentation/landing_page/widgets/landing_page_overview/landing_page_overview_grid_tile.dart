// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:finanzbegleiter/application/permissions/permission_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/helpers/date_time_formatter.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/infrastructure/extensions/modular_watch_extension.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/placeholder_image.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/status_badge.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_overview/landing_page_overview_grid_tile_top_action_row.dart';
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

  bool _isDefaultPage() {
    return landingPage.isDefaultPage ?? false;
  }

  bool _isPending() {
    return landingPage.contentID == null && !_isDefaultPage();
  }

  Color? _getBackgroundColor(ThemeData themeData) {
    if (_isPending()) {
      return themeData.colorScheme.surface.withValues(alpha: 0.5);
    } else if (_isDefaultPage()) {
      return null; // Use gradient instead
    } else {
      return themeData.colorScheme.surface;
    }
  }

  Gradient? _getBackgroundGradient(ThemeData themeData) {
    if (_isDefaultPage()) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          themeData.colorScheme.primary.withValues(alpha: 0.3),
          themeData.colorScheme.primary.withValues(alpha: 0.15),
        ],
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localizations = AppLocalizations.of(context);
    final navigator = CustomNavigator.of(context);
    final permissions = (context.watchModular<PermissionCubit>().state
            as PermissionSuccessState)
        .permissions;

    if ((landingPage.ownerID == user.id ||
            (permissions.hasEditLandingPagePermission())) &&
        !_isDefaultPage() &&
        !_isPending()) {
      return InkWell(
          onTap: () => navigator.navigate(
              "${RoutePaths.homePath}${RoutePaths.landingPageDetailPath}/${landingPage.id.value}"),
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
    return Opacity(
      opacity: _isPending() ? 0.5 : 1.0,
      child: Tooltip(
        message: _isPending()
            ? localizations.landingpage_overview_pending_tooltip
            : "",
        child: Container(
          decoration: BoxDecoration(
              color: _getBackgroundColor(themeData),
              gradient: _getBackgroundGradient(themeData),
              border: Border.all(color: Colors.transparent),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LandingPageOverviewGridTileTopActionRow(
                    landingPage: landingPage,
                    user: user,
                    isDuplicationAllowed: isDuplicationAllowed,
                    deletePressed: deletePressed,
                    duplicatePressed: duplicatePressed,
                    isActivePressed: isActivePressed,
                    permissions: permissions,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CachedNetworkImage(
                          width: responsiveValue.largerThan(MOBILE) ? 120 : 140,
                          height:
                              responsiveValue.largerThan(MOBILE) ? 120 : 140,
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
                              "${localizations.landingpage_overview_created_at} ${DateTimeFormatter().getStringFromDate(context, landingPage.createdAt!)}",
                              style: themeData.textTheme.bodySmall!.copyWith(
                                  fontSize: responsiveValue.isMobile ? 10 : 12,
                                  color: themeData.colorScheme.surfaceTint
                                      .withValues(alpha: 0.6),
                                  overflow: TextOverflow.ellipsis),
                              maxLines: 1),
                        ] else if (landingPage.lastUpdatedAt != null) ...[
                          const SizedBox(height: 8),
                          SelectableText(
                              "${localizations.landingpage_overview_updated_at} ${DateTimeFormatter().getStringFromDate(context, landingPage.lastUpdatedAt!)}",
                              style: themeData.textTheme.bodySmall!.copyWith(
                                  fontSize: responsiveValue.isMobile ? 10 : 12,
                                  color: themeData.colorScheme.surfaceTint
                                      .withValues(alpha: 0.6),
                                  overflow: TextOverflow.ellipsis),
                              maxLines: 1)
                        ],
                        if (!(landingPage.isDefaultPage ?? false)) ...[
                          const SizedBox(height: 8),
                          StatusBadge(
                            isPositive: landingPage.isActive ?? false,
                            label: landingPage.isActive ?? false
                                ? localizations.landing_page_detail_status_active
                                : localizations.landing_page_detail_status_inactive,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget placeHolderImage(ResponsiveBreakpointsData responsiveValue) {
    return PlaceholderImage(
        imageSize: Size(responsiveValue.largerThan(MOBILE) ? 120 : 140,
            responsiveValue.largerThan(MOBILE) ? 120 : 140),
        hovered: false);
  }
}
