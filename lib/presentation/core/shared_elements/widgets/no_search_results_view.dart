import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:flutter/material.dart';

class NoSearchResultsView extends StatelessWidget {
  final String title;
  final String description;
  const NoSearchResultsView(
      {super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveHelper.of(context);

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 60, color: themeData.colorScheme.secondary),
          const SizedBox(height: 16),
          SelectableText(title,
              style: themeData.textTheme.headlineLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: responsiveValue.isMobile ? 20 : 24)),
          const SizedBox(height: 16),
          SelectableText(description,
              style: themeData.textTheme.headlineLarge,
              textAlign: TextAlign.center),
        ]);
  }
}
