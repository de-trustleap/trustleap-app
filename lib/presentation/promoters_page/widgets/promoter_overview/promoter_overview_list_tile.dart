// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/presentation/promoters_page/promoter_helper.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoter_registration_badge.dart';
import 'package:flutter/material.dart';

class PromoterOverviewListTile extends StatelessWidget {
  final Promoter promoter;

  const PromoterOverviewListTile({
    Key? key,
    required this.promoter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Container(
        decoration: BoxDecoration(
            color: themeData.colorScheme.background,
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
                              style: themeData.textTheme.headlineLarge!
                                  .copyWith(fontSize: 14),
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis)),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(promoter.email ?? "",
                              style: themeData.textTheme.headlineLarge!
                                  .copyWith(
                                      fontSize: 12,
                                      color: themeData.colorScheme.surfaceTint
                                          .withOpacity(0.6)),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis))
                    ]),
                if (promoter.registered != null) ...[
                  const SizedBox(height: 8),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (promoter.registered == true) ... [
                          const PromoterRegistrationBadge(state: PromoterRegistrationState.registered),
                          const Spacer(flex: 3)
                        ]
                        else ... [
                          const PromoterRegistrationBadge(state: PromoterRegistrationState.unregistered),
                          const Spacer(flex: 10)
                        ],
                        Expanded(
                          flex: promoter.registered == true ? 4 : 15,
                            child: Text(
                                PromoterHelper().getPromoterDateText(context, promoter) ?? "",
                                style: themeData.textTheme.headlineLarge!
                                    .copyWith(
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
