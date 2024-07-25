import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/admin_area/company_requests/company_requests_overview.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CompanyRequestOverviewListTile extends StatelessWidget {
  final CompanyRequestDetailsModel model;
  const CompanyRequestOverviewListTile({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return InkWell(
      onTap: () {
        Modular.to.pushNamed(
            RoutePaths.adminPath + RoutePaths.companyRequestDetails,
            arguments: model);
      },
      child: Container(
          decoration: BoxDecoration(
              color: themeData.colorScheme.background,
              border: Border.all(color: Colors.transparent),
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Text(model.request.company?.name ?? "",
                                  style: themeData.textTheme.bodySmall,
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis)),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(
                                  "${localizations.admin_company_request_overview_from_user}${model.user.firstName} ${model.user.lastName}",
                                  style: themeData.textTheme.bodySmall,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis))
                        ])
                  ]))),
    );
  }
}
