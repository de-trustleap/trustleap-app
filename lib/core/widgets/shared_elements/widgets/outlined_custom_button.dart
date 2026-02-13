// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class OutlinedCustomButton extends StatelessWidget {
  final String title;
  final double width;
  final Function? onTap;
  final Color? color;

  const OutlinedCustomButton({
    super.key,
    required this.title,
    this.onTap,
    this.width = double.infinity,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final effectiveColor = color ?? themeData.colorScheme.secondary;

    return InkWell(
      onTap: () => onTap!(),
      child: Container(
        height: 40,
        width: width,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: effectiveColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: themeData.textTheme.bodySmall!.copyWith(
              color: effectiveColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
