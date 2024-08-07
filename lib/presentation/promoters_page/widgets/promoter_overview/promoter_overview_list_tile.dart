// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/promoters_page/promoter_helper.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoter_registration_badge.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PromoterOverviewListTile extends StatelessWidget {
  final Promoter promoter;

  const PromoterOverviewListTile({
    super.key,
    required this.promoter,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return Container(
        decoration: BoxDecoration(
            color: themeData.colorScheme.surface,
            border: Border.all(color: Colors.transparent),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Text(
                              "${promoter.firstName ?? ""} ${promoter.lastName ?? ""}",
                              style: themeData.textTheme.bodySmall,
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis)),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(promoter.email ?? "",
                              style: themeData.textTheme.bodySmall!.copyWith(
                                  fontSize: 12,
                                  color: themeData.colorScheme.surfaceTint
                                      .withOpacity(0.6)),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis))
                    ]),
                if (promoter.registered != null) ...[
                  const SizedBox(height: 8),
                  Row(
                      mainAxisAlignment: responsiveValue.isMobile ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (promoter.registered == true) ...[
                          const PromoterRegistrationBadge(
                              state: PromoterRegistrationState.registered),
                          Spacer(flex: responsiveValue.isMobile ? 1 : 3)
                        ] else ...[
                          const PromoterRegistrationBadge(
                              state: PromoterRegistrationState.unregistered),
                            Spacer(flex: responsiveValue.isMobile ? 1 : 10)
                        ],
                        Expanded(
                            flex: responsiveValue.isMobile ? 0 : (promoter.registered == true ? 4 : 15),
                            child: Text(
                                PromoterHelper(localization: localization).getPromoterDateText(
                                        context, promoter) ??
                                    "",
                                style: themeData.textTheme.bodySmall!.copyWith(
                                    fontSize: 12,
                                    color: themeData.colorScheme.surfaceTint
                                        .withOpacity(0.6)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis))
                      ])
                ]
              ],
            )));
  }
}
