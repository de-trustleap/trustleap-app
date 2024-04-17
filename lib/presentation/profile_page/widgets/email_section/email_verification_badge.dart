// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class EmailVerificationBadge extends StatelessWidget {
  final EmailVerificationState state;

  const EmailVerificationBadge({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    return Container(
        decoration: BoxDecoration(
            color: state == EmailVerificationState.verified
                ? themeData.colorScheme.primary.withOpacity(0.3)
                : themeData.colorScheme.errorContainer,
            border: Border.all(
                color: state == EmailVerificationState.verified
                    ? themeData.colorScheme.primary
                    : themeData.colorScheme.error),
            borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
              state == EmailVerificationState.verified
                  ? localization
                      .profile_page_email_section_verification_badge_verified
                  : localization
                      .profile_page_email_section_verification_badge_unverified,
              style: themeData.textTheme.bodyLarge!.copyWith(
                  color: state == EmailVerificationState.verified
                      ? themeData.colorScheme.primary
                      : themeData.colorScheme.error,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ));
  }
}
