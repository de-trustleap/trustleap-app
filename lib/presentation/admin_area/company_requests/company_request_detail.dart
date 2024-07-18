import 'package:finanzbegleiter/presentation/admin_area/company_requests/company_requests_overview.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CompanyRequestDetail extends StatelessWidget {
  const CompanyRequestDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final CompanyRequestDetailsModel model =
        Modular.args.data as CompanyRequestDetailsModel;
    final themeData = Theme.of(context);
    return CenteredConstrainedWrapper(
        child: ListView(shrinkWrap: true, children: [
      CardContainer(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Anfrage",
            style: themeData.textTheme.headlineLarge!
                .copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Unternehmensbezeichnung:",
                style: themeData.textTheme.bodyMedium),
            const SizedBox(width: 16),
            Text(model.request.company?.name ?? "",
                style: themeData.textTheme.bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text("Branche:", style: themeData.textTheme.bodyMedium),
          const SizedBox(width: 8),
          Text(model.request.company?.industry ?? "",
              style: themeData.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold))
        ]),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text("Adresse:", style: themeData.textTheme.bodyMedium),
          const SizedBox(width: 8),
          Text(model.request.company?.address ?? "",
              style: themeData.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold))
        ]),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text("Postleitzahl:", style: themeData.textTheme.bodyMedium),
          const SizedBox(width: 8),
          Text(model.request.company?.postCode ?? "",
              style: themeData.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold))
        ]),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text("Ort:", style: themeData.textTheme.bodyMedium),
          const SizedBox(width: 8),
          Text(model.request.company?.place ?? "",
              style: themeData.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold))
        ]),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text("Telefonnummer:", style: themeData.textTheme.bodyMedium),
          const SizedBox(width: 8),
          Text(model.request.company?.phoneNumber ?? "",
              style: themeData.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold))
        ]),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text("Webseite:", style: themeData.textTheme.bodyMedium),
          const SizedBox(width: 8),
          Text(model.request.company?.websiteURL ?? "",
              style: themeData.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold))
        ]),
        const SizedBox(height: 40),
        Text("Nutzer",
            style: themeData.textTheme.headlineLarge!
                .copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Name:", style: themeData.textTheme.bodyMedium),
            const SizedBox(width: 8),
            Text("${model.user.firstName ?? ""} ${model.user.lastName ?? ""}",
                style: themeData.textTheme.bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text("E-Mail Adresse:", style: themeData.textTheme.bodyMedium),
          const SizedBox(width: 8),
          Text(model.user.email ?? "",
              style: themeData.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold))
        ]),
      ]))
    ]));
  }
} // TODO: Button zum Annehmen oder Ablehnen des Requests
