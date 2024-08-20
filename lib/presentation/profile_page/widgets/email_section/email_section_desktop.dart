// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/email_section/email_verification_badge.dart';
import 'package:flutter/material.dart';

class EmailSectionDesktop extends StatelessWidget {
  final String? email;
  final bool isEmailVerified;
  final Function editEmailPressed;

  const EmailSectionDesktop({
    super.key,
    this.email,
    required this.isEmailVerified,
    required this.editEmailPressed,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: const {
          0: FlexColumnWidth(50),
          1: FlexColumnWidth(25),
          2: FlexColumnWidth(25)
        },
        children: [
          TableRow(children: [
            SelectableText(localization.profile_page_email_section_email,
                style: themeData.textTheme.bodyMedium),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SelectableText(
                  localization.profile_page_email_section_status,
                  style: themeData.textTheme.bodyMedium),
            ),
            const SizedBox(width: 8)
          ]),
          const TableRow(children: [
            SizedBox(height: 8),
            SizedBox(height: 8),
            SizedBox(height: 8)
          ]),
          TableRow(children: [
            SelectableText(email ?? "", style: themeData.textTheme.bodyMedium),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: EmailVerificationBadge(
                    state: isEmailVerified
                        ? EmailVerificationState.verified
                        : EmailVerificationState.unverified)),
            IconButton(
                onPressed: () => {editEmailPressed()},
                tooltip: localization.profile_edit_email_tooltip,
                icon: Icon(Icons.edit,
                    color: themeData.colorScheme.secondary, size: 22)),
          ])
        ]);
  }
}
