import 'package:finanzbegleiter/domain/entities/company_request.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:flutter/material.dart';

class CompanyRequestOverviewListTile extends StatelessWidget {
  final CompanyRequest companyRequest;
  final CustomUser user;
  const CompanyRequestOverviewListTile(
      {super.key, required this.companyRequest, required this.user});

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
                            child: Text(companyRequest.company?.name ?? "",
                                style: themeData.textTheme.bodySmall,
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis)),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Text("von: Irgendein User",
                                style: themeData.textTheme.bodySmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis))
                      ])
                ])));
  }
}
