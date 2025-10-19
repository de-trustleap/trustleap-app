// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final double? maxWidth;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const CardContainer({
    super.key,
    this.maxWidth,
    this.padding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? 600),
        padding: padding ?? const EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3))),
        child: child);
  }
}
