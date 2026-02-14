import 'package:finanzbegleiter/core/helpers/date_time_formatter.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/status_badge.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/subtle_button.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageDetailHeader extends StatelessWidget {
  final LandingPage landingPage;
  final VoidCallback onPreviewPressed;
  final VoidCallback onOpenBuilderPressed;

  const LandingPageDetailHeader({
    super.key,
    required this.landingPage,
    required this.onPreviewPressed,
    required this.onOpenBuilderPressed,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Row with Badge
        if (responsiveValue.largerThan(MOBILE)) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: _buildTitleSection(themeData, localization, context)),
              const SizedBox(width: 16),
              _buildActionButtons(themeData, localization, responsiveValue),
            ],
          ),
        ] else ...[
          _buildTitleSection(themeData, localization, context),
          const SizedBox(height: 16),
          _buildActionButtons(themeData, localization, responsiveValue),
        ],
      ],
    );
  }

  Widget _buildTitleSection(
      ThemeData themeData, AppLocalizations localization, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: SelectableText(
                landingPage.name ?? '',
                style: themeData.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            StatusBadge(
              isPositive: landingPage.isActive ?? false,
              label: landingPage.isActive ?? false
                  ? localization.landing_page_detail_status_active
                  : localization.landing_page_detail_status_inactive,
            ),
          ],
        ),
        const SizedBox(height: 4),
        _buildDateInfo(themeData, localization, context),
      ],
    );
  }

  Widget _buildDateInfo(
      ThemeData themeData, AppLocalizations localization, BuildContext context) {
    final dateFormatter = DateTimeFormatter();
    final createdText = landingPage.createdAt != null
        ? "${localization.landing_page_detail_created_on} ${dateFormatter.getStringFromDate(context, landingPage.createdAt!)}"
        : "";
    final updatedText = landingPage.lastUpdatedAt != null
        ? " - ${localization.landing_page_detail_last_modified} ${dateFormatter.getStringFromDate(context, landingPage.lastUpdatedAt!)}"
        : "";

    return SelectableText(
      "$createdText$updatedText",
      style: themeData.textTheme.bodySmall?.copyWith(
        color: themeData.colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildActionButtons(
      ThemeData themeData, AppLocalizations localization, ResponsiveBreakpointsData responsiveValue) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SubtleButton(
          title: localization.landing_page_detail_preview,
          icon: Icons.visibility_outlined,
          onTap: onPreviewPressed,
          backgroundColor: Colors.white,
          textColor: themeData.colorScheme.onSurface,
        ),
        if (responsiveValue.isDesktop) ...[
          const SizedBox(width: 12),
          SubtleButton(
            title: localization.landing_page_detail_open_builder,
            icon: Icons.edit_outlined,
            onTap: onOpenBuilderPressed,
          ),
        ],
      ],
    );
  }
}
