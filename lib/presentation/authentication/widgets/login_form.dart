import 'package:finanzbegleiter/application/authentication/auth/auth_cubit.dart';
import 'package:finanzbegleiter/application/authentication/signIn/sign_in_cubit.dart';
import 'package:finanzbegleiter/core/failures/auth_failure_mapper.dart';
import 'package:finanzbegleiter/core/helpers/auth_validator.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/authentication/widgets/password_forgotten_button.dart';
import 'package:finanzbegleiter/presentation/authentication/widgets/register_button.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
      BlocProvider.of<SignInCubit>(context).loginWithEmailAndPassword(
          emailTextController.text.trim(), passwordTextController.text);
    } else {
      validationHasError = true;
      BlocProvider.of<SignInCubit>(context)
          .loginWithEmailAndPassword(null, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final validator = AuthValidator(localization: localization);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return BlocConsumer<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state is SignInFailureState) {
          errorMessage =
              AuthFailureMapper.mapFailureMessage(state.failure, localization);
          showError = true;
        } else if (state is SignInSuccessState) {
          showError = false;
          BlocProvider.of<AuthCubit>(context).checkForAuthState();
        }
      },
      builder: (context, state) {
        return Form(
            key: formKey,
            autovalidateMode: (state is SignInShowValidationState)
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  SizedBox(height: responsiveValue.isMobile ? 40 : 80),
                  Text(localization.login_title,
                      style: themeData.textTheme.headlineLarge!.copyWith(
                          fontSize: responsiveValue.isMobile ? 20 : 50,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4)),
                  const SizedBox(height: 20),
                  Text(localization.login_subtitle,
                      style: themeData.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w500, letterSpacing: 4)),
                  const SizedBox(height: 80),
                  FormTextfield(
                      controller: emailTextController,
                      disabled: false,
                      placeholder: localization.login_email,
                      onChanged: resetError,
                      onFieldSubmitted: submit,
                      validator: validator.validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      accessibilityKey: const Key("loginTextField")),
                  const SizedBox(height: 20),
                  FormTextfield(
                      controller: passwordTextController,
                      disabled: false,
                      placeholder: localization.login_password,
                      onChanged: resetError,
                      onFieldSubmitted: submit,
                      validator: validator.validatePassword,
                      obscureText: true,
                      accessibilityKey: const Key("passwordTextField")),
                  const SizedBox(height: 16),
                  PasswordForgottenButton(
                      key: const Key("passwordForgottenButton"),
                      onTap: () =>
                          {Modular.to.pushNamed(RoutePaths.passwordReset)}),
                  const SizedBox(height: 24),
                  PrimaryButton(
                      title: localization.login_login_buttontitle,
                      key: const Key("loginButton"),
                      disabled: state is SignInLoadingState,
                      isLoading: state is SignInLoadingState,
                      onTap: () {
                        submit();
                      }),
                  const SizedBox(height: 24),
                  RegisterButton(
                      key: const Key("registerButton"),
                      onTap: () =>
                          {Modular.to.pushNamed(RoutePaths.registerPath)}),
                  if (errorMessage != "" &&
                      showError &&
                      (state is SignInFailureState) &&
                      !validationHasError) ...[
                    const SizedBox(height: 20),
                    FormErrorView(
                        message: errorMessage, key: const Key("formErrorView"))
                  ]
                ]));
      },
    );
  }
}
