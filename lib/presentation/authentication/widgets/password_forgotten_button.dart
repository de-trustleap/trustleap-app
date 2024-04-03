// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class PasswordForgottenButton extends StatelessWidget {
  final Function onTap;

  const PasswordForgottenButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Row(children: [
      Text(localization.login_password_forgotten_text,
          style: themeData.textTheme.bodyMedium),
      InkWell(
          onTap: () => onTap(),
          child: Text(localization.login_password_forgotten_linktext,
              style: themeData.textTheme.bodyMedium!
                  .copyWith(color: themeData.colorScheme.secondary)))
    ]);
  }
}
