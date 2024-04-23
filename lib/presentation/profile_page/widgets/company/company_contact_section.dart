// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/profile/company/company_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/company/company_validator.dart';
import 'package:flutter/material.dart';

import 'package:finanzbegleiter/domain/entities/company.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CompanyContactSection extends StatefulWidget {
  final CustomUser user;
  final Company company;
  final Function changesSaved;

  const CompanyContactSection({
    super.key,
    required this.user,
    required this.company,
    required this.changesSaved,
  });

  @override
  State<CompanyContactSection> createState() => _CompanyContactSectionState();
}

class _CompanyContactSectionState extends State<CompanyContactSection> {
  final nameTextController = TextEditingController();
  final industryTextController = TextEditingController();
  final websiteTextController = TextEditingController();
  final addressTextController = TextEditingController();
  final postCodeTextController = TextEditingController();
  final placeTextController = TextEditingController();
  final phoneNumberTextController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool showError = false;
  String errorMessage = "";
  bool validationHasError = false;
  bool buttonDisabled = false;
  bool textFieldsDisabled = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        nameTextController.text = widget.company.name ?? "";
        industryTextController.text = widget.company.industry ?? "";
        websiteTextController.text = widget.company.websiteURL ?? "";
        addressTextController.text = widget.company.address ?? "";
        postCodeTextController.text = widget.company.postCode ?? "";
        placeTextController.text = widget.company.place ?? "";
        phoneNumberTextController.text = widget.company.phoneNumber ?? "";
        if (widget.user.role == Role.company) {
          textFieldsDisabled = false;
        }
      });
    });
  }

  @override
  void dispose() {
    nameTextController.dispose();
    industryTextController.dispose();
    websiteTextController.dispose();
    addressTextController.dispose();
    postCodeTextController.dispose();
    placeTextController.dispose();
    phoneNumberTextController.dispose();

    super.dispose();
  }

  void setButtonStateToDisabled(bool disabled) {
    setState(() {
      buttonDisabled = disabled;
    });
  }

  void resetError() {
    setState(() {
      showError = false;
      errorMessage = "";
    });
  }

  void submit(CompanyValidator validator) {
    if (formKey.currentState!.validate()) {
      validationHasError = false;
      BlocProvider.of<CompanyCubit>(context).updateCompany(widget.company
          .copyWith(
              name: nameTextController.text.trim(),
              industry: industryTextController.text.trim(),
              websiteURL: websiteTextController.text.trim(),
              address: addressTextController.text.trim(),
              postCode: postCodeTextController.text.trim(),
              place: placeTextController.text.trim(),
              phoneNumber: phoneNumberTextController.text.trim()));
    } else {
      validationHasError = true;
      BlocProvider.of<CompanyCubit>(context).updateCompany(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    final validator = CompanyValidator(localization: localization);
    const double textFieldSpacing = 20;

    return CardContainer(child: LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      return BlocConsumer<CompanyCubit, CompanyState>(
        listener: (context, state) {
          if (state is CompanyUpdateContactInformationFailureState) {
            errorMessage = DatabaseFailureMapper.mapFailureMessage(
                state.failure, localization);
            showError = true;
            setButtonStateToDisabled(false);
          } else if (state is CompanyUpdateContactInformationSuccessState) {
            widget.changesSaved();
            setButtonStateToDisabled(false);
          } else if (state is CompanyUpdateContactInformationLoadingState) {
            setButtonStateToDisabled(true);
          }
        },
        builder: (context, state) {
          return Form(
              key: formKey,
              autovalidateMode: (state is CompanyShowValidationState)
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Unternehmensinformationen",
                        style: themeData.textTheme.headlineLarge!
                            .copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Unternehmensbezeichnung",
                              style: responsiveValue.isMobile
                                  ? themeData.textTheme.bodySmall
                                  : themeData.textTheme.bodyMedium),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: maxWidth,
                            child: TextFormField(
                              controller: nameTextController,
                              onFieldSubmitted: (_) => submit(validator),
                              readOnly: textFieldsDisabled ? true : false,
                              onChanged: (_) {
                                resetError();
                              },
                              validator: validator.validateName,
                              style: responsiveValue.isMobile
                                  ? themeData.textTheme.bodySmall
                                  : themeData.textTheme.bodyMedium,
                              decoration: InputDecoration(
                                  labelText: "",
                                  hoverColor: Colors.transparent,
                                  filled: textFieldsDisabled ? true : false,
                                  fillColor: themeData.colorScheme.background),
                            ),
                          ),
                        ]),
                    const SizedBox(height: textFieldSpacing),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Branche",
                              style: responsiveValue.isMobile
                                  ? themeData.textTheme.bodySmall
                                  : themeData.textTheme.bodyMedium),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: maxWidth,
                            child: TextFormField(
                              controller: industryTextController,
                              onFieldSubmitted: (_) => submit(validator),
                              readOnly: textFieldsDisabled ? true : false,
                              onChanged: (_) {
                                resetError();
                              },
                              validator: validator.validateIndustry,
                              style: responsiveValue.isMobile
                                  ? themeData.textTheme.bodySmall
                                  : themeData.textTheme.bodyMedium,
                              decoration: InputDecoration(
                                  labelText: "",
                                  hoverColor: Colors.transparent,
                                  filled: textFieldsDisabled ? true : false,
                                  fillColor: themeData.colorScheme.background),
                            ),
                          ),
                        ]),
                    const SizedBox(height: textFieldSpacing),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Webseite",
                              style: responsiveValue.isMobile
                                  ? themeData.textTheme.bodySmall
                                  : themeData.textTheme.bodyMedium),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: maxWidth,
                            child: TextFormField(
                              controller: websiteTextController,
                              onFieldSubmitted: (_) => submit(validator),
                              readOnly: textFieldsDisabled ? true : false,
                              onChanged: (_) {
                                resetError();
                              },
                              style: responsiveValue.isMobile
                                  ? themeData.textTheme.bodySmall
                                  : themeData.textTheme.bodyMedium,
                              decoration: InputDecoration(
                                  labelText: "",
                                  hoverColor: Colors.transparent,
                                  filled: textFieldsDisabled ? true : false,
                                  fillColor: themeData.colorScheme.background),
                            ),
                          ),
                        ]),
                    const SizedBox(height: textFieldSpacing),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Straße und Hausnummer",
                              style: responsiveValue.isMobile
                                  ? themeData.textTheme.bodySmall
                                  : themeData.textTheme.bodyMedium),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: maxWidth,
                            child: TextFormField(
                              controller: addressTextController,
                              onFieldSubmitted: (_) => submit(validator),
                              readOnly: textFieldsDisabled ? true : false,
                              onChanged: (_) {
                                resetError();
                              },
                              style: responsiveValue.isMobile
                                  ? themeData.textTheme.bodySmall
                                  : themeData.textTheme.bodyMedium,
                              decoration: InputDecoration(
                                  labelText: "",
                                  hoverColor: Colors.transparent,
                                  filled: textFieldsDisabled ? true : false,
                                  fillColor: themeData.colorScheme.background),
                            ),
                          ),
                        ]),
                    const SizedBox(height: textFieldSpacing),
                    ResponsiveRowColumn(
                        columnMainAxisSize: MainAxisSize.min,
                        layout: responsiveValue.isMobile
                            ? ResponsiveRowColumnType.COLUMN
                            : ResponsiveRowColumnType.ROW,
                        children: [
                          ResponsiveRowColumnItem(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text("PLZ",
                                    style: responsiveValue.isMobile
                                        ? themeData.textTheme.bodySmall
                                        : themeData.textTheme.bodyMedium),
                                const SizedBox(height: 4),
                                SizedBox(
                                  width: responsiveValue.isMobile
                                      ? maxWidth
                                      : maxWidth / 2,
                                  child: TextFormField(
                                    controller: postCodeTextController,
                                    onFieldSubmitted: (_) => submit(validator),
                                    readOnly: textFieldsDisabled ? true : false,
                                    onChanged: (_) {
                                      resetError();
                                    },
                                    style: responsiveValue.isMobile
                                        ? themeData.textTheme.bodySmall
                                        : themeData.textTheme.bodyMedium,
                                    decoration: InputDecoration(
                                        labelText: "",
                                        hoverColor: Colors.transparent,
                                        filled:
                                            textFieldsDisabled ? true : false,
                                        fillColor:
                                            themeData.colorScheme.background),
                                  ),
                                ),
                              ])),
                          const ResponsiveRowColumnItem(
                              child: SizedBox(
                                  height: textFieldSpacing,
                                  width: textFieldSpacing)),
                          ResponsiveRowColumnItem(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text("Ort",
                                    style: responsiveValue.isMobile
                                        ? themeData.textTheme.bodySmall
                                        : themeData.textTheme.bodyMedium),
                                const SizedBox(height: 4),
                                SizedBox(
                                  width: responsiveValue.isMobile
                                      ? maxWidth
                                      : maxWidth / 2 - textFieldSpacing,
                                  child: TextFormField(
                                    controller: placeTextController,
                                    onFieldSubmitted: (_) => submit(validator),
                                    readOnly: textFieldsDisabled ? true : false,
                                    onChanged: (_) {
                                      resetError();
                                    },
                                    style: responsiveValue.isMobile
                                        ? themeData.textTheme.bodySmall
                                        : themeData.textTheme.bodyMedium,
                                    decoration: InputDecoration(
                                        labelText: "",
                                        hoverColor: Colors.transparent,
                                        filled:
                                            textFieldsDisabled ? true : false,
                                        fillColor:
                                            themeData.colorScheme.background),
                                  ),
                                ),
                              ]))
                        ]),
                    const SizedBox(height: textFieldSpacing),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Telefonnummer",
                              style: responsiveValue.isMobile
                                  ? themeData.textTheme.bodySmall
                                  : themeData.textTheme.bodyMedium),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: maxWidth,
                            child: TextFormField(
                              controller: phoneNumberTextController,
                              onFieldSubmitted: (_) => submit(validator),
                              readOnly: textFieldsDisabled ? true : false,
                              onChanged: (_) {
                                resetError();
                              },
                              validator: validator.validatePhoneNumber,
                              style: responsiveValue.isMobile
                                  ? themeData.textTheme.bodySmall
                                  : themeData.textTheme.bodyMedium,
                              decoration: InputDecoration(
                                  labelText: "",
                                  hoverColor: Colors.transparent,
                                  filled: textFieldsDisabled ? true : false,
                                  fillColor: themeData.colorScheme.background),
                            ),
                          ),
                        ]),
                    if (widget.user.role == Role.company) ...[
                      const SizedBox(height: textFieldSpacing * 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          PrimaryButton(
                              title: localization
                                  .profile_page_contact_section_form_save_button_title,
                              width: responsiveValue.isMobile
                                  ? maxWidth - textFieldSpacing
                                  : maxWidth / 2 - textFieldSpacing,
                              disabled: buttonDisabled,
                              onTap: () {
                                submit(validator);
                              })
                        ],
                      ),
                    ],
                    if (state
                        is CompanyUpdateContactInformationLoadingState) ...[
                      const SizedBox(height: 80),
                      const LoadingIndicator()
                    ],
                    if (errorMessage != "" &&
                        showError &&
                        state is CompanyUpdateContactInformationFailureState &&
                        !validationHasError) ...[
                      const SizedBox(height: 20),
                      FormErrorView(message: errorMessage)
                    ]
                  ]));
        },
      );
    }));
  }
}
