// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/core/helpers/auth_validator.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class EmailSectionExpandablePassword extends StatelessWidget {
  final TextEditingController passwordTextController;
  final double maxWidth;
  final bool buttonDisabled;
  final Function resetError;
  final Function submit;

  const EmailSectionExpandablePassword({
    Key? key,
    required this.passwordTextController,
    required this.maxWidth,
    required this.buttonDisabled,
    required this.resetError,
    required this.submit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final validator = AuthValidator(localization: localization);
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
          localization
              .profile_page_email_section_change_email_password_description,
          style: responsiveValue.isMobile
              ? themeData.textTheme.bodySmall
              : themeData.textTheme.bodyMedium),
      const SizedBox(height: 16),
      TextFormField(
        controller: passwordTextController,
        onChanged: (_) {
          resetError();
        },
        onFieldSubmitted: (_) {
          submit();
        },
        validator: validator.validatePassword,
        obscureText: true,
        style: responsiveValue.isMobile
            ? themeData.textTheme.bodySmall
            : themeData.textTheme.bodyMedium,
        decoration: InputDecoration(labelText: localization.login_password),
      ),
      const SizedBox(height: 40),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PrimaryButton(
              title: localization
                  .profile_page_email_section_change_email_password_continue_button_title,
              width:
                  responsiveValue.isMobile ? maxWidth - 20 : maxWidth / 2 - 20,
              disabled: buttonDisabled,
              onTap: () {
                submit();
              })
        ],
      )
    ]);
  }
}
