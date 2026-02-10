import 'package:finanzbegleiter/application/dashboard/recommendation/dashboard_recommendations_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/chart_trend.dart';
import 'package:finanzbegleiter/domain/entities/promoter_recommendations.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/domain/statistics/recommendations_statistics.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class DashboardRecommendationsHelper {
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

  static List<UserRecommendation> getFilteredRecommendations({
    required DashboardRecommendationsGetRecosSuccessState state,
    required String? selectedPromoterId,
    required Role userRole,
    String? selectedLandingPageId,
  }) {
    return RecommendationsStatistics.getFilteredRecommendations(
      recommendations: state.recommendation,
      selectedPromoterId: selectedPromoterId,
      userRole: userRole,
      promoterRecommendations: state.promoterRecommendations,
      selectedLandingPageId: selectedLandingPageId,
      allLandingPages: state.allLandingPages,
    );
  }

  static String getTimePeriodSummaryText({
    required DashboardRecommendationsGetRecosSuccessState state,
    required String? selectedPromoterId,
    required Role userRole,
    required TimePeriod timePeriod,
    required AppLocalizations localization,
    String? selectedLandingPageId,
  }) {
    final recommendations = getFilteredRecommendations(
      state: state,
      selectedPromoterId: selectedPromoterId,
      userRole: userRole,
      selectedLandingPageId: selectedLandingPageId,
    );

    return RecommendationsStatistics.getTimePeriodSummaryText(
      recommendations: recommendations,
      timePeriod: timePeriod,
      localization: localization,
    );
  }

  static ChartTrend calculateTrend({
    required DashboardRecommendationsGetRecosSuccessState state,
    required String? selectedPromoterId,
    required Role userRole,
    required TimePeriod timePeriod,
    String? selectedLandingPageId,
    int? statusLevel,
    DateTime? now,
  }) {
    final recommendations = getFilteredRecommendations(
      state: state,
      selectedPromoterId: selectedPromoterId,
      userRole: userRole,
      selectedLandingPageId: selectedLandingPageId,
    );

    return RecommendationsStatistics.calculateTrend(
      recommendations: recommendations,
      timePeriod: timePeriod,
      statusLevel: statusLevel,
      now: now,
    );
  }
}
