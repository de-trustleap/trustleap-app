import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/recommendations/domain/campaign_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/personalized_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_status_counts.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_reason.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class RecommendationFormHelper {
  bool isRecommendationLimitReached(CustomUser? currentUser) {
    if (currentUser?.role != Role.promoter) {
      return false;
    }
    const int maxRecommendationsPerMonth = 6;
    final int currentCount = currentUser?.recommendationCountLast30Days ?? 0;
    return currentCount >= maxRecommendationsPerMonth;
  }

  bool hasActiveReasons(List<RecommendationReason> reasons) {
    return reasons.any((reason) => reason.isActive == true);
  }

  Duration? calculateTimeUntilReset(DateTime now, DateTime resetDateTime) {
    // Berechne bis 0 Uhr des Tages NACH dem recommendationCounterResetAt
    final resetDate =
        DateTime(resetDateTime.year, resetDateTime.month, resetDateTime.day);
    final nextMidnight = resetDate.add(const Duration(days: 1));
    final difference = nextMidnight.difference(now);

    if (difference.inHours <= 0) return null;
    return difference;
  }

  String? getRecommendationLimitResetText(
    BuildContext context,
    CustomUser? currentUser,
    CustomUser? parentUser,
  ) {
    final user = currentUser ?? parentUser;
    if (user?.recommendationCountLast30Days == null ||
        user!.recommendationCountLast30Days! <= 0 ||
        user.recommendationCounterResetAt == null) {
      return null;
    }

    final localization = AppLocalizations.of(context);
    final now = DateTime.now();
    final resetDateTime = user.recommendationCounterResetAt!;

    final difference = calculateTimeUntilReset(now, resetDateTime);
    if (difference == null) return null;

    if (difference.inHours < 24) {
      final hours = difference.inHours;
      return localization.recommendations_limit_reset_hours(hours);
    } else {
      final days = difference.inDays;
      return localization.recommendations_limit_reset_days(days);
    }
  }

  String getReasonValues(
    List<RecommendationReason> reasons,
    RecommendationReason? selectedReason,
  ) {
    final reason = selectedReason ??
        reasons.firstWhere(
          (e) {
            return e.isActive == true;
          },
          orElse: () => const RecommendationReason(
              id: null,
              reason: "null",
              isActive: null,
              promotionTemplate: null),
        );
    return reason.reason as String;
  }

  PersonalizedRecommendationItem createRecommendationItem({
    required String leadName,
    required String promoterName,
    required String serviceProviderName,
    required RecommendationReason selectedReason,
    required List<RecommendationReason> reasons,
    required CustomUser? currentUser,
    required CustomUser? parentUser,
  }) {
    return PersonalizedRecommendationItem(
        id: UniqueID().value,
        name: leadName.trim(),
        reason: selectedReason.reason!,
        landingPageID: selectedReason.id!.value,
        promoterName: promoterName.trim(),
        serviceProviderName: serviceProviderName.trim(),
        defaultLandingPageID: currentUser != null
            ? currentUser.defaultLandingPageID
            : parentUser?.defaultLandingPageID,
        statusLevel: StatusLevel.recommendationSend,
        statusTimestamps: {0: DateTime.now()},
        userID: currentUser?.id.value ?? parentUser?.id.value,
        promoterImageDownloadURL: null,
        promotionTemplate: reasons.firstWhere((e) {
          return e.reason == selectedReason.reason;
        }).promotionTemplate!);
  }

  CampaignRecommendationItem createCampaignRecommendationItem({
    required String campaignName,
    required int campaignDurationDays,
    required String promoterName,
    required String serviceProviderName,
    required RecommendationReason selectedReason,
    required List<RecommendationReason> reasons,
    required CustomUser? currentUser,
    required CustomUser? parentUser,
  }) {
    return CampaignRecommendationItem(
        id: UniqueID().value,
        campaignName: campaignName.trim(),
        campaignDurationDays: campaignDurationDays,
        reason: selectedReason.reason!,
        landingPageID: selectedReason.id!.value,
        promoterName: promoterName.trim(),
        serviceProviderName: serviceProviderName.trim(),
        defaultLandingPageID: currentUser != null
            ? currentUser.defaultLandingPageID
            : parentUser?.defaultLandingPageID,
        userID: currentUser?.id.value ?? parentUser?.id.value,
        promoterImageDownloadURL: null,
        statusCounts: const RecommendationStatusCounts(),
        promotionTemplate: reasons.firstWhere((e) {
          return e.reason == selectedReason.reason;
        }).promotionTemplate!,
        expiresAt: DateTime.now().add(Duration(days: campaignDurationDays)));
  }
}
