import 'package:finanzbegleiter/application/profile/company/company_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/company.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/company/company_validator.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CompanyRegistrationForm extends StatefulWidget {
  const CompanyRegistrationForm({super.key});

  @override
  State<CompanyRegistrationForm> createState() =>
      _CompanyRegistrationFormState();
}

class _CompanyRegistrationFormState extends State<CompanyRegistrationForm> {
  final nameTextController = TextEditingController();
  final industryTextController = TextEditingController();
  final websiteTextController = TextEditingController();
  final addressTextController = TextEditingController();
  final postCodeTextController = TextEditingController();
  final placeTextController = TextEditingController();
  final phoneNumberTextController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String currentUserID;

  bool showError = false;
  String errorMessage = "";
  bool validationHasError = false;
  bool buttonDisabled = false;

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
      BlocProvider.of<CompanyCubit>(context).registerCompany(Company(
          id: UniqueID(),
          name: nameTextController.text.trim(),
          industry: industryTextController.text.trim(),
          websiteURL: websiteTextController.text.trim(),
          address: addressTextController.text.trim(),
          postCode: postCodeTextController.text.trim(),
          place: placeTextController.text.trim(),
          phoneNumber: phoneNumberTextController.text.trim(),
          ownerID: currentUserID));
    } else {
      validationHasError = true;
      BlocProvider.of<CompanyCubit>(context).registerCompany(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    final validator = CompanyValidator(localization: localization);
    const double textFieldSpacing = 20;

    return BlocConsumer<CompanyCubit, CompanyState>(
      listener: (context, state) {
        if (state is CompanyRegisterFailureState) {
          errorMessage = DatabaseFailureMapper.mapFailureMessage(
              state.failure, localization);
          showError = true;
          setButtonStateToDisabled(false);
        } else if (state is CompanyRegisterLoadingState) {
          setButtonStateToDisabled(true);
        } else if (state is CompanyGetCurrentUserSuccessState) {
          currentUserID = state.user?.uid ?? "";
        } else if (state is CompanyRegisterSuccessState) {
          resetError();
          const params = "?registeredCompany=true";
          Modular.to
              .navigate(RoutePaths.homePath + RoutePaths.profilePath + params);
        }
      },
      builder: (context, state) {
        return CardContainer(
            child: LayoutBuilder(builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;

          return Form(
              key: formKey,
              autovalidateMode: (state is CompanyShowValidationState)
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(localization.company_registration_form_title,
                        style: themeData.textTheme.headlineLarge!
                            .copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      FormTextfield(
                          maxWidth: maxWidth,
                          controller: nameTextController,
                          disabled: false,
                          placeholder: localization
                              .company_registration_form_name_textfield_placeholder,
                          onChanged: resetError,
                          onFieldSubmitted: () => submit(validator),
                          validator: validator.validateName)
                    ]),
                    const SizedBox(height: textFieldSpacing),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      FormTextfield(
                          maxWidth: maxWidth,
                          controller: industryTextController,
                          disabled: false,
                          placeholder: localization
                              .company_registration_form_industry_textfield_placeholder,
                          onChanged: resetError,
                          onFieldSubmitted: () => submit(validator),
                          validator: validator.validateIndustry)
                    ]),
                    const SizedBox(height: textFieldSpacing),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      FormTextfield(
                          maxWidth: maxWidth,
                          controller: websiteTextController,
                          disabled: false,
                          placeholder: localization
                              .company_registration_form_website_textfield_placeholder,
                          onChanged: resetError,
                          onFieldSubmitted: () => submit(validator))
                    ]),
                    const SizedBox(height: textFieldSpacing),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      FormTextfield(
                          maxWidth: maxWidth,
                          controller: addressTextController,
                          disabled: false,
                          placeholder: localization
                              .company_registration_form_address_textfield_placeholder,
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
                              child: FormTextfield(
                                  maxWidth: responsiveValue.isMobile
                                      ? maxWidth
                                      : maxWidth / 2 - textFieldSpacing / 2,
                                  controller: postCodeTextController,
                                  disabled: false,
                                  placeholder: localization
                                      .company_registration_form_postcode_textfield_placeholder,
                                  onChanged: resetError,
                                  onFieldSubmitted: () => submit(validator),
                                  validator: validator.validatePostCode)),
                          const ResponsiveRowColumnItem(
                              child: SizedBox(
                                  height: textFieldSpacing,
                                  width: textFieldSpacing)),
                          ResponsiveRowColumnItem(
                              child: FormTextfield(
                                  maxWidth: responsiveValue.isMobile
                                      ? maxWidth
                                      : maxWidth / 2 - textFieldSpacing / 2,
                                  controller: placeTextController,
                                  disabled: false,
                                  placeholder: localization
                                      .company_registration_form_place_textfield_placeholder,
                                  onChanged: resetError,
                                  onFieldSubmitted: () => submit(validator),
                                  validator: validator.validatePlace))
                        ]),
                    const SizedBox(height: textFieldSpacing),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      FormTextfield(
                          maxWidth: maxWidth,
                          controller: phoneNumberTextController,
                          disabled: false,
                          placeholder: localization
                              .company_registration_form_phone_textfield_placeholder,
                          onChanged: resetError,
                          onFieldSubmitted: () => submit(validator))
                    ]),
                    const SizedBox(height: textFieldSpacing * 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        PrimaryButton(
                            title: localization
                                .company_registration_form_register_button_title,
                            width: responsiveValue.isMobile
                                ? maxWidth - textFieldSpacing
                                : maxWidth / 2 - textFieldSpacing,
                            disabled: buttonDisabled,
                            isLoading: state is CompanyRegisterLoadingState,
                            onTap: () {
                              submit(validator);
                            })
                      ],
                    ),
                    if (errorMessage != "" &&
                        showError &&
                        state is CompanyRegisterFailureState &&
                        !validationHasError) ...[
                      const SizedBox(height: 20),
                      FormErrorView(message: errorMessage)
                    ]
                  ]));
        }));
      },
    );
  }
}
