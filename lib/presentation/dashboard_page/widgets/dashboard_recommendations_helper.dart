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
      AppLocalizations localization,
      String? companyUserId) {
    final items = <DropdownMenuItem<String?>>[];

    // "Alle" Option (always first)
    items.add(DropdownMenuItem<String?>(
      value: null,
      child: Text(localization.dashboard_recommendations_all_promoter),
    ));

    // Separate company user and other promoters
    PromoterRecommendations? companyUserEntry;
    final List<PromoterRecommendations> otherPromoters = [];

    for (final promoterRec in promoterRecommendations) {
      if (companyUserId != null &&
          promoterRec.promoter.id.value == companyUserId) {
        companyUserEntry = promoterRec;
      } else {
        otherPromoters.add(promoterRec);
      }
    }

    // Add company user entry if exists (second position)
    if (companyUserEntry != null) {
      items.add(DropdownMenuItem<String?>(
        value: companyUserEntry.promoter.id.value,
        child: Text(localization.dashboard_recommendations_own_recommendations),
      ));
    }

    // Sort other promoters alphabetically by display name
    otherPromoters.sort((a, b) {
      final nameA =
          "${a.promoter.firstName ?? ''} ${a.promoter.lastName ?? ''}".trim();
      final nameB =
          "${b.promoter.firstName ?? ''} ${b.promoter.lastName ?? ''}".trim();

      final displayNameA = nameA.isNotEmpty
          ? nameA
          : localization.dashboard_recommendations_missing_promoter_name;
      final displayNameB = nameB.isNotEmpty
          ? nameB
          : localization.dashboard_recommendations_missing_promoter_name;

      return displayNameA.compareTo(displayNameB);
    });

    // Add sorted promoters
    for (final promoterRec in otherPromoters) {
      final promoter = promoterRec.promoter;
      final name =
          "${promoter.firstName ?? ''} ${promoter.lastName ?? ''}".trim();
      final displayName = name.isNotEmpty
          ? name
          : localization.dashboard_recommendations_missing_promoter_name;

      items.add(DropdownMenuItem<String?>(
        value: promoter.id.value,
        child: Text(displayName),
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
