// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:finanzbegleiter/core/helpers/date_time_formatter.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/placeholder_image.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageOverviewGridTile extends StatelessWidget {
  final LandingPage landingPage;
  final bool isDuplicationAllowed;
  final Function(String, String) deletePressed;
  final Function(String) duplicatePressed;

  const LandingPageOverviewGridTile(
      {super.key,
      required this.landingPage,
      required this.isDuplicationAllowed,
      required this.deletePressed,
      required this.duplicatePressed});

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

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return Container(
      width: responsiveValue.largerThan(MOBILE) ? 200 : 170,
      height: responsiveValue.largerThan(MOBILE) ? 300 : 300,
      decoration: BoxDecoration(
          color: (landingPage.isDefaultPage ?? false)
              ? themeData.colorScheme.primary
              : themeData.colorScheme.surface,
          border: Border.all(color: Colors.transparent),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (landingPage.isDefaultPage == null ||
                  (landingPage.isDefaultPage != null &&
                      landingPage.isDefaultPage! == false)) ...[
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            Modular.to.navigate(
                                RoutePaths.homePath +
                                    RoutePaths.landingPageCreatorPath,
                                arguments: landingPage);
                          },
                          iconSize: 24,
                          icon: Icon(Icons.edit,
                              color: themeData.colorScheme.secondary,
                              size: 24)),
                      const Spacer(),
                      PopupMenuButton(
                          itemBuilder: (context) => [
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
                                          Text("Löschen",
                                              style: responsiveValue.isMobile
                                                  ? themeData
                                                      .textTheme.bodySmall
                                                  : themeData
                                                      .textTheme.bodyMedium)
                                        ])),
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
                                          Text("Duplizieren",
                                              style:
                                                  getDuplicateButtonTextStyle(
                                                      responsiveValue,
                                                      themeData))
                                        ]))
                              ],
                          onSelected: (String newValue) {
                            if (newValue == "delete") {
                              deletePressed(landingPage.id.value,
                                  landingPage.ownerID?.value ?? "");
                            } else if (newValue == "duplicate") {
                              duplicatePressed(landingPage.id.value);
                            }
                          })
                    ]),
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
              Text(landingPage.name ?? "",
                  style: themeData.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              if (landingPage.createdAt != null &&
                  landingPage.lastUpdatedAt == null) ...[
                const SizedBox(height: 16),
                Text(
                    "Erstellt am ${DateTimeFormatter().getStringFromDate(context, landingPage.createdAt!)}",
                    style: themeData.textTheme.bodySmall!.copyWith(
                        fontSize: 12,
                        color:
                            themeData.colorScheme.surfaceTint.withOpacity(0.6)),
                    maxLines: 1)
              ] else if (landingPage.lastUpdatedAt != null) ...[
                const SizedBox(height: 8),
                Text(
                    "Geändert am ${DateTimeFormatter().getStringFromDate(context, landingPage.lastUpdatedAt!)}",
                    style: themeData.textTheme.bodySmall!.copyWith(
                        fontSize: 12,
                        color:
                            themeData.colorScheme.surfaceTint.withOpacity(0.6)),
                    maxLines: 1)
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
