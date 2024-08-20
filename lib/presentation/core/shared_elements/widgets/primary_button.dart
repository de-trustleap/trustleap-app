// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final double width;
  final bool disabled;
  final bool isLoading;
  final Function onTap;

  const PrimaryButton(
      {super.key,
      required this.title,
      required this.onTap,
      this.disabled = false,
      this.isLoading = false,
      this.width = double.infinity});

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
                  color: disabled && !isLoading
                      ? Colors.grey[400]
                      : themeData.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white))
                      : Text(title,
                          textAlign: TextAlign.center,
                          style: themeData.textTheme.bodySmall!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1))))),
    );
  }
}
