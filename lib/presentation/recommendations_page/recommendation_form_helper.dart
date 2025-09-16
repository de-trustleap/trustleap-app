import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_reason.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
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
    final resetTime = user.recommendationCounterResetAt!;
    final difference = resetTime.difference(now);

    if (difference.inHours < 24) {
      final hours = difference.inHours;
      if (hours <= 0) return null;
      return localization.recommendations_limit_reset_hours(hours);
    } else {
      final days = difference.inDays;
      if (days <= 0) return null;
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

  RecommendationItem createRecommendationItem({
    required String leadName,
    required String promoterName,
    required String serviceProviderName,
    required RecommendationReason selectedReason,
    required List<RecommendationReason> reasons,
    required CustomUser? currentUser,
    required CustomUser? parentUser,
  }) {
    return RecommendationItem(
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
}
