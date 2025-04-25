// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/core/helpers/date_time_formatter.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
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

  String? getStringFromStatusLevel(int? statusLevel) {
    if (statusLevel == null) {
      return null;
    }
    switch (statusLevel) {
      case 0:
        return localization.recommendation_manager_status_level_1;
      case 1:
        return localization.recommendation_manager_status_level_2;
      case 2:
        return localization.recommendation_manager_status_level_3;
      case 3:
        return localization.recommendation_manager_status_level_4;
      case 4:
        return localization.recommendation_manager_status_level_5;
      case 5:
        return localization.recommendation_manager_status_level_6;
      default:
        return null;
    }
  }
}
