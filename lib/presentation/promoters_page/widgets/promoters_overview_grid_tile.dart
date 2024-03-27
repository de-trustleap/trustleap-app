// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/helpers/date_time_formatter.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/placeholder_image.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_registration_badge.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class PromotersOverviewGridTile extends StatelessWidget {
  final Promoter promoter;

  const PromotersOverviewGridTile({
    Key? key,
    required this.promoter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return Container(
      width: responsiveValue.largerThan(MOBILE) ? 200 : 170,
      height: responsiveValue.largerThan(MOBILE) ? 300 : 300,
      decoration: BoxDecoration(
          color: themeData.colorScheme.background,
          border: Border.all(color: Colors.transparent),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (promoter.registered != null && promoter.registered!) ...[
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
              Text("${promoter.firstName ?? ""} ${promoter.lastName ?? ""}",
                  style:
                      themeData.textTheme.headlineLarge!.copyWith(fontSize: 14),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(promoter.email ?? "",
                  style: themeData.textTheme.headlineLarge!.copyWith(
                      fontSize: 12,
                      color:
                          themeData.colorScheme.surfaceTint.withOpacity(0.6)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              if (promoter.registered != null) ...[
                const SizedBox(height: 8),
                PromoterRegistrationBadge(
                    state: promoter.registered!
                        ? PromoterRegistrationState.registered
                        : PromoterRegistrationState.unregistered)
              ],
              if (getPromoterDateText(context) != null) ...[
                const SizedBox(height: 8),
                Text(getPromoterDateText(context)!,
                    style: themeData.textTheme.headlineLarge!.copyWith(
                        fontSize: 12,
                        color:
                            themeData.colorScheme.surfaceTint.withOpacity(0.6)),
                    maxLines: 1)
              ]
            ]),
      ),
    );
  }

  String? getPromoterDateText(BuildContext context) {
    if (promoter.expiresAt != null && promoter.registered == false) {
      final date =
          DateTimeFormatter().getStringFromDate(context, promoter.expiresAt!);
      return "Läuft am $date ab";
    } else if (promoter.createdAt != null && promoter.registered == true) {
      final date =
          DateTimeFormatter().getStringFromDate(context, promoter.createdAt!);
      return "Mitglied seit $date";
    } else {
      return null;
    }
  }

  Widget placeHolderImage(ResponsiveBreakpointsData responsiveValue) {
    return PlaceholderImage(
        imageSize: Size(responsiveValue.largerThan(MOBILE) ? 120 : 140,
            responsiveValue.largerThan(MOBILE) ? 120 : 140),
        hovered: false);
  }
}
