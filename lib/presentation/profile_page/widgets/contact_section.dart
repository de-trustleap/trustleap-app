import 'package:finanzbegleiter/application/profile/profile/profile_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/core/helpers/auth_validator.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/gender_picker.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ContactSection extends StatefulWidget {
  final CustomUser user;
  final Function changesSaved;

  const ContactSection(
      {required this.user, required this.changesSaved, super.key});
  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  final streetTextController = TextEditingController();
  final postcodeTextController = TextEditingController();
  final placeTextController = TextEditingController();
  Gender? selectedGender;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool showError = false;
  String errorMessage = "";
  bool validationHasError = false;
  String? genderValid;
  bool buttonDisabled = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        selectedGender = widget.user.gender;
        firstNameTextController.text = widget.user.firstName ?? "";
        lastNameTextController.text = widget.user.lastName ?? "";
        streetTextController.text = widget.user.address ?? "";
        postcodeTextController.text = widget.user.postCode ?? "";
        placeTextController.text = widget.user.place ?? "";
      });
    });
  }

  @override
  void dispose() {
    firstNameTextController.dispose();
    lastNameTextController.dispose();
    streetTextController.dispose();
    postcodeTextController.dispose();
    placeTextController.dispose();

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

  void submit(AuthValidator validator) {
    if (formKey.currentState!.validate() &&
        validator.validateGender(selectedGender) == null) {
      validationHasError = false;
      setState(() {
        genderValid = null;
      });
      Modular.get<ProfileCubit>().updateProfile(widget.user.copyWith(
          gender: selectedGender,
          firstName: firstNameTextController.text.trim(),
          lastName: lastNameTextController.text.trim(),
          address: streetTextController.text.trim(),
          postCode: postcodeTextController.text.trim(),
          place: placeTextController.text.trim()));
    } else {
      validationHasError = true;
      setState(() {
        genderValid = validator.validateGender(selectedGender);
      });
      Modular.get<ProfileCubit>().updateProfile(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileCubit = Modular.get<ProfileCubit>();
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    final validator = AuthValidator(localization: localization);
    const double textFieldSpacing = 20;

    return CardContainer(child: LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      return BlocConsumer<ProfileCubit, ProfileState>(
        bloc: profileCubit,
        listener: (context, state) {
          if (state is ProfileUpdateContactInformationFailureState) {
            errorMessage = DatabaseFailureMapper.mapFailureMessage(
                state.failure, localization);
            showError = true;
            setButtonStateToDisabled(false);
          } else if (state is ProfileUpdateContactInformationSuccessState) {
            widget.changesSaved();
            setButtonStateToDisabled(false);
          } else if (state is ProfileUpdateContactInformationLoadingState) {
            setButtonStateToDisabled(true);
          }
        },
        builder: (context, state) {
          return Form(
            key: formKey,
            autovalidateMode: (state is ProfileShowValidationState)
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(localization.profile_page_contact_section_title,
                    style: themeData.textTheme.headlineLarge!
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  GenderPicker(
                      width: maxWidth,
                      validate: genderValid,
                      initialValue: selectedGender,
                      onSelected: (gender) {
                        setState(() {
                          genderValid = validator.validateGender(gender);
                          selectedGender = gender;
                        });
                        resetError();
                      })
                ]),
                const SizedBox(height: 16),
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
                                    .profile_page_contact_section_form_firstname,
                                style: responsiveValue.isMobile
                                    ? themeData.textTheme.bodySmall
                                    : themeData.textTheme.bodyMedium),
                            const SizedBox(height: 4),
                            FormTextfield(
                                maxWidth: responsiveValue.isMobile
                                    ? maxWidth
                                    : maxWidth / 2 - textFieldSpacing / 2,
                                controller: firstNameTextController,
                                disabled: false,
                                placeholder: "",
                                onChanged: resetError,
                                onFieldSubmitted: (_) => submit(validator),
                                validator: validator.validateFirstName),
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
                                    .profile_page_contact_section_form_lastname,
                                style: responsiveValue.isMobile
                                    ? themeData.textTheme.bodySmall
                                    : themeData.textTheme.bodyMedium),
                            const SizedBox(height: 4),
                            FormTextfield(
                                maxWidth: responsiveValue.isMobile
                                    ? maxWidth
                                    : maxWidth / 2 - textFieldSpacing / 2,
                                controller: lastNameTextController,
                                disabled: false,
                                placeholder: "",
                                onChanged: resetError,
                                onFieldSubmitted: (_) => submit(validator),
                                validator: validator.validateLastName)
                          ]))
                    ]),
                const SizedBox(height: textFieldSpacing),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SelectableText(
                      localization.profile_page_contact_section_form_address,
                      style: responsiveValue.isMobile
                          ? themeData.textTheme.bodySmall
                          : themeData.textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  FormTextfield(
                      maxWidth: maxWidth,
                      controller: streetTextController,
                      disabled: false,
                      placeholder: "",
                      onChanged: resetError,
                      onFieldSubmitted: (_) => submit(validator))
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
                                    .profile_page_contact_section_form_postcode,
                                style: responsiveValue.isMobile
                                    ? themeData.textTheme.bodySmall
                                    : themeData.textTheme.bodyMedium),
                            const SizedBox(height: 4),
                            FormTextfield(
                                maxWidth: responsiveValue.isMobile
                                    ? maxWidth
                                    : maxWidth / 2 - textFieldSpacing / 2,
                                controller: postcodeTextController,
                                disabled: false,
                                placeholder: "",
                                onChanged: resetError,
                                onFieldSubmitted: (_) => submit(validator),
                                validator: validator.validatePostcode,
                                keyboardType: TextInputType.number)
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
                                    .profile_page_contact_section_form_place,
                                style: responsiveValue.isMobile
                                    ? themeData.textTheme.bodySmall
                                    : themeData.textTheme.bodyMedium),
                            const SizedBox(height: 4),
                            FormTextfield(
                                maxWidth: responsiveValue.isMobile
                                    ? maxWidth
                                    : maxWidth / 2 - textFieldSpacing / 2,
                                controller: placeTextController,
                                disabled: false,
                                placeholder: "",
                                onChanged: resetError,
                                onFieldSubmitted: (_) => submit(validator))
                          ]))
                    ]),
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
                            is ProfileUpdateContactInformationLoadingState,
                        onTap: () {
                          submit(validator);
                        })
                  ],
                ),
                if (errorMessage != "" &&
                    showError &&
                    state is ProfileUpdateContactInformationFailureState &&
                    !validationHasError) ...[
                  const SizedBox(height: 20),
                  FormErrorView(message: errorMessage)
                ]
              ],
            ),
          );
        },
      );
    }));
  }
}
