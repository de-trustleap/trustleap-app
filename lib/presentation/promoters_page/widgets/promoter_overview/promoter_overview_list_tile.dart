// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/promoter_avatar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/status_badge.dart';
import 'package:finanzbegleiter/presentation/promoters_page/promoter_helper.dart';
import 'package:flutter/material.dart';

class PromoterOverviewListTile extends StatelessWidget {
  final Promoter promoter;

  const PromoterOverviewListTile({
    super.key,
    required this.promoter,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: themeData.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: themeData.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          PromoterAvatar(
            thumbnailDownloadURL: (promoter.registered == true)
                ? promoter.thumbnailDownloadURL
                : null,
            firstName: promoter.firstName,
            lastName: promoter.lastName,
            size: 40,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  '${promoter.firstName ?? ''} ${promoter.lastName ?? ''}'
                      .trim(),
                  style: themeData.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (promoter.email != null)
                  SelectableText(
                    promoter.email!,
                    style: themeData.textTheme.bodySmall?.copyWith(
                      color: themeData.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (promoter.registered != null)
                StatusBadge(
                  isPositive: promoter.registered!,
                  label: promoter.registered!
                      ? localization
                          .promoter_overview_registration_badge_registered
                      : localization
                          .promoter_overview_registration_badge_unregistered,
                ),
              if (PromoterHelper(localization: localization)
                      .getPromoterDateText(context, promoter) !=
                  null) ...[
                const SizedBox(height: 4),
                Text(
                  PromoterHelper(localization: localization)
                      .getPromoterDateText(context, promoter)!,
                  style: themeData.textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    color: themeData.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
