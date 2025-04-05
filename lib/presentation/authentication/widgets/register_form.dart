import 'dart:math';

import 'package:finanzbegleiter/application/authentication/auth/auth_cubit.dart';
import 'package:finanzbegleiter/application/authentication/signIn/sign_in_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/failures/auth_failure_mapper.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/core/failures/failure_mapper.dart';
import 'package:finanzbegleiter/core/helpers/auth_validator.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/clickable_link.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/gender_picker.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RegisterForm extends StatefulWidget {
  final String? registrationCode;
  const RegisterForm({super.key, this.registrationCode});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final passwordRepeatTextController = TextEditingController();
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  final birthDateTextController = TextEditingController();
  final streetAndNumberTextController = TextEditingController();
  final plzTextController = TextEditingController();
  final placeTextController = TextEditingController();
  final codeTextController = TextEditingController();
  var selectedGender = Gender.none;
  var privacyPolicyChecked = false;
  var termsAndConditionsChecked = false;

  bool buttonDisabled = false;
  bool showError = false;
  String errorMessage = "";
  bool validationHasError = false;
  String? genderValid;

  @override
  void initState() {
    super.initState();
    codeTextController.text = widget.registrationCode ?? "";
  }

  @override
  void didChangeDependencies() {
    if (!privacyPolicyChecked || !termsAndConditionsChecked) {
      setButtonToDisabled(true);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    passwordRepeatTextController.dispose();
    firstNameTextController.dispose();
    lastNameTextController.dispose();
    birthDateTextController.dispose();
    streetAndNumberTextController.dispose();
    plzTextController.dispose();
    placeTextController.dispose();
    codeTextController.dispose();

    super.dispose();
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
      BlocProvider.of<SignInCubit>(context).checkForValidRegistrationCode(
          emailTextController.text.trim(), codeTextController.text.trim());
    } else {
      validationHasError = true;
      setState(() {
        genderValid = validator.validateGender(selectedGender);
      });
      BlocProvider.of<SignInCubit>(context)
          .checkForValidRegistrationCode(null, null);
    }
  }

  void setButtonToDisabled(bool disabled) {
    setState(() {
      buttonDisabled = disabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final validator = AuthValidator(localization: localization);
    const double textFieldSpacing = 20;
    const double maxViewWidth = 500;
    const double listPadding = 20;

    /// this function handles the responsive layout.
    /// [fieldCount] contains the number of fields that are max in the specific row.
    /// [shouldWrapToNextLine] defines if the fieldCount > 1 wraps to the next line on mobile.
    double getResponsiveWidth(int fieldCount,
        {bool shouldWrapToNextLine = true}) {
      double mobileWidth =
          max(0, (responsiveValue.screenWidth - listPadding * 2));
      if (fieldCount == 1) {
        return max(
            0, responsiveValue.largerThan(MOBILE) ? maxViewWidth : mobileWidth);
      } else if (fieldCount == 2) {
        if (shouldWrapToNextLine) {
          return max(
              0,
              responsiveValue.largerThan(MOBILE)
                  ? (maxViewWidth / 2 - listPadding / 2)
                  : mobileWidth);
        } else {
          return max(
              0,
              responsiveValue.largerThan(MOBILE)
                  ? (maxViewWidth / 2 - listPadding / 2)
                  : (mobileWidth / 2 - listPadding / 2));
        }
      } else {
        return 0;
      }
    }

    return BlocConsumer<SignInCubit, SignInState>(listener: (context, state) {
      if (state is RegisterFailureState) {
        errorMessage =
            FailureMapper.mapFailureMessage(state.failure, localization);
        showError = true;
        setButtonToDisabled(false);
      } else if (state is RegisterSuccessState) {
        showError = false;
        BlocProvider.of<SignInCubit>(context).loginWithEmailAndPassword(
            emailTextController.text.trim(), passwordTextController.text);
      } else if (state is SignInCheckCodeFailureState) {
        errorMessage = DatabaseFailureMapper.mapFailureMessage(
            state.failure, localization);
        showError = true;
        setButtonToDisabled(false);
      } else if (state is SignInCheckCodeNotValidFailureState) {
        errorMessage = localization.register_invalid_code_error;
        showError = true;
        setButtonToDisabled(false);
      } else if (state is SignInCheckCodeSuccessState) {
        BlocProvider.of<SignInCubit>(context).registerAndCreateUser(
            emailTextController.text.trim(),
            passwordTextController.text,
            CustomUser(
                id: UniqueID.fromUniqueString("1"),
                gender: selectedGender,
                firstName: firstNameTextController.text.trim(),
                lastName: lastNameTextController.text.trim(),
                birthDate: birthDateTextController.text.trim(),
                address: streetAndNumberTextController.text.trim(),
                postCode: plzTextController.text.trim(),
                place: placeTextController.text.trim(),
                email: emailTextController.text.trim()),
            privacyPolicyChecked,
            termsAndConditionsChecked);
      } else if (state is SignInSuccessState) {
        showError = false;
        setButtonToDisabled(false);
        BlocProvider.of<AuthCubit>(context).checkForAuthState();
      } else if (state is SignInFailureState) {
        errorMessage =
            AuthFailureMapper.mapFailureMessage(state.failure, localization);
        showError = true;
        setButtonToDisabled(false);
      } else if (state is SignInLoadingState) {
        setButtonToDisabled(true);
      }
    }, builder: (context, state) {
      return Form(
          key: formKey,
          autovalidateMode: (state is SignInShowValidationState)
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: listPadding),
              children: [
                SizedBox(height: responsiveValue.isMobile ? 40 : 80),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    width: getResponsiveWidth(1),
                    child: SelectableText(localization.register_title,
                        style: themeData.textTheme.headlineLarge!.copyWith(
                            fontSize: responsiveValue.isMobile ? 20 : 50,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4)),
                  ),
                ]),
                const SizedBox(height: textFieldSpacing),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    width: getResponsiveWidth(1),
                    child: SelectableText(localization.register_subtitle,
                        style: themeData.textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w500, letterSpacing: 4)),
                  ),
                ]),
                SizedBox(height: responsiveValue.isMobile ? 40 : 80),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  GenderPicker(
                      width: getResponsiveWidth(1),
                      validate: genderValid,
                      onSelected: (gender) {
                        setState(() {
                          genderValid = validator.validateGender(gender);
                          selectedGender = gender;
                        });
                        resetError();
                      })
                ]),
                const SizedBox(height: textFieldSpacing),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    width: getResponsiveWidth(1),
                    child: ResponsiveRowColumn(
                      layout: responsiveValue.largerThan(MOBILE)
                          ? ResponsiveRowColumnType.ROW
                          : ResponsiveRowColumnType.COLUMN,
                      children: [
                        ResponsiveRowColumnItem(
                            child: FormTextfield(
                                controller: firstNameTextController,
                                maxWidth: getResponsiveWidth(2),
                                disabled: false,
                                placeholder: localization.register_firstname,
                                onChanged: resetError,
                                onFieldSubmitted: () => submit(validator),
                                validator: validator.validateFirstName)),
                        const ResponsiveRowColumnItem(
                            child: SizedBox(
                                height: textFieldSpacing,
                                width: textFieldSpacing)),
                        ResponsiveRowColumnItem(
                            child: FormTextfield(
                                controller: lastNameTextController,
                                maxWidth: getResponsiveWidth(2),
                                disabled: false,
                                placeholder: localization.register_lastname,
                                onChanged: resetError,
                                onFieldSubmitted: () => submit(validator),
                                validator: validator.validateLastName))
                      ],
                    ),
                  ),
                ]),
                const SizedBox(height: textFieldSpacing),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  FormTextfield(
                      maxWidth: getResponsiveWidth(1),
                      controller: birthDateTextController,
                      disabled: false,
                      placeholder: localization.register_birthdate,
                      onChanged: resetError,
                      onFieldSubmitted: () => submit(validator),
                      validator: validator.validateBirthDate,
                      prefixIcon: Icons.calendar_today_rounded,
                      keyboardType: TextInputType.datetime,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now());
                        if (pickedDate != null) {
                          setState(() {
                            birthDateTextController.text =
                                DateFormat("dd.MM.yyyy").format(pickedDate);
                          });
                        }
                      })
                ]),
                const SizedBox(height: textFieldSpacing),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  FormTextfield(
                      maxWidth: getResponsiveWidth(1),
                      controller: streetAndNumberTextController,
                      disabled: false,
                      placeholder: localization.register_address,
                      onChanged: resetError,
                      onFieldSubmitted: () => submit(validator))
                ]),
                const SizedBox(height: textFieldSpacing),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  FormTextfield(
                      maxWidth:
                          getResponsiveWidth(2, shouldWrapToNextLine: false),
                      controller: plzTextController,
                      disabled: false,
                      placeholder: localization.register_postcode,
                      onChanged: resetError,
                      onFieldSubmitted: () => submit(validator),
                      validator: validator.validatePostcode,
                      keyboardType: TextInputType.number),
                  const SizedBox(width: textFieldSpacing),
                  FormTextfield(
                      maxWidth:
                          getResponsiveWidth(2, shouldWrapToNextLine: false),
                      controller: placeTextController,
                      disabled: false,
                      placeholder: localization.register_place,
                      onChanged: resetError,
                      onFieldSubmitted: () => submit(validator))
                ]),
                const SizedBox(height: textFieldSpacing),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  FormTextfield(
                      maxWidth: getResponsiveWidth(1),
                      controller: emailTextController,
                      disabled: false,
                      placeholder: localization.register_email,
                      onChanged: resetError,
                      onFieldSubmitted: () => submit(validator),
                      validator: validator.validateEmail,
                      keyboardType: TextInputType.emailAddress)
                ]),
                const SizedBox(height: textFieldSpacing),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  FormTextfield(
                      maxWidth: getResponsiveWidth(1),
                      controller: passwordTextController,
                      disabled: false,
                      placeholder: localization.register_password,
                      onChanged: resetError,
                      onFieldSubmitted: () => submit(validator),
                      validator: validator.validatePassword,
                      obscureText: true)
                ]),
                const SizedBox(height: textFieldSpacing),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  FormTextfield(
                      maxWidth: getResponsiveWidth(1),
                      controller: passwordRepeatTextController,
                      disabled: false,
                      placeholder: localization.register_repeat_password,
                      onChanged: resetError,
                      onFieldSubmitted: () => submit(validator),
                      validator: (val) {
                        return validator.validatePasswordRepeat(
                            val, passwordTextController.text);
                      },
                      obscureText: true)
                ]),
                const SizedBox(height: textFieldSpacing),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  FormTextfield(
                      maxWidth: getResponsiveWidth(1),
                      controller: codeTextController,
                      disabled: false,
                      placeholder: localization.register_code,
                      onChanged: resetError,
                      onFieldSubmitted: () => submit(validator),
                      validator: validator.validateCode)
                ]),
                const SizedBox(height: textFieldSpacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(children: [
                      SizedBox(
                        width: getResponsiveWidth(1),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                  value: termsAndConditionsChecked,
                                  onChanged: (checked) {
                                    if (checked == true &&
                                        privacyPolicyChecked == true) {
                                      setButtonToDisabled(false);
                                    } else {
                                      setButtonToDisabled(true);
                                    }
                                    setState(() {
                                      termsAndConditionsChecked =
                                          checked ?? false;
                                    });
                                  }),
                              const SizedBox(width: 8),
                              Text("Ich stimme den",
                                  style: themeData.textTheme.bodyMedium),
                              const SizedBox(width: 4),
                              ClickableLink(
                                  title: "AGB",
                                  onTap: () {
                                    CustomNavigator.openInNewTab(
                                        RoutePaths.termsAndCondition);
                                  }),
                              const SizedBox(width: 4),
                              Text("zu", style: themeData.textTheme.bodyMedium)
                            ]),
                      ),
                      SizedBox(
                        width: getResponsiveWidth(1),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                  value: privacyPolicyChecked,
                                  onChanged: (checked) {
                                    if (checked == true &&
                                        termsAndConditionsChecked == true) {
                                      setButtonToDisabled(false);
                                    } else {
                                      setButtonToDisabled(true);
                                    }
                                    setState(() {
                                      privacyPolicyChecked = checked ?? false;
                                    });
                                  }),
                              const SizedBox(width: 8),
                              Text("Ich stimme der",
                                  style: themeData.textTheme.bodyMedium),
                              const SizedBox(width: 4),
                              ClickableLink(
                                  title: "Datenschutzerklärung",
                                  onTap: () {
                                    CustomNavigator.openInNewTab(
                                        RoutePaths.privacyPolicy);
                                  }),
                              const SizedBox(width: 4),
                              Text("zu", style: themeData.textTheme.bodyMedium)
                            ]),
                      ),
                    ])
                  ],
                ),
                const SizedBox(height: textFieldSpacing * 2),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    width: getResponsiveWidth(1),
                    child: PrimaryButton(
                        title: localization.register_now_buttontitle,
                        disabled: buttonDisabled,
                        isLoading: state is SignInLoadingState,
                        onTap: () {
                          submit(validator);
                        }),
                  ),
                ]),
                if (errorMessage != "" &&
                    showError &&
                    (state is! SignInLoadingState) &&
                    !validationHasError) ...[
                  const SizedBox(height: textFieldSpacing),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    SizedBox(
                        width: getResponsiveWidth(1),
                        child: FormErrorView(message: errorMessage)),
                  ])
                ],
                const SizedBox(height: 80),
              ]));
    });
  }
}
