import 'package:finanzbegleiter/features/recommendations/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/features/recommendations/domain/campaign_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/environment.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_base_tile.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/campaign_recommendation_overview/campaign_recommendation_funnel_indicator.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/campaign_recommendation_overview/campaign_recommendation_list_tile_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CampaignRecommendationListTile extends StatelessWidget {
  final UserRecommendation recommendation;
  final Function(String, String, String) onDeletePressed;
  final Function(UserRecommendation) onFavoritePressed;
  final Function(UserRecommendation, bool, bool, bool, bool) onUpdate;

  const CampaignRecommendationListTile({
    super.key,
    required this.recommendation,
    required this.onDeletePressed,
    required this.onFavoritePressed,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final cubit = Modular.get<RecommendationManagerTileCubit>();

    return RecommendationManagerBaseTile(
      recommendation: recommendation,
      onFavoritePressed: onFavoritePressed,
      onUpdate: onUpdate,
      buildTitle: (reco) => CampaignRecommendationListTileTitle(
        recommendation: reco,
        onFavoritePressed: onFavoritePressed,
        cubit: cubit,
      ),
      buildContent: (reco, isLoading) {
        final campaignReco = reco.recommendation is CampaignRecommendationItem
            ? reco.recommendation as CampaignRecommendationItem
            : null;
        return [
          CampaignRecommendationFunnelIndicator(
            statusCounts: campaignReco?.statusCounts,
          ),
        ];
      },
      buildBottomRowTrailing: (reco) => [
        IconButton(
          tooltip: localization.campaign_manager_copy_link_tooltip,
          onPressed: () {
            final baseURL = Environment().getLandingpageBaseURL();
            final link =
                "$baseURL?p=${reco.recommendation?.promoterName ?? ""}&id=${reco.recoID}";
            Clipboard.setData(ClipboardData(text: link));
            CustomSnackBar.of(context).showCustomSnackBar(
                localization.recommendation_copied_to_clipboard);
          },
          color: Theme.of(context).colorScheme.secondary,
          iconSize: 24,
          icon: const Icon(Icons.copy),
        ),
        IconButton(
          tooltip: localization.campaign_manager_delete_tooltip,
          onPressed: () => onDeletePressed(
            reco.recommendation?.id ?? "",
            reco.recommendation?.userID ?? "",
            reco.id.value,
          ),
          color: Theme.of(context).colorScheme.secondary,
          iconSize: 24,
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }
}
