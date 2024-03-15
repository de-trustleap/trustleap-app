// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class EmailsectionVerificationLink extends StatelessWidget {
  final Function onTap;

  const EmailsectionVerificationLink({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    return InkWell(
        onTap: () => onTap(),
        child: Text(
            localization
                .profile_page_email_section_resend_verify_email_button_title,
            style: themeData.textTheme.headlineLarge!.copyWith(
                fontSize: 16,
                decoration: TextDecoration.underline,
                decorationColor: themeData.colorScheme.secondary,
                color: themeData.colorScheme.secondary)));
  }
}
