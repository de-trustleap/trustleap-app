// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PasswordForgottenButton extends StatelessWidget {
  final Function onTap;

  const PasswordForgottenButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return Row(children: [
      SelectableText(localization.login_password_forgotten_text,
          style: responsiveValue.isMobile
              ? themeData.textTheme.bodySmall
              : themeData.textTheme.bodyMedium),
      InkWell(
          onTap: () => onTap(),
          child: Text(localization.login_password_forgotten_linktext,
              style: responsiveValue.isMobile
                  ? themeData.textTheme.bodySmall!
                      .copyWith(color: themeData.colorScheme.secondary)
                  : themeData.textTheme.bodyMedium!
                      .copyWith(color: themeData.colorScheme.secondary)))
    ]);
  }
}
