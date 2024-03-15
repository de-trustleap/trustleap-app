// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/authentication/auth_validator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class ProfilePasswordUpdateNew extends StatelessWidget {
  final TextEditingController passwordTextController;
  final TextEditingController passwordRepeatTextController;
  final double maxWidth;
  final Function resetError;
  final Function submit;

  const ProfilePasswordUpdateNew({
    Key? key,
    required this.passwordTextController,
    required this.passwordRepeatTextController,
    required this.maxWidth,
    required this.resetError,
    required this.submit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final validator = AuthValidator(localization: localization);
    const double textFieldSpacing = 20;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
          localization
              .profile_page_password_update_section_new_password_description,
          style: themeData.textTheme.headlineLarge!.copyWith(fontSize: 16)),
      const SizedBox(height: textFieldSpacing),
      TextFormField(
        controller: passwordTextController,
        onChanged: (_) {
          resetError();
        },
        onFieldSubmitted: (_) => submit(),
        validator: validator.validatePassword,
        obscureText: true,
        decoration: InputDecoration(
            labelText: localization
                .profile_page_password_update_section_new_password_textfield_placeholder),
      ),
      const SizedBox(height: textFieldSpacing),
      TextFormField(
        controller: passwordRepeatTextController,
        onChanged: (_) {
          resetError();
        },
        onFieldSubmitted: (_) => submit(),
        validator: (val) {
          return validator.validatePasswordRepeat(
              val, passwordTextController.text);
        },
        obscureText: true,
        decoration: InputDecoration(
            labelText: localization
                .profile_page_password_update_section_new_password_repeat_textfield_placeholder),
      ),
      const SizedBox(height: textFieldSpacing * 2),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PrimaryButton(
              title: localization
                  .profile_page_password_update_section_new_password_confirm_button_text,
              width: maxWidth / 2 - textFieldSpacing,
              onTap: () {
                submit();
              })
        ],
      ),
    ]);
  }
}
