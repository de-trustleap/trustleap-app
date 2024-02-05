// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String title;
  final Function onTap;

  const AuthButton({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return InkResponse(
        onTap: () => onTap(),
        child: Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
                color: themeData.colorScheme.primary,
                borderRadius: BorderRadius.circular(8)),
            child: Center(
                child: Text(title,
                    style: themeData.textTheme.headlineLarge!.copyWith(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4)))));
  }
}
