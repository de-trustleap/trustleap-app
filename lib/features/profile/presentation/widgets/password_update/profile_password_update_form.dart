import 'package:finanzbegleiter/features/auth/application/auth/auth_cubit.dart';
import 'package:finanzbegleiter/features/profile/application/profile/profile_cubit.dart';
import 'package:finanzbegleiter/core/failures/auth_failure_mapper.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/password_update/profile_password_update_new.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/password_update/profile_password_update_reauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
      Modular.get<ProfileCubit>().reauthenticateWithPasswordForPasswordUpdate(
          oldPasswordTextController.text);
    }
  }

  void submitNewPassword() {
    if (formKey.currentState!.validate()) {
      validationHasError = false;
      Modular.get<ProfileCubit>().updatePassword(passwordTextController.text);
    } else {
      validationHasError = true;
      Modular.get<ProfileCubit>().updatePassword(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileCubit = Modular.get<ProfileCubit>();
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return CardContainer(child: LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      return BlocConsumer<ProfileCubit, ProfileState>(
        bloc: profileCubit,
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
            BlocProvider.of<AuthCubit>(context).signOut();
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
                    SelectableText(
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
                          isLoading: state is ProfilePasswordUpdateLoadingState,
                          resetError: resetError,
                          submit: submitOldPassword)
                    ] else ...[
                      ProfilePasswordUpdateNew(
                          passwordTextController: passwordTextController,
                          passwordRepeatTextController:
                              passwordRepeatTextController,
                          maxWidth: maxWidth,
                          buttonDisabled: buttonDisabled,
                          isLoading: state is ProfilePasswordUpdateLoadingState,
                          resetError: resetError,
                          submit: submitNewPassword)
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
