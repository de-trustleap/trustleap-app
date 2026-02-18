import 'package:cached_network_image/cached_network_image.dart';
import 'package:finanzbegleiter/core/helpers/date_time_formatter.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page.dart';
import 'package:finanzbegleiter/features/promoter/domain/promoter_stats.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PromoterDetailLandingPageTile extends StatelessWidget {
  final LandingPage landingPage;
  final PromoterStats stats;
  final VoidCallback onTap;

  const PromoterDetailLandingPageTile({
    super.key,
    required this.landingPage,
    required this.stats,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final isCompact =
        ResponsiveBreakpoints.of(context).smallerOrEqualTo(TABLET);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
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
        child: isCompact
            ? _buildMobileLayout(themeData, localization, context)
            : _buildDesktopLayout(themeData, localization, context),
      ),
    );
  }

  Widget _buildDesktopLayout(ThemeData themeData, AppLocalizations localization,
      BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              _buildThumbnail(themeData),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      landingPage.name ?? '',
                      style: themeData.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (landingPage.createdAt != null)
                      Text(
                        '${localization.promoter_detail_created_at} ${DateTimeFormatter().getStringFromDate(context, landingPage.createdAt!)}',
                        style: themeData.textTheme.bodySmall?.copyWith(
                          color: themeData.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 80,
          child: StatusBadge(
            isPositive: landingPage.isActive == true,
            label: landingPage.isActive == true
                ? localization.landing_page_detail_status_active
                : localization.landing_page_detail_status_inactive,
          ),
        ),
        SizedBox(
          width: 100,
          child: Text(
            stats.shares.toString(),
            style: themeData.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: 100,
          child: Text(
            stats.conversions.toString(),
            style: themeData.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: 100,
          child: Text(
            stats.formattedConversionRate,
            style: themeData.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: 40,
          child: Icon(
            Icons.chevron_right,
            color: themeData.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(ThemeData themeData, AppLocalizations localization,
      BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildThumbnail(themeData),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          landingPage.name ?? '',
                          style: themeData.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        if (landingPage.createdAt != null)
                          Text(
                            '${localization.promoter_detail_created_at} ${DateTimeFormatter().getStringFromDate(context, landingPage.createdAt!)}',
                            style: themeData.textTheme.bodySmall?.copyWith(
                              color: themeData.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  StatusBadge(
                    isPositive: landingPage.isActive == true,
                    label: landingPage.isActive == true
                        ? localization.landing_page_detail_status_active
                        : localization.landing_page_detail_status_inactive,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatColumn(
                      themeData,
                      localization.promoter_detail_chart_recommendations,
                      stats.shares.toString(),
                    ),
                  ),
                  Expanded(
                    child: _buildStatColumn(
                      themeData,
                      localization.promoter_detail_conversions,
                      stats.conversions.toString(),
                    ),
                  ),
                  Expanded(
                    child: _buildStatColumn(
                      themeData,
                      localization.promoter_detail_conversion_rate,
                      stats.formattedConversionRate,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Icon(
          Icons.chevron_right,
          color: themeData.colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }

  Widget _buildStatColumn(
    ThemeData themeData,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: themeData.textTheme.labelSmall?.copyWith(
            color: themeData.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: themeData.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnail(ThemeData themeData) {
    if (landingPage.thumbnailDownloadURL != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: CachedNetworkImage(
          imageUrl: landingPage.thumbnailDownloadURL!,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          placeholder: (_, __) => _buildPlaceholderThumbnail(themeData),
          errorWidget: (_, __, ___) => _buildPlaceholderThumbnail(themeData),
        ),
      );
    }
    return _buildPlaceholderThumbnail(themeData);
  }

  Widget _buildPlaceholderThumbnail(ThemeData themeData) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: themeData.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        Icons.web_outlined,
        color: themeData.colorScheme.primary,
        size: 20,
      ),
    );
  }
}
// TODO: RECOMMENDATON FORM KAMPAGNE IMPLEMENTIEREN
// TODO: RECOMMENDATIONMANAGER ANPASSEN
// TODO: ANALYTICS ANPASSEN
