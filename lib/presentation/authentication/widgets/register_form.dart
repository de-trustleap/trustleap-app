import 'package:finanzbegleiter/application/authentication/auth/auth_bloc.dart';
import 'package:finanzbegleiter/application/authentication/signIn/sign_in_bloc.dart';
import 'package:finanzbegleiter/application/authentication/user/user_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/auth_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/presentation/authentication/auth_validator.dart';
import 'package:finanzbegleiter/presentation/authentication/widgets/auth_button.dart';
import 'package:finanzbegleiter/presentation/authentication/widgets/auth_error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:routemaster/routemaster.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final validator = AuthValidator();
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
    super.dispose();
  }

  void resetError() {
    setState(() {
      showError = false;
      errorMessage = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    const double textFieldSpacing = 20;

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
                              email: creds.user!.email,
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
            Routemaster.of(context)
                .replace(RoutePaths.initialPath); // TODO: ROUTING IST KAPUTT!!!
            print("ROUTE REPLACED!");
          })
        ],
        child: BlocBuilder<SignInBloc, SignInState>(builder: (context, state) {
          return Form(
              key: formKey,
              child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const SizedBox(height: 80),
                    Text("Registrieren",
                        style: themeData.textTheme.headlineLarge!.copyWith(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4)),
                    const SizedBox(height: textFieldSpacing),
                    Text("Registriere dich jetzt um den Service zu nutzen",
                        style: themeData.textTheme.headlineLarge!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 4)),
                    const SizedBox(height: 80),
                    ResponsiveRowColumn(
                      layout: responsiveValue.largerThan(MOBILE)
                          ? ResponsiveRowColumnType.ROW
                          : ResponsiveRowColumnType.COLUMN,
                      children: [
                        ResponsiveRowColumnItem(
                            child: SizedBox(
                          width: responsiveValue.largerThan(MOBILE)
                              ? (230 - textFieldSpacing / 2)
                              : 460,
                          child: TextFormField(
                            controller: firstNameTextController,
                            onChanged: (_) {
                              resetError();
                            },
                            validator: validator.validateFirstName,
                            decoration:
                                const InputDecoration(labelText: "Vorname"),
                          ),
                        )),
                        const ResponsiveRowColumnItem(
                            child: SizedBox(
                                height: textFieldSpacing,
                                width: textFieldSpacing)),
                        ResponsiveRowColumnItem(
                          child: SizedBox(
                            width: responsiveValue.largerThan(MOBILE)
                                ? (230 - textFieldSpacing / 2)
                                : 460,
                            child: TextFormField(
                              controller: lastNameTextController,
                              onChanged: (_) {
                                resetError();
                              },
                              validator: validator.validateLastName,
                              decoration:
                                  const InputDecoration(labelText: "Nachname"),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: textFieldSpacing),
                    TextFormField(
                        controller: birthDateTextController,
                        onChanged: (_) {
                          resetError();
                        },
                        validator: validator.validateBirthDate,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today_rounded),
                            labelText: "Geburtsdatum"),
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
                        }),
                    const SizedBox(height: textFieldSpacing),
                    TextFormField(
                      controller: streetAndNumberTextController,
                      onChanged: (_) {
                        resetError();
                      },
                      decoration: const InputDecoration(
                          labelText: "Straße u. Hausnummer (optional)"),
                    ),
                    const SizedBox(height: textFieldSpacing),
                    Row(children: [
                      SizedBox(
                        width: (230 - textFieldSpacing / 2),
                        child: TextFormField(
                          controller: plzTextController,
                          onChanged: (_) {
                            resetError();
                          },
                          decoration: const InputDecoration(
                              labelText: "PLZ (optional)"),
                        ),
                      ),
                      const SizedBox(width: textFieldSpacing),
                      SizedBox(
                        width: (230 - textFieldSpacing / 2),
                        child: TextFormField(
                          controller: placeTextController,
                          onChanged: (_) {
                            resetError();
                          },
                          decoration: const InputDecoration(
                              labelText: "Ort (optional)"),
                        ),
                      ),
                    ]),
                    const SizedBox(height: textFieldSpacing),
                    TextFormField(
                      controller: emailTextController,
                      onChanged: (_) {
                        resetError();
                      },
                      validator: validator.validateEmail,
                      decoration: const InputDecoration(labelText: "E-Mail"),
                    ),
                    const SizedBox(height: textFieldSpacing),
                    TextFormField(
                      controller: passwordTextController,
                      onChanged: (_) {
                        resetError();
                      },
                      validator: validator.validatePassword,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: "Passwort"),
                    ),
                    const SizedBox(height: textFieldSpacing),
                    TextFormField(
                      controller: passwordRepeatTextController,
                      onChanged: (_) {
                        resetError();
                      },
                      validator: (val) {
                        return validator.validatePasswordRepeat(
                            val, passwordTextController.text);
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: "Passwort bestätigen"),
                    ),
                    const SizedBox(height: textFieldSpacing),
                    AuthButton(
                        title: "Registrieren",
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            validationHasError = false;
                            BlocProvider.of<SignInBloc>(context).add(
                                RegisterWithEmailAndPasswordPressed(
                                    email: emailTextController.text,
                                    password: passwordTextController.text));
                          } else {
                            validationHasError = true;
                            BlocProvider.of<SignInBloc>(context).add(
                                RegisterWithEmailAndPasswordPressed(
                                    email: null, password: null));
                          }
                        }),
                    if (state.isSubmitting) ...[
                      const SizedBox(height: 80),
                      Center(
                        child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                                color: themeData.colorScheme.secondary)),
                      )
                    ],
                    if (errorMessage != "" &&
                        showError &&
                        !state.isSubmitting &&
                        !validationHasError) ...[
                      const SizedBox(height: textFieldSpacing),
                      AuthErrorView(message: errorMessage)
                    ],
                    const SizedBox(height: textFieldSpacing),
                  ]));
        }));
  }
}
