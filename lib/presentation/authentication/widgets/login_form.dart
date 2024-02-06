import 'package:finanzbegleiter/application/authentication/signIn/sign_in_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/auth_failure_mapper.dart';
import 'package:finanzbegleiter/presentation/authentication/auth_validator.dart';
import 'package:finanzbegleiter/presentation/authentication/widgets/auth_button.dart';
import 'package:finanzbegleiter/presentation/authentication/widgets/auth_error_view.dart';
import 'package:finanzbegleiter/presentation/authentication/widgets/register_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routemaster/routemaster.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final validator = AuthValidator();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  bool showError = false;
  String errorMessage = "";

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return BlocConsumer<SignInBloc, SignInState>(
      listener: (context, state) {
        state.authFailureOrSuccessOption.fold(
            () => {},
            (eitherFailureOrSuccess) => eitherFailureOrSuccess.fold((failure) {
                  print("FAILURE: $failure");
                  errorMessage = AuthFailureMapper.mapFailureMessage(failure);
                  showError = true;
                }, (_) {
                  print("Logged in!");
                  showError = false;
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
                  Text("Willkommen",
                      style: themeData.textTheme.headlineLarge!.copyWith(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4)),
                  const SizedBox(height: 20),
                  Text("Melde dich an oder registriere dich.",
                      style: themeData.textTheme.headlineLarge!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 4)),
                  const SizedBox(height: 80),
                  TextFormField(
                    controller: emailTextController,
                    onChanged: (_) {
                      setState(() {
                        showError = false;
                        errorMessage = "";
                      });
                    },
                    validator: validator.validateEmail,
                    decoration: const InputDecoration(labelText: "E-Mail"),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordTextController,
                    onChanged: (_) {
                      setState(() {
                        showError = false;
                        errorMessage = "";
                      });
                    },
                    validator: validator.validatePassword,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Passwort"),
                  ),
                  const SizedBox(height: 20),
                  AuthButton(
                      title: "Anmelden",
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          BlocProvider.of<SignInBloc>(context).add(
                              LoginWithEmailAndPasswordPressed(
                                  email: emailTextController.text,
                                  password: passwordTextController.text));
                        } else {
                          BlocProvider.of<SignInBloc>(context).add(
                              LoginWithEmailAndPasswordPressed(
                                  email: null, password: null));
                        }
                      }),
                  const SizedBox(height: 20),
                  RegisterButton(
                      onTap: () => {
                            Routemaster.of(context)
                                .push(RoutePaths.registerPath)
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
                      !state.isSubmitting) ...[
                    const SizedBox(height: 20),
                    AuthErrorView(message: errorMessage)
                  ]
                ]));
      },
    );
  }
}
