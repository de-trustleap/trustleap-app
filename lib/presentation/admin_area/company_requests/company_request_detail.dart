import 'package:finanzbegleiter/application/company_request/company_request/company_request_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/admin_area/company_requests/company_requests_overview.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/secondary_button.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CompanyRequestDetail extends StatelessWidget {
  const CompanyRequestDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final CompanyRequestDetailsModel model =
        Modular.args.data as CompanyRequestDetailsModel;
    final themeData = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return BlocConsumer<CompanyRequestCubit, CompanyRequestState>(
      listener: (context, state) {
        if (state is ProcessCompanyRequestSuccessState) {
          Modular.to.navigate(RoutePaths.adminPath + RoutePaths.companyRequestsPath);
        }
      },
      builder: (context, state) {
        return ListView(shrinkWrap: true, children: [
          CardContainer(child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      Text("Postleitzahl:",
                          style: themeData.textTheme.bodyMedium),
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
                      Text("Telefonnummer:",
                          style: themeData.textTheme.bodyMedium),
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
                        Text(
                            "${model.user.firstName ?? ""} ${model.user.lastName ?? ""}",
                            style: themeData.textTheme.bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Text("E-Mail Adresse:",
                          style: themeData.textTheme.bodyMedium),
                      const SizedBox(width: 8),
                      Text(model.user.email ?? "",
                          style: themeData.textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold))
                    ]),
                    const SizedBox(height: 40),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Spacer(),
                      SecondaryButton(
                          title: "Anfrage ablehnen",
                          width: maxWidth / 3,
                          onTap: () {
                            BlocProvider.of<CompanyRequestCubit>(context)
                                .processCompanyRequest(model.request.id.value,
                                    model.user.id.value, false);
                          }),
                      const Spacer(),
                      PrimaryButton(
                          title: "Anfrage annehmen",
                          width: maxWidth / 3,
                          onTap: () {
                            BlocProvider.of<CompanyRequestCubit>(context)
                                .processCompanyRequest(model.request.id.value,
                                    model.user.id.value, true);
                          }),
                      const Spacer()
                    ]),
                    if (state is CompanyRequestLoadingState) ...[
                      const SizedBox(height: 40),
                      const LoadingIndicator()
                    ] else if (state is ProcessCompanyRequestFailureState) ...[
                      const SizedBox(height: 40),
                      FormErrorView(
                          message: DatabaseFailureMapper.mapFailureMessage(
                              state.failure, localizations))
                    ]
                  ]);
            },
          ))
        ]);
      },
    );
  }
}