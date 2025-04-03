// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/permissions/permission_cubit.dart';
import 'package:finanzbegleiter/application/profile/company/company_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/core/helpers/downloader.dart';
import 'package:finanzbegleiter/domain/entities/company.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/infrastructure/extensions/modular_watch_extension.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/clickable_link.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/company/company_validator.dart';
import 'package:flutter/material.dart';
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
  bool avvChecked = false;
  bool showAVVCheckbox = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool showError = false;
  String errorMessage = "";
  bool validationHasError = false;
  bool buttonDisabled = false;
  bool textFieldsDisabled = true;

  @override
  void initState() {
    super.initState();
    showAVVCheckbox = widget.company.avv?.approvedAt == null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        nameTextController.text = widget.company.name ?? "";
        industryTextController.text = widget.company.industry ?? "";
        websiteTextController.text = widget.company.websiteURL ?? "";
        addressTextController.text = widget.company.address ?? "";
        postCodeTextController.text = widget.company.postCode ?? "";
        placeTextController.text = widget.company.place ?? "";
        phoneNumberTextController.text = widget.company.phoneNumber ?? "";
        final permissions = (context.watchModular<PermissionCubit>().state
                as PermissionSuccessState)
            .permissions;
        if (permissions.hasEditCompanyPermission()) {
          setState(() {
            textFieldsDisabled = false;
          });
        } else {
          setState(() {
            textFieldsDisabled = true;
          });
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    if (showAVVCheckbox && !avvChecked) {
      setButtonStateToDisabled(true);
    }
    super.didChangeDependencies();
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
      showAVVCheckbox = true;
    });
  }

  void submit(CompanyValidator validator) {
    if (formKey.currentState!.validate()) {
      validationHasError = false;
      BlocProvider.of<CompanyCubit>(context).updateCompany(
          widget.company.copyWith(
              name: nameTextController.text.trim(),
              industry: industryTextController.text.trim(),
              websiteURL: websiteTextController.text.trim(),
              address: addressTextController.text.trim(),
              postCode: postCodeTextController.text.trim(),
              place: placeTextController.text.trim(),
              phoneNumber: phoneNumberTextController.text.trim()),
          avvChecked);
    } else {
      validationHasError = true;
      BlocProvider.of<CompanyCubit>(context).updateCompany(null, false);
    }
  }

  void submitPDFRequest(CompanyValidator validator) {
    if (formKey.currentState!.validate()) {
      validationHasError = false;
      BlocProvider.of<CompanyCubit>(context).getPDFDownloadURL(widget.company
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
      BlocProvider.of<CompanyCubit>(context).getPDFDownloadURL(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    final validator = CompanyValidator(localization: localization);
    final permissions =
        (context.watch<PermissionCubit>().state as PermissionSuccessState)
            .permissions;
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
          } else if (state is CompanyGetAVVPDFFailureState) {
            errorMessage = DatabaseFailureMapper.mapFailureMessage(
                state.failure, localization);
            showError = true;
            setButtonStateToDisabled(false);
          } else if (state is CompanyUpdateContactInformationSuccessState) {
            widget.changesSaved();
            setButtonStateToDisabled(false);
            setState(() {
              showAVVCheckbox = false;
            });
          } else if (state is CompanyUpdateContactInformationLoadingState) {
            setButtonStateToDisabled(true);
          } else if (state is CompanyGetAVVPDFLoadingState) {
            setButtonStateToDisabled(true);
          } else if (state is CompanyGetAVVPDFSuccessState) {
            Downloader().showFileInNewTab(state.downloadURL);
          }
          // TODO: Localization
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
                    SelectableText(
                        localization.profile_company_contact_section_title,
                        style: themeData.textTheme.headlineLarge!
                            .copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                              localization.profile_company_contact_section_name,
                              style: responsiveValue.isMobile
                                  ? themeData.textTheme.bodySmall
                                  : themeData.textTheme.bodyMedium),
                          const SizedBox(height: 4),
                          FormTextfield(
                              maxWidth: maxWidth,
                              controller: nameTextController,
                              disabled: textFieldsDisabled,
                              placeholder: "",
                              onChanged: resetError,
                              onFieldSubmitted: () => submit(validator),
                              validator: validator.validateName)
                        ]),
                    const SizedBox(height: textFieldSpacing),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                              localization
                                  .profile_company_contact_section_industry,
                              style: responsiveValue.isMobile
                                  ? themeData.textTheme.bodySmall
                                  : themeData.textTheme.bodyMedium),
                          const SizedBox(height: 4),
                          FormTextfield(
                              maxWidth: maxWidth,
                              controller: industryTextController,
                              disabled: textFieldsDisabled,
                              placeholder: "",
                              onChanged: resetError,
                              onFieldSubmitted: () => submit(validator),
                              validator: validator.validateIndustry)
                        ]),
                    const SizedBox(height: textFieldSpacing),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                              localization
                                  .profile_company_contact_section_website,
                              style: responsiveValue.isMobile
                                  ? themeData.textTheme.bodySmall
                                  : themeData.textTheme.bodyMedium),
                          const SizedBox(height: 4),
                          FormTextfield(
                              maxWidth: maxWidth,
                              controller: websiteTextController,
                              disabled: textFieldsDisabled,
                              placeholder: "",
                              onChanged: resetError,
                              onFieldSubmitted: () => submit(validator))
                        ]),
                    const SizedBox(height: textFieldSpacing),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                              localization
                                  .profile_company_contact_section_address,
                              style: responsiveValue.isMobile
                                  ? themeData.textTheme.bodySmall
                                  : themeData.textTheme.bodyMedium),
                          const SizedBox(height: 4),
                          FormTextfield(
                              maxWidth: maxWidth,
                              controller: addressTextController,
                              disabled: textFieldsDisabled,
                              placeholder: "",
                              onChanged: resetError,
                              onFieldSubmitted: () => submit(validator),
                              validator: validator.validateAddress)
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
                                SelectableText(
                                    localization
                                        .profile_company_contact_section_postcode,
                                    style: responsiveValue.isMobile
                                        ? themeData.textTheme.bodySmall
                                        : themeData.textTheme.bodyMedium),
                                const SizedBox(height: 4),
                                FormTextfield(
                                    maxWidth: responsiveValue.isMobile
                                        ? maxWidth
                                        : maxWidth / 2 - textFieldSpacing / 2,
                                    controller: postCodeTextController,
                                    disabled: textFieldsDisabled,
                                    placeholder: "",
                                    onChanged: resetError,
                                    onFieldSubmitted: () => submit(validator),
                                    validator: validator.validatePostCode)
                              ])),
                          const ResponsiveRowColumnItem(
                              child: SizedBox(
                                  height: textFieldSpacing,
                                  width: textFieldSpacing)),
                          ResponsiveRowColumnItem(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                SelectableText(
                                    localization
                                        .profile_company_contact_section_place,
                                    style: responsiveValue.isMobile
                                        ? themeData.textTheme.bodySmall
                                        : themeData.textTheme.bodyMedium),
                                const SizedBox(height: 4),
                                FormTextfield(
                                    maxWidth: responsiveValue.isMobile
                                        ? maxWidth
                                        : maxWidth / 2 - textFieldSpacing / 2,
                                    controller: placeTextController,
                                    disabled: textFieldsDisabled,
                                    placeholder: "",
                                    onChanged: resetError,
                                    onFieldSubmitted: () => submit(validator),
                                    validator: validator.validatePlace)
                              ]))
                        ]),
                    const SizedBox(height: textFieldSpacing),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                              localization
                                  .profile_company_contact_section_phone,
                              style: responsiveValue.isMobile
                                  ? themeData.textTheme.bodySmall
                                  : themeData.textTheme.bodyMedium),
                          const SizedBox(height: 4),
                          FormTextfield(
                              maxWidth: maxWidth,
                              controller: phoneNumberTextController,
                              disabled: textFieldsDisabled,
                              placeholder: "",
                              onChanged: resetError,
                              onFieldSubmitted: () => submit(validator))
                        ]),
                    const SizedBox(height: textFieldSpacing),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      if (showAVVCheckbox) ...[
                        Checkbox(
                            value: avvChecked,
                            onChanged: (checked) {
                              if (checked == true) {
                                setButtonStateToDisabled(false);
                              } else {
                                setButtonStateToDisabled(true);
                              }
                              setState(() {
                                avvChecked = checked ?? false;
                              });
                            }),
                        const SizedBox(width: 8),
                        Text(
                            localization
                                .profile_company_contact_section_avv_checkbox_text,
                            style: themeData.textTheme.bodyMedium),
                        const SizedBox(width: 4),
                        ClickableLink(
                            title: localization
                                .profile_company_contact_section_avv_link,
                            onTap: () {
                              submitPDFRequest(validator);
                            }),
                        const SizedBox(width: 4),
                        Text(
                            localization
                                .profile_company_contact_section_avv_checkbox_text_part2,
                            style: themeData.textTheme.bodyMedium)
                      ] else ...[
                        ClickableLink(
                            title: localization
                                .profile_company_contact_section_avv_link,
                            onTap: () {
                              submitPDFRequest(validator);
                            }),
                        const SizedBox(width: 4),
                        Text(
                            localization
                                .profile_company_contact_section_avv_already_approved,
                            style: themeData.textTheme.bodyMedium)
                      ]
                    ]),
                    if (state is CompanyGetAVVPDFLoadingState) ...[
                      const SizedBox(height: textFieldSpacing),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const LoadingIndicator(size: 24),
                            const SizedBox(width: 8),
                            Text(
                                localization
                                    .profile_company_contact_section_avv_generating,
                                style: themeData.textTheme.bodyMedium)
                          ])
                    ],
                    if (permissions.hasEditCompanyPermission()) ...[
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
                              isLoading: state
                                  is CompanyUpdateContactInformationLoadingState,
                              onTap: () {
                                submit(validator);
                              })
                        ],
                      ),
                    ],
                    if (errorMessage != "" &&
                        showError &&
                        (state is CompanyUpdateContactInformationFailureState ||
                            state is CompanyGetAVVPDFFailureState) &&
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
