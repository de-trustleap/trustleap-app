import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class PromoterEditNoDataView extends StatelessWidget {
  const PromoterEditNoDataView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(localization.edit_promoter_no_data_title,
              style: themeData.textTheme.bodyLarge),
          const SizedBox(height: 40),
          Text(localization.edit_promoter_no_data_subtitle,
              style: themeData.textTheme.bodyMedium)
        ]);
  }
}
