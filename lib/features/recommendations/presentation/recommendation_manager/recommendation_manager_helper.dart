// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/core/helpers/date_time_formatter.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class RecommendationManagerHelper {
  final AppLocalizations localization;

  RecommendationManagerHelper({
    required this.localization,
  });

  String getRecommendationDateText(
      BuildContext context, RecommendationItem recommendation) {
    if (recommendation.lastUpdated != null) {
      return DateTimeFormatter()
          .getStringFromDate(context, recommendation.lastUpdated!);
    } else {
      return DateTimeFormatter()
          .getStringFromDate(context, recommendation.createdAt);
    }
  }

  String getExpiresInDaysCount(DateTime expiresAt, {DateTime? now}) {
    final current = now ?? DateTime.now();
    final Duration difference = expiresAt.difference(current);
    final int daysRemaining = difference.inDays;

    if (daysRemaining == 1) {
      return "$daysRemaining ${localization.recommendation_manager_expired_day}";
    } else {
      return "$daysRemaining ${localization.recommendation_manager_expired_days}";
    }
  }

  String getDateText(BuildContext context, DateTime timestamp) {
    return DateTimeFormatter().getStringFromDate(context, timestamp);
  }

  String? getStringFromArchivedStatus(bool? success) {
    if (success == null) {
      return null;
    }
    if (success) {
      return localization.recommendation_manager_status_level_5;
    } else {
      return localization.recommendation_manager_status_level_6;
    }
  }

  String? getStringFromStatusLevel(StatusLevel? statusLevel) {
    if (statusLevel == null) {
      return null;
    }
    switch (statusLevel) {
      case StatusLevel.recommendationSend:
        return localization.recommendation_manager_status_level_1;
      case StatusLevel.linkClicked:
        return localization.recommendation_manager_status_level_2;
      case StatusLevel.contactFormSent:
        return localization.recommendation_manager_status_level_3;
      case StatusLevel.appointment:
        return localization.recommendation_manager_status_level_4;
      case StatusLevel.successful:
        return localization.recommendation_manager_status_level_5;
      case StatusLevel.failed:
        return localization.recommendation_manager_status_level_6;
    }
  }
}
