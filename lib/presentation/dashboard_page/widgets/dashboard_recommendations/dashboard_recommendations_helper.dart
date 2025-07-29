import 'package:finanzbegleiter/application/dashboard/recommendation/dashboard_recommendations_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/promoter_recommendations.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
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
    List<UserRecommendation> recommendations;

    // First filter by promoter
    if (selectedPromoterId == null || userRole != Role.company) {
      recommendations = state.recommendation;
    } else {
      // Filter by selected promoter
      if (state.promoterRecommendations != null) {
        try {
          final selectedPromoterRec = state.promoterRecommendations!.firstWhere(
            (promoterRec) =>
                promoterRec.promoter.id.value == selectedPromoterId,
          );
          recommendations = selectedPromoterRec.recommendations;
        } catch (e) {
          return [];
        }
      } else {
        recommendations = state.recommendation;
      }
    }

    // Then filter by landing page if selected
    if (selectedLandingPageId != null && state.allLandingPages != null) {
      // Find the landing page name for the selected ID
      final selectedLandingPage = state.allLandingPages!
          .where((lp) => lp.id.value == selectedLandingPageId)
          .firstOrNull;

      if (selectedLandingPage != null && selectedLandingPage.name != null) {
        // Filter recommendations where reason matches landing page name
        recommendations = recommendations
            .where(
                (rec) => rec.recommendation?.reason == selectedLandingPage.name)
            .toList();
      }
    }

    return recommendations;
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
    final now = DateTime.now();
    DateTime startDate;

    switch (timePeriod) {
      case TimePeriod.day:
        startDate = now.subtract(const Duration(hours: 24));
        break;
      case TimePeriod.week:
        startDate = now.subtract(const Duration(days: 7));
        break;
      case TimePeriod.month:
      case TimePeriod.year:
        startDate = DateTime(now.year, now.month - 1, now.day);
        break;
    }

    final count = recommendations.where((rec) {
      final createdAt = rec.recommendation?.createdAt;
      return createdAt != null && createdAt.isAfter(startDate);
    }).length;

    switch (timePeriod) {
      case TimePeriod.day:
        return localization.dashboard_recommendations_last_24_hours(count);
      case TimePeriod.week:
        return localization.dashboard_recommendations_last_7_days(count);
      case TimePeriod.month:
      case TimePeriod.year:
        return localization.dashboard_recommendations_last_month(count);
    }
  }

  static RecommendationTrend calculateTrend(
      {required DashboardRecommendationsGetRecosSuccessState state,
      required String? selectedPromoterId,
      required Role userRole,
      required TimePeriod timePeriod,
      String? selectedLandingPageId,
      int? statusLevel,
      DateTime? now}) {
    final recommendations = getFilteredRecommendations(
      state: state,
      selectedPromoterId: selectedPromoterId,
      userRole: userRole,
      selectedLandingPageId: selectedLandingPageId,
    );

    final currentTime = now ?? DateTime.now();
    DateTime currentPeriodStart;
    DateTime previousPeriodStart;
    DateTime previousPeriodEnd;

    switch (timePeriod) {
      case TimePeriod.day:
        currentPeriodStart = currentTime.subtract(const Duration(hours: 24));
        previousPeriodStart = currentTime.subtract(const Duration(hours: 48));
        previousPeriodEnd = currentTime.subtract(const Duration(hours: 24));
        break;
      case TimePeriod.week:
        currentPeriodStart = currentTime.subtract(const Duration(days: 7));
        previousPeriodStart = currentTime.subtract(const Duration(days: 14));
        previousPeriodEnd = currentTime.subtract(const Duration(days: 7));
        break;
      case TimePeriod.month:
      case TimePeriod.year:
        currentPeriodStart = DateTime(currentTime.year, currentTime.month, 1);
        final previousMonth =
            DateTime(currentTime.year, currentTime.month - 1, 1);
        previousPeriodStart = previousMonth;
        previousPeriodEnd = DateTime(currentTime.year, currentTime.month, 1);
        break;
    }

    int currentCount = 0;
    int previousCount = 0;

    for (final rec in recommendations) {
      final createdAt = rec.recommendation?.createdAt;
      if (createdAt != null) {
        // Check if recommendation matches the status level filter
        bool matchesStatusLevel = true;
        if (statusLevel != null) {
          final recStatusLevel = rec.recommendation?.statusLevel;
          if (recStatusLevel != null) {
            // For archived recommendations (successful/failed), they count for all status levels
            // because they have gone through all the previous stages
            if (recStatusLevel == StatusLevel.successful ||
                recStatusLevel == StatusLevel.failed) {
              // Archived recommendations count for all status levels since they completed the process
              matchesStatusLevel = true;
            } else {
              // Active recommendations: check if status level is at or below the selected level
              matchesStatusLevel = recStatusLevel.index + 1 <= statusLevel;
            }
          }
        }

        if (matchesStatusLevel) {
          if (createdAt.isAfter(currentPeriodStart)) {
            currentCount++;
          } else if (createdAt.isAfter(previousPeriodStart) &&
              createdAt.isBefore(previousPeriodEnd)) {
            previousCount++;
          }
        }
      }
    }

    double percentageChange = 0.0;
    if (previousCount > 0) {
      percentageChange = ((currentCount - previousCount) / previousCount * 100);
    } else if (currentCount > 0) {
      percentageChange = 100.0;
    }

    return RecommendationTrend(
      currentPeriodCount: currentCount,
      previousPeriodCount: previousCount,
      percentageChange: percentageChange,
      isIncreasing: percentageChange > 0,
      isDecreasing: percentageChange < 0,
    );
  }
}

class RecommendationTrend {
  final int currentPeriodCount;
  final int previousPeriodCount;
  final double percentageChange;
  final bool isIncreasing;
  final bool isDecreasing;

  const RecommendationTrend({
    required this.currentPeriodCount,
    required this.previousPeriodCount,
    required this.percentageChange,
    required this.isIncreasing,
    required this.isDecreasing,
  });

  bool get isStable => !isIncreasing && !isDecreasing;
}
