import 'package:flutter/material.dart';

class PromoterOverviewNoSearchResultsView extends StatelessWidget {
  const PromoterOverviewNoSearchResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 60, color: themeData.colorScheme.secondary),
          const SizedBox(height: 16),
          Text("Keine Suchergebnisse",
              style: themeData.textTheme.headlineLarge!
                  .copyWith(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(
              "Sie scheinen noch keine Promoter mit dem gesuchten Namen registriert zu haben.\nÄndern Sie Ihren Suchbegriff um nach anderen Promotern zu suchen.",
              style: themeData.textTheme.headlineLarge!.copyWith(fontSize: 20),
              textAlign: TextAlign.center),
        ]);
  }
}
