import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/calendly_connection_widget.dart';
import 'package:flutter/material.dart';

class CalendlySection extends StatelessWidget {
  final double? maxWidth;

  const CalendlySection({super.key, this.maxWidth});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return CardContainer(
      maxWidth: maxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            localization.profile_page_calendly_integration_title,
            style: themeData.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SelectableText(
            localization.profile_page_calendly_integration_description,
            style: themeData.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          const CalendlyConnectionWidget(
            isRequired: false,
            selectedEventTypeUrl: null,
            showEventTypes: false,
            showDisconnectButton: true,
            onConnectionStatusChanged: null,
          ),
        ],
      ),
    );
  }
}
