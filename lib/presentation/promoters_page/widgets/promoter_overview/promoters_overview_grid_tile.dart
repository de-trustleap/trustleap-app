// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:finanzbegleiter/application/promoter/promoter_observer/promoter_observer_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/placeholder_image.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/tooltip_icon.dart';
import 'package:finanzbegleiter/presentation/promoters_page/promoter_helper.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoter_registration_badge.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PromotersOverviewGridTile extends StatelessWidget {
  final Promoter promoter;
  final Function(String) deletePressed;

  const PromotersOverviewGridTile(
      {super.key, required this.promoter, required this.deletePressed});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);

    return Container(
      width: responsiveValue.largerThan(MOBILE) ? 200 : 170,
      height: responsiveValue.largerThan(MOBILE) ? 300 : 300,
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
                          text:
                              "Der Promoter hat keine aktiven Landingpages mehr zugewiesen",
                          buttonText: "Landingpage zuweisen",
                          onPressed: () => {
                                CustomNavigator.pushNamed(
                                    "${RoutePaths.homePath}${RoutePaths.editPromoterPath}",
                                    arguments: promoter)
                              }),
                    ],
                    const Spacer(),
                    PopupMenuButton(
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                  value: "edit",
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.delete,
                                            color:
                                                themeData.colorScheme.secondary,
                                            size: 24),
                                        const SizedBox(width: 8),
                                        Text(
                                            localization
                                                .promoter_overview_edit_promoter_tooltip,
                                            style: responsiveValue.isMobile
                                                ? themeData.textTheme.bodySmall
                                                : themeData
                                                    .textTheme.bodyMedium)
                                      ])),
                              PopupMenuItem(
                                  value: "delete",
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.copy,
                                            color:
                                                themeData.colorScheme.secondary,
                                            size: 24),
                                        const SizedBox(width: 8),
                                        Text(
                                            localization
                                                .promoter_overview_delete_promoter_tooltip,
                                            style: responsiveValue.isMobile
                                                ? themeData.textTheme.bodySmall
                                                : themeData
                                                    .textTheme.bodyMedium)
                                      ])),
                            ],
                        onSelected: (String newValue) {
                          if (newValue == "delete") {
                            deletePressed(promoter.id.value);
                          } else if (newValue == "edit") {
                            CustomNavigator.pushNamed(
                                "${RoutePaths.homePath}${RoutePaths.editPromoterPath}",
                                arguments: promoter);
                          }
                        })
                  ]),
              if (promoter.registered != null &&
                  promoter.registered! &&
                  promoter.thumbnailDownloadURL != null) ...[
                CachedNetworkImage(
                  width: responsiveValue.largerThan(MOBILE) ? 120 : 140,
                  height: responsiveValue.largerThan(MOBILE) ? 120 : 140,
                  imageUrl: promoter.thumbnailDownloadURL ?? "",
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
              ] else ...[
                placeHolderImage(responsiveValue)
              ],
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
                      color:
                          themeData.colorScheme.surfaceTint.withOpacity(0.6)),
                  maxLines: 1),
              if (promoter.registered != null) ...[
                const SizedBox(height: 8),
                PromoterRegistrationBadge(
                    state: promoter.registered!
                        ? PromoterRegistrationState.registered
                        : PromoterRegistrationState.unregistered)
              ],
              if (PromoterHelper(localization: localization)
                      .getPromoterDateText(context, promoter) !=
                  null) ...[
                const SizedBox(height: 8),
                SelectableText(
                    PromoterHelper(localization: localization)
                        .getPromoterDateText(context, promoter)!,
                    style: themeData.textTheme.bodySmall!.copyWith(
                        fontSize: 12,
                        color:
                            themeData.colorScheme.surfaceTint.withOpacity(0.6)),
                    maxLines: 1)
              ]
            ]),
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

// TODO: Fehler auch bei deaktivierten pages anzeigen (FERTIG)
// TODO: Bei Edit Landingpages deaktiviert anzeigen wenn deaktiviert (FERTIG)
// TODO: Lamdingpages sollen bei editLandingpages aktiviert werden können (FERTIG)
// TODO: FEHLER BEI PROMOTER IMAGES (THE ERROR) (FERTIG)
// TODO: SORTIERUNG VON PROMOTER KACHELN AUF OVERVIEW (FERTIG)
// TODO: LANDINGPAGE CHECKBOXES SOLLTEN ALPHABETISCH SORTIERT SEIN (FERTIG)
// TODO: TESTS FÜR REPO UND CUBIT (INSB. SORTING UND SHOWWARNING) (FERTIG)
// TODO: CARD SO GROß WIE BEI LANDINGPAGES
// TODO: EDIT UND DELETE PROMOTER BERECHTIGUNGEN
// TODO: LOCALIZATIONS