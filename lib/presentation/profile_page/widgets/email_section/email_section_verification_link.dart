// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class EmailsectionVerificationLink extends StatelessWidget {
  final Function onTap;

  const EmailsectionVerificationLink({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    return InkWell(
        onTap: () => onTap(),
        child: Text(
            localization
                .profile_page_email_section_resend_verify_email_button_title,
            style: themeData.textTheme.bodyMedium!.copyWith(
                fontSize: responsiveValue.isMobile ? 14 : 16,
                decoration: TextDecoration.underline,
                decorationColor: themeData.colorScheme.secondary,
                color: themeData.colorScheme.secondary)));
  }
}
