// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class FormErrorView extends StatefulWidget {
  final String message;
  final bool autoScroll;

  const FormErrorView({
    super.key,
    required this.message,
    this.autoScroll = true,
  });

  @override
  State<FormErrorView> createState() => _FormErrorViewState();
}

class _FormErrorViewState extends State<FormErrorView> {
  @override
  void initState() {
    super.initState();
    if (widget.autoScroll) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: 0.1,
          );
        }
      });
    }
  }

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
                child: SelectableText(widget.message,
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
