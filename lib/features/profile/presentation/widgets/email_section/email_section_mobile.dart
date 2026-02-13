// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/profile/presentation/widgets/email_section/email_verification_badge.dart';
import 'package:flutter/material.dart';

class EmailSectionMobile extends StatelessWidget {
  final String? email;
  final bool isEmailVerified;
  final Function editEmailPressed;

  const EmailSectionMobile({
    super.key,
    this.email,
    required this.isEmailVerified,
    required this.editEmailPressed,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SelectableText(localization.profile_page_email_section_email,
          style: themeData.textTheme.bodySmall),
      const SizedBox(height: 8),
      Row(children: [
        SelectableText(email ?? "", style: themeData.textTheme.bodySmall),
        const SizedBox(width: 8),
        IconButton(
            onPressed: () => {editEmailPressed()},
            icon: Icon(Icons.edit,
                color: themeData.colorScheme.secondary, size: 22))
      ]),
      const SizedBox(height: 16),
      SelectableText(localization.profile_page_email_section_status,
          style: themeData.textTheme.bodySmall),
      const SizedBox(height: 8),
      EmailVerificationBadge(
          state: isEmailVerified
              ? EmailVerificationState.verified
              : EmailVerificationState.unverified)
    ]);
  }
}
