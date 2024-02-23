import 'package:finanzbegleiter/application/authentication/auth/auth_bloc.dart';
import 'package:finanzbegleiter/application/authentication/signIn/sign_in_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/auth_failure_mapper.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/authentication/auth_validator.dart';
import 'package:finanzbegleiter/presentation/authentication/widgets/register_button.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routemaster/routemaster.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

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

  void submit() {
    if (formKey.currentState!.validate()) {
      validationHasError = false;
      BlocProvider.of<SignInBloc>(context).add(LoginWithEmailAndPasswordPressed(
          email: emailTextController.text,
          password: passwordTextController.text));
    } else {
      validationHasError = true;
      BlocProvider.of<SignInBloc>(context)
          .add(LoginWithEmailAndPasswordPressed(email: null, password: null));
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final validator = AuthValidator(localization: localization);

    return BlocConsumer<SignInBloc, SignInState>(
      listener: (context, state) {
        state.authFailureOrSuccessOption.fold(
            () => {},
            (eitherFailureOrSuccess) => eitherFailureOrSuccess.fold((failure) {
                  errorMessage = AuthFailureMapper.mapFailureMessage(failure);
                  showError = true;
                }, (_) {
                  showError = false;
                  BlocProvider.of<AuthBloc>(context)
                      .add(AuthCheckRequestedEvent());
                }));
      },
      builder: (context, state) {
        return Form(
            key: formKey,
            autovalidateMode: state.showValidationMessages
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 80),
                  Text(localization.login_title,
                      style: themeData.textTheme.headlineLarge!.copyWith(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4)),
                  const SizedBox(height: 20),
                  Text(localization.login_subtitle,
                      style: themeData.textTheme.headlineLarge!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 4)),
                  const SizedBox(height: 80),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailTextController,
                    onChanged: (_) {
                      resetError();
                    },
                    onFieldSubmitted: (_) => submit(),
                    validator: validator.validateEmail,
                    decoration:
                        InputDecoration(labelText: localization.login_email),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordTextController,
                    onChanged: (_) {
                      resetError();
                    },
                    onFieldSubmitted: (_) => submit(),
                    validator: validator.validatePassword,
                    obscureText: true,
                    decoration:
                        InputDecoration(labelText: localization.login_password),
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                      title: localization.login_login_buttontitle,
                      onTap: () {
                        submit();
                      }),
                  const SizedBox(height: 20),
                  RegisterButton(
                      onTap: () => {
                            Routemaster.of(context)
                                .push(RoutePaths.registerPath)
                          }),
                  if (state.isSubmitting) ...[
                    const SizedBox(height: 80),
                    const LoadingIndicator()
                  ],
                  if (errorMessage != "" &&
                      showError &&
                      !state.isSubmitting &&
                      !validationHasError) ...[
                    const SizedBox(height: 20),
                    FormErrorView(message: errorMessage)
                  ]
                ]));
      },
    );
  }
}
