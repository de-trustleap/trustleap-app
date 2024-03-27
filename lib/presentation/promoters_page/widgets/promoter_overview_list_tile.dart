// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_registration_badge.dart';
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
          child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: FlexColumnWidth(40),
                1: FlexColumnWidth(40),
                2: FlexColumnWidth(20)
              },
              children: [
                TableRow(children: [
                  Text("${promoter.firstName ?? ""} ${promoter.lastName ?? ""}",
                      style: themeData.textTheme.headlineLarge!
                          .copyWith(fontSize: 14),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  Text(promoter.email ?? "",
                      style: themeData.textTheme.headlineLarge!.copyWith(
                          fontSize: 12,
                          color: themeData.colorScheme.surfaceTint
                              .withOpacity(0.6)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  if (promoter.registered != null) ...[
                    PromoterRegistrationBadge(
                        state: promoter.registered!
                            ? PromoterRegistrationState.registered
                            : PromoterRegistrationState.unregistered)
                  ],
                ])
              ]),
        ));
  }
}
