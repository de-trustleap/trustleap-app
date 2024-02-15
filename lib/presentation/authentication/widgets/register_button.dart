// ignore_for_file: public_member_api_docs, sort_constructors_first
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

    return Row(
      children: [
        Text("Du hast kein Konto? ",
            style: themeData.textTheme.headlineLarge!.copyWith(fontSize: 16)),
        InkResponse(
            onTap: () => onTap(),
            child: Text("Jetzt Registrieren",
                style: themeData.textTheme.headlineLarge!.copyWith(
                    fontSize: 16, color: themeData.colorScheme.secondary)))
      ],
    );
  }
}
