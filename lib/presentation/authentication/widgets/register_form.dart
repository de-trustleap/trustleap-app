import 'package:finanzbegleiter/application/authentication/auth/auth_bloc.dart';
import 'package:finanzbegleiter/application/authentication/signIn/sign_in_bloc.dart';
import 'package:finanzbegleiter/application/authentication/user/user_bloc.dart';
import 'package:finanzbegleiter/core/failures/auth_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/authentication/auth_validator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

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

  bool showError = false;
  String errorMessage = "";
  bool validationHasError = false;

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

    super.dispose();
  }

  void resetError() {
    setState(() {
      showError = false;
      errorMessage = "";
    });
  }

  void submit() {
    if (formKey.currentState!.validate()) {
      validationHasError = false;
      BlocProvider.of<SignInBloc>(context).add(
          RegisterWithEmailAndPasswordPressed(
              email: emailTextController.text,
              password: passwordTextController.text));
    } else {
      validationHasError = true;
      BlocProvider.of<SignInBloc>(context).add(
          RegisterWithEmailAndPasswordPressed(email: null, password: null));
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final validator = AuthValidator(localization: localization);
    final FocusNode node1 = FocusNode();
    const double textFieldSpacing = 20;
    const double maxViewWidth = 500;
    const double listPadding = 20;

    /// this function handles the responsive layout.
    /// [fieldCount] contains the number of fields that are max in the specific row.
    /// [shouldWrapToNextLine] defines if the fieldCount > 1 wraps to the next line on mobile.
    double getResponsiveWidth(int fieldCount,
        {bool shouldWrapToNextLine = true}) {
      double mobileWidth = (responsiveValue.screenWidth - listPadding * 2);
      if (fieldCount == 1) {
        return responsiveValue.largerThan(MOBILE) ? maxViewWidth : mobileWidth;
      } else if (fieldCount == 2) {
        if (shouldWrapToNextLine) {
          return responsiveValue.largerThan(MOBILE)
              ? (maxViewWidth / 2 - listPadding / 2)
              : mobileWidth;
        } else {
          return responsiveValue.largerThan(MOBILE)
              ? (maxViewWidth / 2 - listPadding / 2)
              : (mobileWidth / 2 - listPadding / 2);
        }
      } else {
        return 0;
      }
    }

    return MultiBlocListener(
        listeners: [
          BlocListener<SignInBloc, SignInState>(listener: (context, state) {
            state.authFailureOrSuccessOption.fold(
                () => {},
                (eitherFailureOrSuccess) =>
                    eitherFailureOrSuccess.fold((failure) {
                      errorMessage =
                          AuthFailureMapper.mapFailureMessage(failure);
                      showError = true;
                    }, (creds) {
                      showError = false;
                      BlocProvider.of<UserBloc>(context).add(CreateUserEvent(
                          user: CustomUser(
                              id: UniqueID.fromUniqueString(creds.user!.uid),
                              firstName: firstNameTextController.text,
                              lastName: lastNameTextController.text,
                              birthDate: birthDateTextController.text,
                              address: streetAndNumberTextController.text,
                              postCode: plzTextController.text,
                              place: placeTextController.text)));
                    }));
          }),
          BlocListener<UserBloc, UserState>(listener: (context, state) {
            BlocProvider.of<AuthBloc>(context).add(AuthCheckRequestedEvent());
          })
        ],
        child: BlocBuilder<SignInBloc, SignInState>(builder: (context, state) {
          return Form(
              key: formKey,
              child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: listPadding),
                  children: [
                    const SizedBox(height: 80),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(
                        width: getResponsiveWidth(1),
                        child: Text(localization.register_title,
                            style: themeData.textTheme.headlineLarge!.copyWith(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 4)),
                      ),
                    ]),
                    const SizedBox(height: textFieldSpacing),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(
                        width: getResponsiveWidth(1),
                        child: Text(localization.register_subtitle,
                            style: themeData.textTheme.headlineLarge!.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 4)),
                      ),
                    ]),
                    const SizedBox(height: 80),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(
                        width: getResponsiveWidth(1),
                        child: ResponsiveRowColumn(
                          layout: responsiveValue.largerThan(MOBILE)
                              ? ResponsiveRowColumnType.ROW
                              : ResponsiveRowColumnType.COLUMN,
                          children: [
                            ResponsiveRowColumnItem(
                                child: SizedBox(
                              width: getResponsiveWidth(2),
                              child: TextFormField(
                                controller: firstNameTextController,
                                onFieldSubmitted: (_) => submit(),
                                onChanged: (_) {
                                  resetError();
                                },
                                validator: validator.validateFirstName,
                                decoration: InputDecoration(
                                    labelText: localization.register_firstname),
                              ),
                            )),
                            const ResponsiveRowColumnItem(
                                child: SizedBox(
                                    height: textFieldSpacing,
                                    width: textFieldSpacing)),
                            ResponsiveRowColumnItem(
                              child: SizedBox(
                                width: getResponsiveWidth(2),
                                child: TextFormField(
                                  controller: lastNameTextController,
                                  onFieldSubmitted: (_) => submit(),
                                  onChanged: (_) {
                                    resetError();
                                  },
                                  validator: validator.validateLastName,
                                  decoration: InputDecoration(
                                      labelText:
                                          localization.register_lastname),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ]),
                    const SizedBox(height: textFieldSpacing),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(
                        width: getResponsiveWidth(1),
                        child: FocusScope(
                          child: Focus(
                            onFocusChange: (focus) async {
                              if (focus) {
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
                                WidgetsBinding
                                    .instance.focusManager.primaryFocus
                                    ?.unfocus();
                              }
                            },
                            child: TextFormField(
                                keyboardType: TextInputType.datetime,
                                controller: birthDateTextController,
                                onFieldSubmitted: (_) => submit(),
                                onChanged: (_) {
                                  resetError();
                                },
                                validator: validator.validateBirthDate,
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                        Icons.calendar_today_rounded),
                                    labelText: localization.register_birthdate),
                                onTap: () async {}),
                          ),
                        ),
                      ),
                    ]),
                    const SizedBox(height: textFieldSpacing),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(
                        width: getResponsiveWidth(1),
                        child: TextFormField(
                          controller: streetAndNumberTextController,
                          focusNode: node1,
                          onFieldSubmitted: (_) => submit(),
                          onChanged: (_) {
                            resetError();
                          },
                          decoration: InputDecoration(
                              labelText: localization.register_address),
                        ),
                      ),
                    ]),
                    const SizedBox(height: textFieldSpacing),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(
                        width:
                            getResponsiveWidth(2, shouldWrapToNextLine: false),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: plzTextController,
                          onFieldSubmitted: (_) => submit(),
                          validator: validator.validatePostcode,
                          onChanged: (_) {
                            resetError();
                          },
                          decoration: InputDecoration(
                              labelText: localization.register_postcode),
                        ),
                      ),
                      const SizedBox(width: textFieldSpacing),
                      SizedBox(
                        width:
                            getResponsiveWidth(2, shouldWrapToNextLine: false),
                        child: TextFormField(
                          controller: placeTextController,
                          onFieldSubmitted: (_) => submit(),
                          onChanged: (_) {
                            resetError();
                          },
                          decoration: InputDecoration(
                              labelText: localization.register_place),
                        ),
                      ),
                    ]),
                    const SizedBox(height: textFieldSpacing),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(
                        width: getResponsiveWidth(1),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailTextController,
                          onFieldSubmitted: (_) => submit(),
                          onChanged: (_) {
                            resetError();
                          },
                          validator: validator.validateEmail,
                          decoration: InputDecoration(
                              labelText: localization.register_email),
                        ),
                      ),
                    ]),
                    const SizedBox(height: textFieldSpacing),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(
                        width: getResponsiveWidth(1),
                        child: TextFormField(
                          controller: passwordTextController,
                          onFieldSubmitted: (_) => submit(),
                          onChanged: (_) {
                            resetError();
                          },
                          validator: validator.validatePassword,
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: localization.register_password),
                        ),
                      ),
                    ]),
                    const SizedBox(height: textFieldSpacing),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(
                        width: getResponsiveWidth(1),
                        child: TextFormField(
                          controller: passwordRepeatTextController,
                          onFieldSubmitted: (_) => submit(),
                          onChanged: (_) {
                            resetError();
                          },
                          validator: (val) {
                            return validator.validatePasswordRepeat(
                                val, passwordTextController.text);
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: localization.register_repeat_password),
                        ),
                      ),
                    ]),
                    const SizedBox(height: textFieldSpacing),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(
                        width: getResponsiveWidth(1),
                        child: PrimaryButton(
                            title: localization.register_now_buttontitle,
                            onTap: () {
                              submit();
                            }),
                      ),
                    ]),
                    if (state.isSubmitting) ...[
                      const SizedBox(height: 80),
                      const LoadingIndicator()
                    ],
                    if (errorMessage != "" &&
                        showError &&
                        !state.isSubmitting &&
                        !validationHasError) ...[
                      const SizedBox(height: textFieldSpacing),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: getResponsiveWidth(1),
                                child: FormErrorView(message: errorMessage)),
                          ])
                    ],
                    const SizedBox(height: 80),
                  ]));
        }));
  }
}
