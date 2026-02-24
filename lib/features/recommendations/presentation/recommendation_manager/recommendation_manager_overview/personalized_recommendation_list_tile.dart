import 'package:finanzbegleiter/features/recommendations/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/features/recommendations/domain/personalized_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_base_tile.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_overview/personalized_recommendation_list_tile_title.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_overview/recommendation_manager_list_tile_icon_row.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_overview/recommendation_manager_status_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PersonalizedRecommendationListTile extends StatelessWidget {
  final UserRecommendation recommendation;
  final bool isPromoter;
  final Function(UserRecommendation) onAppointmentPressed;
  final Function(UserRecommendation) onFinishedPressed;
  final Function(UserRecommendation) onFailedPressed;
  final Function(String, String, String) onDeletePressed;
  final Function(UserRecommendation) onFavoritePressed;
  final Function(UserRecommendation) onPriorityChanged;
  final Function(UserRecommendation, bool, bool, bool, bool) onUpdate;

  const PersonalizedRecommendationListTile({
    super.key,
    required this.recommendation,
    required this.isPromoter,
    required this.onAppointmentPressed,
    required this.onFinishedPressed,
    required this.onFailedPressed,
    required this.onDeletePressed,
    required this.onFavoritePressed,
    required this.onPriorityChanged,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final responsiveValue = ResponsiveHelper.of(context);
    final cubit = Modular.get<RecommendationManagerTileCubit>();

    return RecommendationManagerBaseTile(
      recommendation: recommendation,
      onFavoritePressed: onFavoritePressed,
      onUpdate: onUpdate,
      buildTitle: (reco) => PersonalizedRecommendationListTileTitle(
        recommendation: reco,
        isPromoter: isPromoter,
        onFavoritePressed: onFavoritePressed,
        cubit: cubit,
      ),
      buildContent: (reco, isLoading) {
        final personalizedReco =
            reco.recommendation is PersonalizedRecommendationItem
                ? reco.recommendation as PersonalizedRecommendationItem
                : null;
        return [
          RecommendationManagerStatusProgressIndicator(
            level: personalizedReco?.statusLevel ??
                StatusLevel.recommendationSend,
            statusTimestamps: personalizedReco?.statusTimestamps ?? {},
          ),
          const SizedBox(height: 16),
          RecommendationManagerListTileIconRow(
            key: ValueKey(
                "${reco.id}-${personalizedReco?.statusLevel}"),
            recommendation: reco,
            onAppointmentPressed: onAppointmentPressed,
            onFinishedPressed: onFinishedPressed,
            onFailedPressed: onFailedPressed,
            onDeletePressed: onDeletePressed,
          ),
        ];
      },
      buildBottomRowTrailing: (reco) => [
        _getPriorityIcon(reco.priority, themeData),
        PopupMenuButton<RecommendationPriority>(
          tooltip:
              localization.recommendation_manager_select_priority_tooltip,
          itemBuilder: (context) => [
            _getPopupMenuItem(RecommendationPriority.high, themeData,
                localization, responsiveValue),
            _getPopupMenuItem(RecommendationPriority.medium, themeData,
                localization, responsiveValue),
            _getPopupMenuItem(RecommendationPriority.low, themeData,
                localization, responsiveValue),
          ],
          onSelected: (value) =>
              onPriorityChanged(reco.copyWith(priority: value)),
        ),
      ],
    );
  }

  Widget _getPriorityIcon(
      RecommendationPriority? priority, ThemeData themeData) {
    switch (priority) {
      case RecommendationPriority.low:
        return Icon(Icons.arrow_downward,
            size: 24, color: themeData.colorScheme.primary);
      case RecommendationPriority.high:
        return Icon(Icons.arrow_upward,
            size: 24, color: themeData.colorScheme.error);
      default:
        return const Icon(Icons.remove, size: 24, color: Colors.lightBlue);
    }
  }

  PopupMenuItem<RecommendationPriority> _getPopupMenuItem(
      RecommendationPriority priority,
      ThemeData themeData,
      AppLocalizations localization,
      ResponsiveBreakpointsData responsiveValue) {
    return PopupMenuItem(
      value: priority,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        _getPriorityIcon(priority, themeData),
        const SizedBox(width: 8),
        Text(priority.getLocalizedLabel(localization),
            style: responsiveValue.isMobile
                ? themeData.textTheme.bodySmall
                : themeData.textTheme.bodyMedium)
      ]),
    );
  }
}
