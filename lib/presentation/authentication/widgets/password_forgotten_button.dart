// ignore_for_file: public_member_api_docs, sort_constructors_first
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

    return Row(children: [
      Text("Haben Sie ihr ",
          style: themeData.textTheme.headlineLarge!.copyWith(fontSize: 16)),
      InkWell(
          onTap: () => onTap(),
          child: Text("Passwort vergessen?",
              style: themeData.textTheme.headlineLarge!.copyWith(
                  fontSize: 16, color: themeData.colorScheme.secondary)))
    ]);
  }
}
