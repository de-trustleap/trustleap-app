import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class LandingPageStatusBadge extends StatelessWidget {
  final bool isActive;

  const LandingPageStatusBadge({
    super.key,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? themeData.colorScheme.primary.withValues(alpha: 0.1)
            : themeData.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        isActive
            ? localization.landing_page_detail_status_active
            : localization.landing_page_detail_status_inactive,
        style: themeData.textTheme.labelSmall?.copyWith(
          color: isActive
              ? themeData.colorScheme.primary
              : themeData.colorScheme.error,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
