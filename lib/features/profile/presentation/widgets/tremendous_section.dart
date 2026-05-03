import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/features/tremendous/presentation/widgets/tremendous_connection_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class TremendousSection extends StatelessWidget {
  final double? maxWidth;

  const TremendousSection({super.key, this.maxWidth});

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
            localization.profile_page_tremendous_integration_title,
            style: themeData.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SelectableText(
            localization.profile_page_tremendous_integration_description,
            style: themeData.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          const TremendousConnectionWidget(),
        ],
      ),
    );
  }
}
