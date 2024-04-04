// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class PromoterRegistrationBadge extends StatelessWidget {
  final PromoterRegistrationState state;

  const PromoterRegistrationBadge({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    return Container(
        decoration: BoxDecoration(
            color: state == PromoterRegistrationState.registered
                ? themeData.colorScheme.primary.withOpacity(0.3)
                : themeData.colorScheme.errorContainer,
            border: Border.all(
                color: state == PromoterRegistrationState.registered
                    ? themeData.colorScheme.primary
                    : themeData.colorScheme.error),
            borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Text(
              state == PromoterRegistrationState.registered
                  ? localization.promoter_overview_registration_badge_registered
                  : localization.promoter_overview_registration_badge_unregistered,
              style: themeData.textTheme.bodyLarge!.copyWith(
                  color: state == PromoterRegistrationState.registered
                      ? themeData.colorScheme.primary
                      : themeData.colorScheme.error,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ));
  }
}
