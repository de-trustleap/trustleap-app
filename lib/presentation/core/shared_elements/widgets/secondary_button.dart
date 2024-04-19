// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String title;
  final double width;
  final bool disabled;
  final Function onTap;

  const SecondaryButton({
    super.key,
    required this.title,
    this.width = double.infinity,
    this.disabled = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return IgnorePointer(
      ignoring: disabled,
      child: InkWell(
          onTap: () => onTap(),
          child: Container(
              height: 40,
              width: width,
              decoration: BoxDecoration(
                  color: disabled
                      ? Colors.grey[400]
                      : themeData.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                  child: Text(title,
                      textAlign: TextAlign.center,
                      style: themeData.textTheme.bodySmall!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1))))),
    );
  }
}
