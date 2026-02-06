import 'package:finanzbegleiter/application/promoter/promoter/promoter_cubit.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/promoter_avatar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LandingPageDetailPromoterTile extends StatelessWidget {
  final Promoter promoter;
  final VoidCallback onRemove;

  const LandingPageDetailPromoterTile({
    super.key,
    required this.promoter,
    required this.onRemove,
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
            thumbnailDownloadURL: promoter.thumbnailDownloadURL,
            firstName: promoter.firstName,
            lastName: promoter.lastName,
            size: 40,
          ),
          const SizedBox(width: 12),
          _buildNameAndEmail(themeData),
          const SizedBox(width: 12),
          StatusBadge(
            isPositive: promoter.registered == true,
            label: promoter.registered == true
                ? localization.promoter_overview_registration_badge_registered
                : localization
                    .promoter_overview_registration_badge_unregistered,
          ),
          const SizedBox(width: 12),
          _buildActions(themeData, localization),
        ],
      ),
    );
  }

  Widget _buildNameAndEmail(ThemeData themeData) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            '${promoter.firstName ?? ''} ${promoter.lastName ?? ''}'.trim(),
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
