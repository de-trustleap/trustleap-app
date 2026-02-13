import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class RegisterPromoterNoLandingPageView extends StatelessWidget {
  const RegisterPromoterNoLandingPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveHelper.of(context);
    final localization = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.warning,
                size: responsiveValue.isMobile ? 40 : 60,
                color: themeData.colorScheme.error),
            const SizedBox(height: 16),
            SelectableText(localization.register_promoter_no_landingpage_title,
                style: themeData.textTheme.headlineLarge!.copyWith(
                    fontSize: responsiveValue.isMobile ? 20 : 24,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SelectableText(
                localization.register_promoter_no_landingpage_subtitle,
                style: themeData.textTheme.headlineLarge),
          ]),
    );
  }
}
