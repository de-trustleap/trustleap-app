import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:flutter/material.dart';

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
    final responsiveValue = ResponsiveHelper.of(context);
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
