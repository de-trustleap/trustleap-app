// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/core/helpers/auth_validator.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class EmailSectionExpandableEmail extends StatelessWidget {
  final TextEditingController emailTextController;
  final double maxWidth;
  final bool buttonDisabled;
  final Function resetError;
  final Function submit;

  const EmailSectionExpandableEmail({
    super.key,
    required this.emailTextController,
    required this.maxWidth,
    required this.buttonDisabled,
    required this.resetError,
    required this.submit,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final validator = AuthValidator(localization: localization);
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(localization.profile_page_email_section_description,
          style: responsiveValue.isMobile
              ? themeData.textTheme.bodySmall
              : themeData.textTheme.bodyMedium),
      const SizedBox(height: 16),
      TextFormField(
        controller: emailTextController,
        keyboardType: TextInputType.emailAddress,
        onChanged: (_) {
          resetError();
        },
        onFieldSubmitted: (_) {
          submit();
        },
        validator: validator.validateEmail,
        style: responsiveValue.isMobile
            ? themeData.textTheme.bodySmall
            : themeData.textTheme.bodyMedium,
        decoration: InputDecoration(labelText: localization.login_email),
      ),
      const SizedBox(height: 40),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PrimaryButton(
              title: localization
                  .profile_page_email_section_change_email_button_title,
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
