// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/permissions/permission_cubit.dart';
import 'package:finanzbegleiter/application/promoter/promoter_observer/promoter_observer_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/infrastructure/extensions/modular_watch_extension.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/promoter_avatar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/tooltip_buttons/tooltip_icon.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/status_badge.dart';
import 'package:finanzbegleiter/presentation/promoters_page/promoter_helper.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PromotersOverviewGridTile extends StatelessWidget {
  final Promoter promoter;
  final Function(String, bool) deletePressed;

  const PromotersOverviewGridTile(
      {super.key, required this.promoter, required this.deletePressed});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveHelper.of(context);
    final localization = AppLocalizations.of(context);
    final navigator = CustomNavigator.of(context);
    final permissions = (context.watchModular<PermissionCubit>().state
            as PermissionSuccessState)
        .permissions;

    return Container(
      decoration: BoxDecoration(
          color: themeData.colorScheme.surface,
          border: Border.all(color: Colors.transparent),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (Modular.get<PromoterObserverCubit>()
                        .showLandingPageWarning(promoter)) ...[
                      TooltipIcon(
                        icon: Icons.warning,
                        text: localization
                            .promoter_overview_inactive_landingpage_tooltip_warning,
                        buttonText: localization
                            .promoter_overview_inactive_landingpage_tooltip_warning_action,
                        showButton: permissions.hasEditPromoterPermission(),
                        onPressed: () {
                          navigator.navigate(
                              "${RoutePaths.homePath}${RoutePaths.editPromoterPath}/${promoter.id.value}");
                        },
                      ),
                    ],
                    const Spacer(),
                    if (permissions.hasEditPromoterPermission() ||
                        permissions.hasDeletePromoterPermission()) ...[
                      PopupMenuButton(
                          itemBuilder: (context) => [
                                if (permissions
                                    .hasEditPromoterPermission()) ...[
                                  PopupMenuItem(
                                      value: "edit",
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(Icons.edit,
                                                color: themeData
                                                    .colorScheme.secondary,
                                                size: 24),
                                            const SizedBox(width: 8),
                                            Text(
                                                localization
                                                    .promoter_overview_edit_promoter_tooltip,
                                                style: responsiveValue.isMobile
                                                    ? themeData
                                                        .textTheme.bodySmall
                                                    : themeData
                                                        .textTheme.bodyMedium)
                                          ])),
                                ],
                                if (permissions
                                    .hasDeletePromoterPermission()) ...[
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
                                                localization
                                                    .promoter_overview_delete_promoter_tooltip,
                                                style: responsiveValue.isMobile
                                                    ? themeData
                                                        .textTheme.bodySmall
                                                    : themeData
                                                        .textTheme.bodyMedium)
                                          ])),
                                ]
                              ],
                          onSelected: (String newValue) {
                            if (newValue == "delete") {
                              deletePressed(promoter.id.value,
                                  promoter.registered ?? false);
                            } else if (newValue == "edit") {
                              navigator.navigate(
                                  "${RoutePaths.homePath}${RoutePaths.editPromoterPath}/${promoter.id.value}");
                            }
                          })
                    ]
                  ]),
              PromoterAvatar(
                thumbnailDownloadURL:
                    (promoter.registered == true) ? promoter.thumbnailDownloadURL : null,
                firstName: promoter.firstName,
                lastName: promoter.lastName,
                size: responsiveValue.largerThan(MOBILE) ? 120 : 140,
              ),
              const SizedBox(height: 4),
              SelectableText(
                  "${promoter.firstName ?? ""} ${promoter.lastName ?? ""}",
                  style: themeData.textTheme.bodySmall!
                      .copyWith(overflow: TextOverflow.ellipsis),
                  textAlign: TextAlign.center,
                  maxLines: 2),
              const SizedBox(height: 4),
              SelectableText(promoter.email ?? "",
                  style: themeData.textTheme.bodySmall!.copyWith(
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                      color: themeData.colorScheme.surfaceTint
                          .withValues(alpha: 0.6)),
                  maxLines: 1),
              if (promoter.registered != null) ...[
                const SizedBox(height: 8),
                StatusBadge(
                  isPositive: promoter.registered!,
                  label: promoter.registered!
                      ? localization.promoter_overview_registration_badge_registered
                      : localization.promoter_overview_registration_badge_unregistered,
                ),
              ],
              if (PromoterHelper(localization: localization)
                      .getPromoterDateText(context, promoter) !=
                  null) ...[
                const SizedBox(height: 8),
                SelectableText(
                    PromoterHelper(localization: localization)
                        .getPromoterDateText(context, promoter)!,
                    style: themeData.textTheme.bodySmall!.copyWith(
                        fontSize: responsiveValue.isMobile ? 10 : 12,
                        color: themeData.colorScheme.surfaceTint
                            .withValues(alpha: 0.6),
                        overflow: TextOverflow.ellipsis),
                    maxLines: 1)
              ]
            ]),
      ),
    );
  }

}
