import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/calendly_connection_widget.dart';
import 'package:flutter/material.dart';

class CalendlySection extends StatelessWidget {
  const CalendlySection({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 24,
                color: themeData.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                localization.profile_page_calendly_integration_title,
                style: themeData.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            localization.profile_page_calendly_integration_description,
            style: themeData.textTheme.bodyMedium?.copyWith(
              color: themeData.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          CalendlyConnectionWidget(
            isRequired: false,
            selectedEventTypeUrl: null,
            onEventTypeSelected: (_) {},
            showEventTypes: false,
            showDisconnectButton: true,
          ),
        ],
      ),
    );
  }
}