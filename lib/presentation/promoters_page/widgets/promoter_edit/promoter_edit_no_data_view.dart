import 'package:flutter/material.dart';

class PromoterEditNoDataView extends StatelessWidget {
  const PromoterEditNoDataView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Keine Daten gefunden", style: themeData.textTheme.bodyLarge),
          const SizedBox(height: 40),
          Text("Zu diesem Promoter wurden keine Daten gefunden",
              style: themeData.textTheme.bodyMedium)
        ]);
  }
}
