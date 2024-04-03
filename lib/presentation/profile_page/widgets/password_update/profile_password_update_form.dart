import 'package:finanzbegleiter/application/profile/profile/profile_cubit.dart';
import 'package:finanzbegleiter/core/failures/auth_failure_mapper.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/password_update/profile_password_update_new.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/password_update/profile_password_update_reauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum PasswordUpdateVisibleTextField { passwordReauth, passwordsNew }

class ProfilePasswordUpdateForm extends StatefulWidget {
  const ProfilePasswordUpdateForm({super.key});

  @override
  State<ProfilePasswordUpdateForm> createState() =>
      _ProfilePasswordUpdateFormState();
}

class _ProfilePasswordUpdateFormState extends State<ProfilePasswordUpdateForm> {
  final oldPasswordTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final passwordRepeatTextController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool showError = false;
  String errorMessage = "";
  bool validationHasError = false;
  bool buttonDisabled = false;

  PasswordUpdateVisibleTextField visibleField =
      PasswordUpdateVisibleTextField.passwordReauth;

  @override
  void dispose() {
    oldPasswordTextController.dispose();
    passwordTextController.dispose();
    passwordRepeatTextController.dispose();
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

  void submitOldPassword() {
    if (formKey.currentState!.validate()) {
      validationHasError = false;
      BlocProvider.of<ProfileCubit>(context)
          .reauthenticateWithPasswordForPasswordUpdate(
              oldPasswordTextController.text);
    }
  }

  void submitNewPassword() {
    if (formKey.currentState!.validate()) {
      validationHasError = false;
      BlocProvider.of<ProfileCubit>(context)
          .updatePassword(passwordTextController.text);
    } else {
      validationHasError = true;
      BlocProvider.of<ProfileCubit>(context).updatePassword(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return CardContainer(child: LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      return BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileReauthenticateForPasswordUpdateSuccessState) {
            visibleField = PasswordUpdateVisibleTextField.passwordsNew;
            setButtonToDisabled(false);
          } else if (state is ProfilePasswordUpdateFailureState) {
            errorMessage = AuthFailureMapper.mapFailureMessage(
                state.failure, localization);
            showError = true;
            setButtonToDisabled(false);
          } else if (state is ProfilePasswordUpdateSuccessState) {
            BlocProvider.of<ProfileCubit>(context).signOutUser();
            setButtonToDisabled(false);
          } else if (state is ProfilePasswordUpdateLoadingState) {
            setButtonToDisabled(true);
          }
        },
        builder: (context, state) {
          return Form(
              key: formKey,
              autovalidateMode: (state is ProfileShowValidationState)
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        localization.profile_page_password_update_section_title,
                        style: themeData.textTheme.headlineLarge!
                            .copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    if (visibleField ==
                        PasswordUpdateVisibleTextField.passwordReauth) ...[
                      ProfilePasswordUpdateReauth(
                          passwordTextController: oldPasswordTextController,
                          maxWidth: maxWidth,
                          buttonDisabled: buttonDisabled,
                          resetError: resetError,
                          submit: submitOldPassword)
                    ] else ...[
                      ProfilePasswordUpdateNew(
                          passwordTextController: passwordTextController,
                          passwordRepeatTextController:
                              passwordRepeatTextController,
                          maxWidth: maxWidth,
                          buttonDisabled: buttonDisabled,
                          resetError: resetError,
                          submit: submitNewPassword)
                    ],
                    if (state is ProfilePasswordUpdateLoadingState) ...[
                      const SizedBox(height: 80),
                      const LoadingIndicator()
                    ],
                    if (errorMessage != "" &&
                        showError &&
                        state is ProfilePasswordUpdateFailureState &&
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
