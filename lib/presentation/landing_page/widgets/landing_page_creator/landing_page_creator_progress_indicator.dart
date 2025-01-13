import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class LandingPageCreatorProgressIndicator extends StatelessWidget {
  final int elementsTotal;
  final double progress;
  const LandingPageCreatorProgressIndicator(
      {super.key, required this.progress, required this.elementsTotal});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final int currentStep = (progress * elementsTotal).ceil() + 1;

    return Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                  width: 600, child: LinearProgressIndicator(value: progress)),
            ),
            const SizedBox(height: 8),
            Text(
                localization.landingpage_creation_progress_indicator_text(
                    currentStep, elementsTotal),
                style: themeData.textTheme.bodyMedium)
          ],
        ));
  }
}
