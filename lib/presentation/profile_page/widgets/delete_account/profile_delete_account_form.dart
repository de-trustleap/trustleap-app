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

  void showAlert(ThemeData themeData, AppLocalizations localizations) {
    showDialog(
        context: context,
        builder: (_) {
          return CustomAlertDialog(
              title: localizations.delete_account_confirmation_alert_title,
              message: localizations.delete_account_confirmation_alert_message,
              actionButtonTitle: localizations
                  .delete_account_confirmation_alert_ok_button_title,
              cancelButtonTitle: localizations
                  .delete_account_confirmation_alert_cancel_button_title,
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
            showAlert(themeData, localization);
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
                    Text(localization.delete_account_title,
                        style: themeData.textTheme.headlineLarge!.copyWith(
                            fontSize: responsiveValue.isMobile ? 16 : 20,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Text(localization.delete_account_subtitle,
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
                      decoration: InputDecoration(
                          labelText:
                              localization.delete_account_password_placeholder),
                    ),
                    const SizedBox(height: 48),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(
                        width: responsiveValue.isMobile
                            ? maxWidth - 20
                            : maxWidth / 2 - 20,
                        child: SecondaryButton(
                            title: localization.delete_account_button_title,
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
