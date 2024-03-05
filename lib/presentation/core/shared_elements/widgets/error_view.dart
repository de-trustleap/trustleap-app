// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String title;
  final String message;
  final Function callback;

  const ErrorView({
    Key? key,
    required this.title,
    required this.message,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.warning, size: 60, color: themeData.colorScheme.error),
            const SizedBox(height: 16),
            Text(title,
                style: themeData.textTheme.headlineLarge!
                    .copyWith(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(message,
                style:
                    themeData.textTheme.headlineLarge!.copyWith(fontSize: 20)),
            const SizedBox(height: 32),
            PrimaryButton(
                title: "Erneut versuchen", onTap: callback, width: 300)
          ]),
    );
  }
}
