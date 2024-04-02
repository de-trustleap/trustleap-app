// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/promoter/promoter/promoter_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/core/helpers/auth_validator.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/unregistered_promoter.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/gender_picker.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:responsive_framework/responsive_row_column.dart';

class RegisterPromotersForm extends StatefulWidget {
  final Function changesSaved;

  const RegisterPromotersForm({
    Key? key,
    required this.changesSaved,
  }) : super(key: key);

  @override
  State<RegisterPromotersForm> createState() => _RegisterPromotersFormState();
}

class _RegisterPromotersFormState extends State<RegisterPromotersForm> {
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  final birthDateTextController = TextEditingController();
  final emailTextController = TextEditingController();
  Gender? selectedGender;
  User? currentUser;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool showError = false;
  String errorMessage = "";
  bool validationHasError = false;
  String? genderValid;
  bool buttonDisabled = false;

  @override
  void initState() {
    BlocProvider.of<PromoterCubit>(context).getCurrentUser();
    super.initState();
  }

  @override
  void dispose() {
    firstNameTextController.dispose();
    lastNameTextController.dispose();
    birthDateTextController.dispose();
    emailTextController.dispose();

    super.dispose();
  }

  void resetError() {
    setState(() {
      showError = false;
      errorMessage = "";
    });
  }

  void setButtonToDisabled(bool disabled) {
    setState(() {
      buttonDisabled = disabled;
    });
  }

  void submit(AuthValidator validator) {
    if (formKey.currentState!.validate() &&
        validator.validateGender(selectedGender) == null) {
      validationHasError = false;
      setState(() {
        genderValid = null;
      });
      if (currentUser != null) {
        BlocProvider.of<PromoterCubit>(context).registerPromoter(
            UnregisteredPromoter(
                id: UniqueID(),
                gender: selectedGender,
                firstName: firstNameTextController.text.trim(),
                lastName: lastNameTextController.text.trim(),
                birthDate: birthDateTextController.text.trim(),
                email: emailTextController.text.trim(),
                parentUserID: UniqueID.fromUniqueString(currentUser?.uid ?? ""),
                code: UniqueID()));
      }
    } else {
      validationHasError = true;
      setState(() {
        genderValid = validator.validateGender(selectedGender);
      });
      BlocProvider.of<PromoterCubit>(context).registerPromoter(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    final validator = AuthValidator(localization: localization);
    const double textFieldSpacing = 20;
    return BlocConsumer<PromoterCubit, PromoterState>(
      listener: (context, state) {
        if (state is PromoterRegisterFailureState) {
          errorMessage = DatabaseFailureMapper.mapFailureMessage(
              state.failure, localization);
          showError = true;
          setButtonToDisabled(false);
        } else if (state is PromoterAlreadyExistsFailureState) {
          errorMessage =
              "Die E-Mail Adresse existiert bereits bei einem anderen Nutzer.";
          showError = true;
          setButtonToDisabled(false);
        } else if (state is PromoterRegisteredSuccessState) {
          widget.changesSaved();
          setButtonToDisabled(false);
        } else if (state is PromoterGetCurrentUserSuccessState) {
          currentUser = state.user;
        } else if (state is PromoterRegisterLoadingState) {
          setButtonToDisabled(true);
        }
      },
      builder: (context, state) {
        return CardContainer(
            child: LayoutBuilder(builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          if (state is PromoterGetCurrentUserLoadingState) {
            return const LoadingIndicator();
          } else {
            return Form(
                key: formKey,
                autovalidateMode: (state is PromoterShowValidationState)
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Promoter registrieren",
                          style: themeData.textTheme.headlineLarge!.copyWith(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: textFieldSpacing + 4),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GenderPicker(
                                width: maxWidth,
                                validate: genderValid,
                                onSelected: (gender) {
                                  setState(() {
                                    genderValid =
                                        validator.validateGender(gender);
                                    selectedGender = gender;
                                  });
                                  resetError();
                                })
                          ]),
                      const SizedBox(height: textFieldSpacing),
                      ResponsiveRowColumn(
                          columnMainAxisSize: MainAxisSize.min,
                          layout: responsiveValue.isMobile
                              ? ResponsiveRowColumnType.COLUMN
                              : ResponsiveRowColumnType.ROW,
                          children: [
                            ResponsiveRowColumnItem(
                              child: SizedBox(
                                width: responsiveValue.isMobile
                                    ? maxWidth
                                    : maxWidth / 2,
                                child: TextFormField(
                                  controller: firstNameTextController,
                                  onFieldSubmitted: (_) => submit(validator),
                                  onChanged: (_) {
                                    resetError();
                                  },
                                  validator: validator.validateFirstName,
                                  decoration: const InputDecoration(
                                      labelText: "Vorname"),
                                ),
                              ),
                            ),
                            const ResponsiveRowColumnItem(
                                child: SizedBox(
                                    height: textFieldSpacing,
                                    width: textFieldSpacing)),
                            ResponsiveRowColumnItem(
                              child: SizedBox(
                                width: responsiveValue.isMobile
                                    ? maxWidth
                                    : maxWidth / 2 - textFieldSpacing,
                                child: TextFormField(
                                  controller: lastNameTextController,
                                  onFieldSubmitted: (_) => submit(validator),
                                  onChanged: (_) {
                                    resetError();
                                  },
                                  validator: validator.validateLastName,
                                  decoration: const InputDecoration(
                                      labelText: "Nachname"),
                                ),
                              ),
                            )
                          ]),
                      const SizedBox(height: textFieldSpacing),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: maxWidth,
                              child: TextFormField(
                                  keyboardType: TextInputType.datetime,
                                  controller: birthDateTextController,
                                  onFieldSubmitted: (_) => submit(validator),
                                  onChanged: (_) {
                                    resetError();
                                  },
                                  validator: validator.validateBirthDate,
                                  decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                          Icons.calendar_today_rounded),
                                      labelText:
                                          localization.register_birthdate),
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now());
                                    if (pickedDate != null) {
                                      setState(() {
                                        birthDateTextController.text =
                                            DateFormat("dd.MM.yyyy")
                                                .format(pickedDate);
                                      });
                                    }
                                  }),
                            ),
                          ]),
                      const SizedBox(height: textFieldSpacing),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: maxWidth,
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: emailTextController,
                                onFieldSubmitted: (_) => submit(validator),
                                onChanged: (_) {
                                  resetError();
                                },
                                validator: validator.validateEmail,
                                decoration: InputDecoration(
                                    labelText: localization.register_email),
                              ),
                            ),
                          ]),
                      const SizedBox(height: textFieldSpacing * 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          PrimaryButton(
                              title: "Registrieren",
                              width: maxWidth / 2 - textFieldSpacing,
                              disabled: buttonDisabled,
                              onTap: () {
                                submit(validator);
                              })
                        ],
                      ),
                      if (state is PromoterRegisterLoadingState) ...[
                        const SizedBox(height: 80),
                        const LoadingIndicator()
                      ],
                      if (errorMessage != "" &&
                          showError &&
                          (state is PromoterRegisterFailureState ||
                              state is PromoterAlreadyExistsFailureState) &&
                          !validationHasError) ...[
                        const SizedBox(height: 20),
                        FormErrorView(message: errorMessage)
                      ]
                    ]));
          }
        }));
      },
    );
  }
}
