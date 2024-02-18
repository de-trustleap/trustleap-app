// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final Function onTap;

  const RegisterButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Row(
      children: [
        Text(localization.login_register_text,
            style: themeData.textTheme.headlineLarge!.copyWith(fontSize: 16)),
        InkResponse(
            onTap: () => onTap(),
            child: Text(localization.login_register_linktitle,
                style: themeData.textTheme.headlineLarge!.copyWith(
                    fontSize: 16, color: themeData.colorScheme.secondary)))
      ],
    );
  }
}
