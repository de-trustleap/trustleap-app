// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/core/helpers/auth_validator.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class ProfilePasswordUpdateReauth extends StatelessWidget {
  final TextEditingController passwordTextController;
  final double maxWidth;
  final bool buttonDisabled;
  final Function resetError;
  final Function submit;

  const ProfilePasswordUpdateReauth({
    Key? key,
    required this.passwordTextController,
    required this.maxWidth,
    required this.buttonDisabled,
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
      Text(localization.profile_page_password_update_section_reauth_description,
          style: themeData.textTheme.bodyMedium),
      const SizedBox(height: textFieldSpacing),
      TextFormField(
          controller: passwordTextController,
          onChanged: (_) {
            resetError();
          },
          onFieldSubmitted: (_) => submit(),
          validator: validator.validatePassword,
          obscureText: true,
          style: themeData.textTheme.titleMedium,
          decoration: InputDecoration(
              labelText: localization
                  .profile_page_password_update_section_reauth_password_textfield_placeholder)),
      const SizedBox(height: textFieldSpacing * 2),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PrimaryButton(
              title: localization
                  .profile_page_password_update_section_reauth_continue_button_title,
              width: maxWidth / 2 - textFieldSpacing,
              disabled: buttonDisabled,
              onTap: () {
                submit();
              })
        ],
      ),
    ]);
  }
}
