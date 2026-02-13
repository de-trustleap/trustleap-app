import 'package:finanzbegleiter/features/promoter/application/promoter/promoter_cubit.dart';
import 'package:finanzbegleiter/features/promoter/domain/promoter.dart';
import 'package:finanzbegleiter/features/promoter/domain/promoter_stats.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/promoter_avatar.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/status_badge.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/subtle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageDetailPromoterTile extends StatelessWidget {
  final Promoter promoter;
  final PromoterStats stats;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const LandingPageDetailPromoterTile({
    super.key,
    required this.promoter,
    required this.stats,
    required this.onRemove,
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
            ? _buildMobileLayout(themeData, localization)
            : _buildDesktopLayout(themeData, localization),
      ),
    );
  }

  Widget _buildDesktopLayout(ThemeData themeData, AppLocalizations localization) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              PromoterAvatar(
                thumbnailDownloadURL: promoter.thumbnailDownloadURL,
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
              StatusBadge(
                isPositive: promoter.registered == true,
                label: promoter.registered == true
                    ? localization.promoter_overview_registration_badge_registered
                    : localization.promoter_overview_registration_badge_unregistered,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 80,
          child: Column(
            children: [
              SelectableText(
                localization.landing_page_detail_promoter_shares,
                style: themeData.textTheme.labelSmall?.copyWith(
                  color: themeData.colorScheme.onSurfaceVariant,
                ),
              ),
              SelectableText(
                stats.shares.toString(),
                style: themeData.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 80,
          child: Column(
            children: [
              SelectableText(
                localization.landing_page_detail_promoter_conversions,
                style: themeData.textTheme.labelSmall?.copyWith(
                  color: themeData.colorScheme.onSurfaceVariant,
                ),
              ),
              SelectableText(
                stats.conversions.toString(),
                style: themeData.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _buildConversionRate(themeData, localization),
        const SizedBox(width: 12),
        _buildActions(themeData, localization),
        const SizedBox(width: 8),
        Icon(
          Icons.chevron_right,
          color: themeData.colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }

  Widget _buildMobileLayout(ThemeData themeData, AppLocalizations localization) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  PromoterAvatar(
                    thumbnailDownloadURL: promoter.thumbnailDownloadURL,
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
                  StatusBadge(
                    isPositive: promoter.registered == true,
                    label: promoter.registered == true
                        ? localization
                            .promoter_overview_registration_badge_registered
                        : localization
                            .promoter_overview_registration_badge_unregistered,
                  ),
                ],
              ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatColumn(
                themeData,
                localization.landing_page_detail_promoter_shares,
                stats.shares.toString(),
              ),
            ),
            Expanded(
              child: _buildStatColumn(
                themeData,
                localization.landing_page_detail_promoter_conversions,
                stats.conversions.toString(),
              ),
            ),
            Expanded(
              child: _buildStatColumn(
                themeData,
                localization.landing_page_detail_promoter_conversion_rate,
                stats.formattedConversionRate,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
              SubtleButton(
                title: localization.landing_page_detail_remove_promoter,
                icon: Icons.person_remove_outlined,
                backgroundColor: themeData.colorScheme.error.withValues(alpha: 0.1),
                textColor: themeData.colorScheme.error,
                onTap: onRemove,
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

  Widget _buildConversionRate(
    ThemeData themeData,
    AppLocalizations localization,
  ) {
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          SelectableText(
            localization.landing_page_detail_promoter_conversion_rate,
            style: themeData.textTheme.labelSmall?.copyWith(
              color: themeData.colorScheme.onSurfaceVariant,
            ),
          ),
          SelectableText(
            stats.formattedConversionRate,
            style: themeData.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(
    ThemeData themeData,
    AppLocalizations localization,
  ) {
    return BlocBuilder<PromoterCubit, PromoterState>(
      bloc: Modular.get<PromoterCubit>(),
      builder: (context, state) {
        final isLoading = state is PromoterLoadingState &&
            state.promoterId == promoter.id.value;

        if (isLoading) {
          return const LoadingIndicator(size: 24);
        }

        return IconButton(
          icon: Icon(
            Icons.person_remove_outlined,
            color: themeData.colorScheme.error,
          ),
          tooltip: localization.landing_page_detail_remove_promoter,
          onPressed: onRemove,
        );
      },
    );
  }
}
