import 'package:finanzbegleiter/application/authentication/auth/auth_bloc.dart';
import 'package:finanzbegleiter/core/failures/auth_failure_mapper.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/authentication/auth_validator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/custom_alert_dialog.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PasswordForgottenForm extends StatefulWidget {
  const PasswordForgottenForm({super.key});

  @override
  State<PasswordForgottenForm> createState() => _PasswordForgottenFormState();
}

class _PasswordForgottenFormState extends State<PasswordForgottenForm> {
  final emailTextController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool showError = false;
  String errorMessage = "";
  bool validationHasError = false;

  @override
  void dispose() {
    emailTextController.dispose();

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
      BlocProvider.of<AuthBloc>(context).add(
          AuthPasswordResetRequestedEvent(email: emailTextController.text));
    } else {
      validationHasError = true;
      BlocProvider.of<AuthBloc>(context)
          .add(AuthPasswordResetRequestedEvent(email: null));
    }
  }

  void alertAction() {
    Modular.to.pop();
    Modular.to.navigate(RoutePaths.loginPath);
  }

  void showSuccessDialog(ThemeData themeData) {
    showDialog(
        context: context,
        builder: (_) {
          return CustomAlertDialog(
              title: "Passwort erfolgreich zurückgesetzt",
              message:
                  "Eine E-Mail wurde an die angegebene E-Mail Adresse gesendet. Über den Link in der Mail können Sie ihr neues Passwort festlegen.",
              actionButtonTitle: "Zurück zum Login",
              actionButtonAction: alertAction);
        });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final validator = AuthValidator(localization: localization);
    const double padding = 20;
    return BlocConsumer<AuthBloc, AuthState>(listener: ((context, state) {
      if (state is AuthPasswordResetFailureState) {
        errorMessage = AuthFailureMapper.mapFailureMessage(state.failure);
        showError = true;
      } else if (state is AuthPasswordResetSuccessState) {
        showSuccessDialog(themeData);
      }
    }), builder: (context, state) {
      return CardContainer(
        child: LayoutBuilder(builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;

          return Form(
              key: formKey,
              autovalidateMode: state is AuthShowValidationState
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: padding),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 80),
                      Text("Passwort zurücksetzen",
                          style: themeData.textTheme.headlineLarge!.copyWith(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: padding),
                      Text(
                          "Bitte geben Sie ihre E-Mail Adresse ein und bestätigen Sie. Ihnen wird anschließend ein Link an die angegebene E-Mail Adresse gesendet.\nÜber diesen Link können Sie ihr Passwort zurücksetzen.",
                          style: themeData.textTheme.headlineLarge!
                              .copyWith(fontSize: 16)),
                      const SizedBox(height: padding),
                      TextFormField(
                        controller: emailTextController,
                        onChanged: (_) {
                          resetError();
                        },
                        onFieldSubmitted: (_) => submit(),
                        validator: validator.validateEmail,
                        decoration:
                            const InputDecoration(labelText: "E-Mail Adresse"),
                      ),
                      const SizedBox(height: padding * 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          PrimaryButton(
                              title: "Passwort zurücksetzen",
                              width: maxWidth / 2 - padding,
                              onTap: () {
                                submit();
                              })
                        ],
                      ),
                      if (state is AuthPasswordResetLoadingState) ...[
                        const SizedBox(height: 80),
                        const LoadingIndicator()
                      ],
                      if (errorMessage != "" &&
                          showError &&
                          state is AuthPasswordResetFailureState &&
                          !validationHasError) ...[
                        const SizedBox(height: padding),
                        FormErrorView(message: errorMessage)
                      ]
                    ]),
              ));
        }),
      );
    });
  }
}
