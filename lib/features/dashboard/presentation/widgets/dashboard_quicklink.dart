import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/card_container.dart';
import 'package:flutter/material.dart';

class DashboardQuicklink extends StatelessWidget {
  final String text;
  final String buttonText;
  final String path;
  const DashboardQuicklink(
      {super.key,
      required this.text,
      required this.buttonText,
      required this.path});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final navigator = CustomNavigator.of(context);
    return CardContainer(
        maxWidth: 280,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text, maxLines: 2, style: themeData.textTheme.bodySmall),
              const SizedBox(height: 8),
              TextButton(
                  onPressed: () => navigator.navigate(path),
                  child: Text(buttonText,
                      style: themeData.textTheme.bodySmall!
                          .copyWith(color: themeData.colorScheme.secondary)))
            ]));
  }
}
