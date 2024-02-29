// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/presentation/profile_page/widgets/email_section/email_verification_badge.dart';
import 'package:flutter/material.dart';

class EmailSectionMobile extends StatelessWidget {
  final String? email;
  final bool isEmailVerified;
  final Function editEmailPressed;

  const EmailSectionMobile({
    Key? key,
    this.email,
    required this.isEmailVerified,
    required this.editEmailPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("E-Mail",
          style: themeData.textTheme.headlineLarge!.copyWith(fontSize: 16)),
      const SizedBox(height: 8),
      Row(children: [
        Text(email ?? "",
            style: themeData.textTheme.headlineLarge!.copyWith(fontSize: 16)),
        const SizedBox(width: 8),
        IconButton(
            onPressed: () => {editEmailPressed()},
            icon: Icon(Icons.edit,
                color: themeData.colorScheme.secondary, size: 22))
      ]),
      const SizedBox(height: 16),
      Text("Status",
          style: themeData.textTheme.headlineLarge!.copyWith(fontSize: 16)),
      const SizedBox(height: 8),
      EmailVerificationBadge(
          state: isEmailVerified
              ? EmailVerificationState.verified
              : EmailVerificationState.unverified)
    ]);
  }
}
