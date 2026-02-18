import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/dashboard/domain/chart_trend.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page.dart';
import 'package:finanzbegleiter/features/recommendations/domain/promoter_recommendations.dart';
import 'package:finanzbegleiter/features/recommendations/domain/personalized_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';

class RecommendationsStatistics {
  static List<UserRecommendation> getFilteredRecommendations({
    required List<UserRecommendation> recommendations,
    required String? selectedPromoterId,
    required Role userRole,
    List<PromoterRecommendations>? promoterRecommendations,
    String? selectedLandingPageId,
    List<LandingPage>? allLandingPages,
  }) {
    List<UserRecommendation> result;

    if (selectedPromoterId == null || userRole != Role.company) {
      result = recommendations;
    } else {
      if (promoterRecommendations != null) {
        try {
          final selectedPromoterRec = promoterRecommendations.firstWhere(
            (promoterRec) =>
                promoterRec.promoter.id.value == selectedPromoterId,
          );
          result = selectedPromoterRec.recommendations;
        } catch (e) {
          return [];
        }
      } else {
        result = recommendations;
      }
    }

    if (selectedLandingPageId != null && allLandingPages != null) {
      final selectedLandingPage = allLandingPages
          .where((lp) => lp.id.value == selectedLandingPageId)
          .firstOrNull;

      if (selectedLandingPage != null && selectedLandingPage.name != null) {
        result = result
            .where(
                (rec) => rec.recommendation?.reason == selectedLandingPage.name)
            .toList();
      }
    }

    return result;
  }

  static String getTimePeriodSummaryText({
    required List<UserRecommendation> recommendations,
    required TimePeriod timePeriod,
    required AppLocalizations localization,
  }) {
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
      case TimePeriod.quarter:
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
      case TimePeriod.quarter:
      case TimePeriod.year:
        return localization.dashboard_recommendations_last_month(count);
    }
  }

  static ChartTrend calculateTrend({
    required List<UserRecommendation> recommendations,
    required TimePeriod timePeriod,
    int? statusLevel,
    DateTime? now,
  }) {
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
      case TimePeriod.quarter:
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
        bool matchesStatusLevel = true;
        if (statusLevel != null) {
          final reco = rec.recommendation;
          final recStatusLevel = reco is PersonalizedRecommendationItem ? reco.statusLevel : null;
          if (recStatusLevel != null) {
            if (recStatusLevel == StatusLevel.successful ||
                recStatusLevel == StatusLevel.failed) {
              matchesStatusLevel = true;
            } else {
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
    bool isIncreasing = false;
    bool isDecreasing = false;

    if (previousCount > 0) {
      percentageChange = ((currentCount - previousCount) / previousCount * 100);

      const threshold = 1.0;
      if (percentageChange.abs() > threshold) {
        isIncreasing = percentageChange > 0;
        isDecreasing = percentageChange < 0;
      }
    } else if (currentCount > 0) {
      percentageChange = currentCount * 100.0;
      isIncreasing = true;
    }

    return ChartTrend(
      currentPeriodCount: currentCount,
      previousPeriodCount: previousCount,
      percentageChange: percentageChange,
      isIncreasing: isIncreasing,
      isDecreasing: isDecreasing,
    );
  }
}
