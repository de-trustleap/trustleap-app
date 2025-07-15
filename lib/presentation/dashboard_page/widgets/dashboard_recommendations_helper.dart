import 'package:finanzbegleiter/application/dashboard/recommendation/dashboard_recommendations_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/promoter_recommendations.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class DashboardRecommendationsHelper {
  /// Creates dropdown items for promoter selection including an "Alle" option
  static List<DropdownMenuItem<String?>> getPromoterItems(
      List<PromoterRecommendations> promoterRecommendations,
      AppLocalizations localization) {
    final items = <DropdownMenuItem<String?>>[];

    // "Alle" Option
    items.add(DropdownMenuItem<String?>(
      value: null,
      child: Text(localization.dashboard_recommendations_all_promoter),
    ));

    // Promoter Options
    for (final promoterRec in promoterRecommendations) {
      final promoter = promoterRec.promoter;
      final displayName =
          "${promoter.firstName ?? ''} ${promoter.lastName ?? ''}".trim();

      items.add(DropdownMenuItem<String?>(
        value: promoter.id.value,
        child: Text(displayName.isNotEmpty
            ? displayName
            : localization.dashboard_recommendations_missing_promoter_name),
      ));
    }

    return items;
  }

  /// Filters recommendations based on selected promoter and user role
  static List<UserRecommendation> getFilteredRecommendations({
    required DashboardRecommendationsGetRecosSuccessState state,
    required String? selectedPromoterId,
    required Role userRole,
  }) {
    // If no promoter selected or user is promoter, return all recommendations
    if (selectedPromoterId == null || userRole != Role.company) {
      return state.recommendation;
    }

    // Filter by selected promoter
    if (state.promoterRecommendations != null) {
      try {
        final selectedPromoterRec = state.promoterRecommendations!.firstWhere(
          (promoterRec) => promoterRec.promoter.id.value == selectedPromoterId,
        );
        return selectedPromoterRec.recommendations;
      } catch (e) {
        // Promoter not found, return empty list instead of throwing
        return [];
      }
    }

    return state.recommendation;
  }
}
