// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AuthErrorView extends StatelessWidget {
  final String message;

  const AuthErrorView({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
        decoration: BoxDecoration(
            color: themeData.colorScheme.errorContainer,
            border: Border.all(color: themeData.colorScheme.error),
            borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(message,
              style: themeData.textTheme.bodyLarge!.copyWith(
                  color: themeData.colorScheme.error,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ));
  }
}
