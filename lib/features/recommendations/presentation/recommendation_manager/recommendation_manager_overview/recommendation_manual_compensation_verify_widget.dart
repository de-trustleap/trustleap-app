import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/clickable_link.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/info_card.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/subtle_button.dart';
import 'package:finanzbegleiter/features/recommendations/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_compensation.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/widgets/compensation_dialog.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RecommendationManualCompensationVerifyWidget extends StatelessWidget {
  final UserRecommendation recommendation;

  const RecommendationManualCompensationVerifyWidget({
    super.key,
    required this.recommendation,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final cubit = Modular.get<RecommendationManagerTileCubit>();
    final primary = themeData.colorScheme.primary;

    return InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.card_giftcard, size: 16, color: primary),
              const SizedBox(width: 8),
              Expanded(
                child: SelectableText(
                  localization.compensation_manual_issued_description,
                  style: themeData.textTheme.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          BlocBuilder<RecommendationManagerTileCubit,
              RecommendationManagerTileState>(
            bloc: cubit,
            builder: (context, state) {
              final isLoading =
                  state is RecommendationCompensationLoadingState;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IntrinsicWidth(
                    child: SubtleButton(
                      title: localization.compensation_manual_confirm_button,
                      icon: Icons.check,
                      isLoading: isLoading,
                      disabled: isLoading,
                      onTap: () => cubit.setCompensation(recommendation,
                          RecommendationCompensationStatus.manualConfirmed),
                    ),
                  ),
                  if (!isLoading) ...[
                    const SizedBox(height: 12),
                    ClickableLink(
                      title: localization.compensation_manual_change_link,
                      fontSize: 12,
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          child: CompensationDialog(
                            recommendation: recommendation,
                            initialOption: CompensationOption.manual,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
