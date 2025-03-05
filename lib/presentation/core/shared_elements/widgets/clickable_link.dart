import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ClickableLink extends StatelessWidget {
  final String title;
  final double? fontSize;
  final Function onTap;

  const ClickableLink({
    super.key,
    required this.title,
    this.fontSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    return InkWell(
        onTap: () => onTap(),
        child: Text(title,
            style: themeData.textTheme.bodyMedium!.copyWith(
                fontSize: fontSize != null
                    ? fontSize!
                    : responsiveValue.isMobile
                        ? 14
                        : 16,
                decoration: TextDecoration.underline,
                decorationColor: themeData.colorScheme.secondary,
                color: themeData.colorScheme.secondary)));
  }
}
