// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final double width;
  final Function onTap;

  const PrimaryButton(
      {Key? key,
      required this.title,
      required this.onTap,
      this.width = double.infinity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return InkWell(
        onTap: () => onTap(),
        child: Container(
            height: 40,
            width: width,
            decoration: BoxDecoration(
                color: themeData.colorScheme.primary,
                borderRadius: BorderRadius.circular(8)),
            child: Center(
                child: Text(title,
                textAlign: TextAlign.center,
                    style: themeData.textTheme.headlineLarge!.copyWith(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1)))));
  }
}
