// ignore_for_file: public_member_api_docs, sort_constructors_first
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
    return InkWell(
        onTap: () => onTap(),
        child: Text("Link zur Email-Verifikation erneut senden",
            style: themeData.textTheme.headlineLarge!.copyWith(
                fontSize: 16,
                decoration: TextDecoration.underline,
                decorationColor: themeData.colorScheme.secondary,
                color: themeData.colorScheme.secondary)));
  }
}
