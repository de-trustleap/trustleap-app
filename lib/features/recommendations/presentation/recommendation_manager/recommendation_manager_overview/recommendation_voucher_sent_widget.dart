import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/info_card.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class RecommendationVoucherSentWidget extends StatelessWidget {
  const RecommendationVoucherSentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final primary = themeData.colorScheme.primary;

    return InfoCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.mark_email_read_outlined, size: 16, color: primary),
          const SizedBox(width: 8),
          Expanded(
            child: SelectableText(
              localization.compensation_voucher_sent_description,
              style: themeData.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
