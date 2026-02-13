import 'package:finanzbegleiter/core/helpers/date_time_formatter.dart';
import 'package:finanzbegleiter/features/promoter/domain/promoter.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/promoter_avatar.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/status_badge.dart';
import 'package:flutter/material.dart';

class PromoterDetailProfileCard extends StatelessWidget {
  final Promoter promoter;

  const PromoterDetailProfileCard({super.key, required this.promoter});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final isRegistered = promoter.registered == true;
    final fullName =
        '${promoter.firstName ?? ''} ${promoter.lastName ?? ''}'.trim();

    return CardContainer(
      maxWidth: double.infinity,
      child: Column(
        children: [
          PromoterAvatar(
            thumbnailDownloadURL: promoter.thumbnailDownloadURL,
            firstName: promoter.firstName,
            lastName: promoter.lastName,
            size: 120,
          ),
          const SizedBox(height: 16),
          if (fullName.isNotEmpty)
            Text(
              fullName,
              style: themeData.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          if (promoter.email != null) ...[
            const SizedBox(height: 4),
            Text(
              promoter.email!,
              style: themeData.textTheme.bodyMedium?.copyWith(
                color: themeData.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 12),
          StatusBadge(
            isPositive: isRegistered,
            label: isRegistered
                ? localization.promoter_overview_registration_badge_registered
                : localization
                    .promoter_overview_registration_badge_unregistered,
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          if (promoter.birthDate != null)
            _buildDetailRow(
              themeData,
              Icons.cake_outlined,
              localization.promoter_detail_birthday,
              promoter.birthDate!,
            ),
          if (isRegistered && promoter.createdAt != null)
            _buildDetailRow(
              themeData,
              Icons.schedule_outlined,
              localization.promoter_detail_member_since,
              DateTimeFormatter().getStringFromDate(context, promoter.createdAt!),
            ),
          if (!isRegistered && promoter.expiresAt != null)
            _buildDetailRow(
              themeData,
              Icons.timer_outlined,
              localization.promoter_detail_expires_at,
              DateTimeFormatter()
                  .getStringFromDate(context, promoter.expiresAt!),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
      ThemeData themeData, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20,
              color: themeData.colorScheme.onSurface.withValues(alpha: 0.5)),
          const SizedBox(width: 12),
          Text(
            label,
            style: themeData.textTheme.bodyMedium?.copyWith(
              color: themeData.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: themeData.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
