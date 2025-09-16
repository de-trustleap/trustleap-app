// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class FormErrorView extends StatelessWidget {
  final String message;

  const FormErrorView({
    super.key,
    required this.message,
  });

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
          child: Row(
            children: [
              Icon(
                Icons.warning,
                color: themeData.colorScheme.error,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SelectableText(message,
                    style: themeData.textTheme.bodyLarge!.copyWith(
                        color: themeData.colorScheme.error,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ));
  }
}
