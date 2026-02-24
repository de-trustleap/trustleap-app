import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/landing_pages/presentation/widgets/landing_page_creator/landing_page_template_placeholder.dart';
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
  static const int maxRecommendationsPerMonth = 6;

  bool isRecommendationLimitReached(CustomUser? currentUser) {
    if (currentUser?.role != Role.promoter) {
      return false;
    }
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

  String? _getFirstName(String? fullName) {
    if (fullName == null) return null;
    return fullName.trim().split(" ").first;
  }

  String? _getLastName(String? fullName) {
    if (fullName == null) return null;
    final parts = fullName.trim().split(" ");
    return parts.length > 1 ? parts.skip(1).join(" ") : "";
  }

  String parseTemplate(RecommendationItem item, String template) {
    final providerFirst = _getFirstName(item.serviceProviderName);
    final providerLast = _getLastName(item.serviceProviderName);
    final promoterFirst = _getFirstName(item.promoterName);
    final promoterLast = _getLastName(item.promoterName);

    final replacements = {
      LandingPageTemplatePlaceholder.receiverName: item.displayName,
      LandingPageTemplatePlaceholder.providerFirstName: providerFirst,
      LandingPageTemplatePlaceholder.providerLastName: providerLast,
      LandingPageTemplatePlaceholder.providerName:
          item.serviceProviderName,
      LandingPageTemplatePlaceholder.promoterFirstName: promoterFirst,
      LandingPageTemplatePlaceholder.promoterLastName: promoterLast,
      LandingPageTemplatePlaceholder.promoterName: item.promoterName,
    };

    var result = template;
    replacements.forEach((key, value) {
      result = result.replaceAll(key, value ?? "");
    });
    result += "\n[LINK]";
    return result;
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
