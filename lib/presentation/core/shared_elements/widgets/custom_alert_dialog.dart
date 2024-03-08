// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String actionButtonTitle;
  final Function actionButtonAction;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.actionButtonTitle,
    required this.actionButtonAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return AlertDialog(
        actions: [
          TextButton(
              onPressed: () => actionButtonAction(),
              child: Text(actionButtonTitle,
                  style: themeData.textTheme.headlineLarge!.copyWith(
                      fontSize: 16, color: themeData.colorScheme.secondary)))
        ],
        title: Text(title,
            style: themeData.textTheme.headlineLarge!
                .copyWith(fontSize: 22, fontWeight: FontWeight.bold)),
        contentPadding: const EdgeInsets.all(20),
        content: Text(message,
            style: themeData.textTheme.headlineLarge!.copyWith(fontSize: 16)));
  }
}
