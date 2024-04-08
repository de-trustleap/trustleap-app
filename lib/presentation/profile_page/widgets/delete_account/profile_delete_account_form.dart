import 'package:finanzbegleiter/application/authentication/auth/auth_cubit.dart';
import 'package:finanzbegleiter/application/profile/profile/profile_cubit.dart';
import 'package:finanzbegleiter/core/failures/auth_failure_mapper.dart';
import 'package:finanzbegleiter/core/helpers/auth_validator.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/custom_alert_dialog.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class ProfileDeleteAccountForm extends StatefulWidget {
  const ProfileDeleteAccountForm({super.key});

  @override
  State<ProfileDeleteAccountForm> createState() =>
      _ProfileDeleteAccountFormState();
}

class _ProfileDeleteAccountFormState extends State<ProfileDeleteAccountForm> {
  final passwordTextController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool showError = false;
  String errorMessage = "";
  bool validationHasError = false;
  bool buttonDisabled = false;

  @override
  void dispose() {
    passwordTextController.dispose();
    super.dispose();
  }

  void setButtonToDisabled(bool disabled) {
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

  void submit() {
    if (formKey.currentState!.validate()) {
      validationHasError = false;
      BlocProvider.of<ProfileCubit>(context)
          .reauthenticateWithPasswordForAccountDeletion(
              passwordTextController.text);
    } else {
      validationHasError = true;
      BlocProvider.of<ProfileCubit>(context)
          .reauthenticateWithPasswordForAccountDeletion(null);
    }
  }

  void showAlert(ThemeData themeData) {
    showDialog(
        context: context,
        builder: (_) {
          return CustomAlertDialog(
              title: "Account wirklich löschen?",
              message:
                  "Sind Sie sicher dass Sie ihren Account löschen möchten?",
              actionButtonTitle: "Account löschen",
              cancelButtonTitle: "Abbrechen",
              actionButtonAction: submitAccountDeletion,
              cancelButtonAction: () => Modular.to.pop());
        });
  }

  void submitAccountDeletion() {
    Modular.to.pop();
    BlocProvider.of<ProfileCubit>(context).deleteAccount();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    final validator = AuthValidator(localization: localization);

    return CardContainer(child: LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      return BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileAccountDeletionFailureState) {
            errorMessage = AuthFailureMapper.mapFailureMessage(
                state.failure, localization);
            showError = true;
            setButtonToDisabled(false);
          } else if (state
              is ProfileReauthenticateForAccountDeletionSuccessState) {
            showAlert(themeData);
            setButtonToDisabled(false);
          } else if (state is ProfileAccountDeletionSuccessState) {
            BlocProvider.of<AuthCubit>(context).signOut();
          } else if (state is ProfileAccountDeletionLoadingState) {
            setButtonToDisabled(true);
          }
        },
        builder: (context, state) {
          return Form(
              key: formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Account löschen",
                        style: themeData.textTheme.headlineLarge!.copyWith(
                            fontSize: responsiveValue.isMobile ? 16 : 20,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Text(
                        "Mit der Löschung Ihres Accounts verbleiben Ihre Daten noch 30 Tage bei uns. In dieser Zeit können Sie sich noch beim Support melden um die Löschung rückgängig zu machen. Danach werden Ihre Daten unwiderruflich gelöscht sein.\n\nGeben Sie bitte ihr Passwort ein um den Account zu löschen.",
                        style: responsiveValue.isMobile
                            ? themeData.textTheme.bodySmall
                            : themeData.textTheme.bodyMedium),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: passwordTextController,
                      onFieldSubmitted: (_) => submit(),
                      onChanged: (_) {
                        resetError();
                      },
                      validator: validator.validatePassword,
                      obscureText: true,
                      style: responsiveValue.isMobile
                          ? themeData.textTheme.bodySmall
                          : themeData.textTheme.bodyMedium,
                      decoration: const InputDecoration(labelText: "Passwort"),
                    ),
                    const SizedBox(height: 48),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(
                        width: responsiveValue.isMobile
                            ? maxWidth - 20
                            : maxWidth / 2 - 20,
                        child: SecondaryButton(
                            title: "Account löschen",
                            disabled: buttonDisabled,
                            onTap: submit),
                      ),
                    ]),
                    if (state is ProfileAccountDeletionLoadingState) ...[
                      const SizedBox(height: 80),
                      const LoadingIndicator()
                    ],
                    if (errorMessage != "" &&
                        showError &&
                        state is ProfileAccountDeletionFailureState &&
                        !validationHasError) ...[
                      const SizedBox(height: 20),
                      FormErrorView(message: errorMessage)
                    ]
                  ]));
        },
      );
    }));
  }
}
