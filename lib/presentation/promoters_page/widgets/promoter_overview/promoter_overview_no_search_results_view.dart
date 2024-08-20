import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PromoterOverviewNoSearchResultsView extends StatelessWidget {
  const PromoterOverviewNoSearchResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 60, color: themeData.colorScheme.secondary),
          const SizedBox(height: 16),
          SelectableText(localization.promoter_overview_no_search_results_title,
              style: themeData.textTheme.headlineLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: responsiveValue.isMobile ? 20 : 24)),
          const SizedBox(height: 16),
          SelectableText(
              localization.promoter_overview_no_search_results_subtitle,
              style: themeData.textTheme.headlineLarge,
              textAlign: TextAlign.center),
        ]);
  }
}
