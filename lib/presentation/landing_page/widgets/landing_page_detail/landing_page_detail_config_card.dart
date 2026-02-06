import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/subtle_button.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_detail/landing_page_legal_information_section.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageDetailConfigCard extends StatelessWidget {
  final LandingPage landingPage;

  const LandingPageDetailConfigCard({
    super.key,
    required this.landingPage,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final navigator = CustomNavigator.of(context);

    return CardContainer(
      maxWidth: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              SelectableText(
                localization.landing_page_detail_page_configuration,
                style: themeData.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              SubtleButton(
                title: localization.landing_page_detail_edit_configuration,
                icon: Icons.edit_outlined,
                onTap: () => navigator.pushNamed(
                  "${RoutePaths.homePath}${RoutePaths.landingPageCreatorPath}",
                  arguments: {"landingPage": landingPage},
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Content
          if (responsiveValue.largerThan(MOBILE)) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildLeftColumn(themeData, localization)),
                const SizedBox(width: 24),
                Expanded(child: _buildRightColumn(themeData, localization)),
              ],
            ),
          ] else ...[
            _buildLeftColumn(themeData, localization),
            const SizedBox(height: 24),
            _buildRightColumn(themeData, localization),
          ],
        ],
      ),
    );
  }

  Widget _buildLeftColumn(ThemeData themeData, AppLocalizations localization) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description
        _buildSectionTitle(
          themeData,
          localization.landing_page_detail_description,
        ),
        const SizedBox(height: 8),
        _buildTextBox(
          themeData,
          landingPage.description ?? '-',
        ),
        const SizedBox(height: 20),

        // Promoter Template Text
        _buildSectionTitle(
          themeData,
          localization.landing_page_detail_promoter_template_text,
        ),
        const SizedBox(height: 8),
        _buildTextBox(
          themeData,
          landingPage.promotionTemplate ?? '-',
        ),
        const SizedBox(height: 20),

        // Landing Page Type
        _buildSectionTitle(
          themeData,
          localization.landing_page_detail_page_type,
        ),
        const SizedBox(height: 8),
        _buildBusinessModelBadge(themeData, localization),
      ],
    );
  }

  Widget _buildRightColumn(ThemeData themeData, AppLocalizations localization) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Contact Options
        _buildSectionTitle(
          themeData,
          localization.landing_page_detail_contact_options,
        ),
        const SizedBox(height: 8),
        _buildContactOptionTile(themeData, localization),
        const SizedBox(height: 20),

        // Legal Information
        LandingPageLegalInformationSection(landingPage: landingPage),
      ],
    );
  }

  Widget _buildSectionTitle(ThemeData themeData, String title) {
    return SelectableText(
      title,
      style: themeData.textTheme.bodySmall?.copyWith(
        color: themeData.colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextBox(ThemeData themeData, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: themeData.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: themeData.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: SelectableText(
        text,
        style: themeData.textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildBusinessModelBadge(
      ThemeData themeData, AppLocalizations localization) {
    final isB2C = landingPage.businessModel == BusinessModel.b2c;
    final label = isB2C
        ? localization.landing_page_detail_type_b2c
        : localization.landing_page_detail_type_b2b;
    final description = isB2C
        ? localization.landing_page_detail_type_b2c_description
        : localization.landing_page_detail_type_b2b_description;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: themeData.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: themeData.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: themeData.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.person_outline,
              color: themeData.colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  label,
                  style: themeData.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SelectableText(
                  description,
                  style: themeData.textTheme.bodySmall?.copyWith(
                    color: themeData.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactOptionTile(
      ThemeData themeData, AppLocalizations localization) {
    String label;
    String description;

    switch (landingPage.contactOption) {
      case ContactOption.calendly:
        label = localization.landing_page_detail_contact_calendly;
        description = localization.landing_page_detail_contact_calendly_description;
        break;
      case ContactOption.contactForm:
        label = localization.landing_page_detail_contact_form;
        description = localization.landing_page_detail_contact_form_description;
        break;
      case ContactOption.both:
        label = localization.landing_page_detail_contact_both;
        description = localization.landing_page_detail_contact_both_description;
        break;
      default:
        label = '-';
        description = '';
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: themeData.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: themeData.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: themeData.colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.contact_mail_outlined,
              color: themeData.colorScheme.secondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  label,
                  style: themeData.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SelectableText(
                  description,
                  style: themeData.textTheme.bodySmall?.copyWith(
                    color: themeData.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
