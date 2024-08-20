// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/core/helpers/auth_validator.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_textfield.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ProfilePasswordUpdateNew extends StatelessWidget {
  final TextEditingController passwordTextController;
  final TextEditingController passwordRepeatTextController;
  final double maxWidth;
  final bool buttonDisabled;
  final bool isLoading;
  final Function resetError;
  final Function submit;

  const ProfilePasswordUpdateNew({
    super.key,
    required this.passwordTextController,
    required this.passwordRepeatTextController,
    required this.maxWidth,
    required this.buttonDisabled,
    required this.isLoading,
    required this.resetError,
    required this.submit,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final validator = AuthValidator(localization: localization);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    const double textFieldSpacing = 20;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SelectableText(
          localization
              .profile_page_password_update_section_new_password_description,
          style: responsiveValue.isMobile
              ? themeData.textTheme.bodySmall
              : themeData.textTheme.bodyMedium),
      const SizedBox(height: textFieldSpacing),
      FormTextfield(
          controller: passwordTextController,
          disabled: false,
          placeholder: localization
              .profile_page_password_update_section_new_password_textfield_placeholder,
          onChanged: resetError,
          onFieldSubmitted: () => submit,
          validator: validator.validatePassword,
          obscureText: true),
      const SizedBox(height: textFieldSpacing),
      FormTextfield(
          controller: passwordRepeatTextController,
          disabled: false,
          placeholder: localization
              .profile_page_password_update_section_new_password_repeat_textfield_placeholder,
          onChanged: resetError,
          onFieldSubmitted: () => submit,
          validator: (val) {
            return validator.validatePasswordRepeat(
                val, passwordTextController.text);
          },
          obscureText: true),
      const SizedBox(height: textFieldSpacing * 2),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PrimaryButton(
              title: localization
                  .profile_page_password_update_section_new_password_confirm_button_text,
              width: responsiveValue.isMobile
                  ? maxWidth - textFieldSpacing
                  : maxWidth / 2 - textFieldSpacing,
              disabled: buttonDisabled,
              isLoading: isLoading,
              onTap: () {
                submit();
              })
        ],
      ),
    ]);
  }
}
