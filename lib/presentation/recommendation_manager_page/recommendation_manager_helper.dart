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

  String getExpiresInDaysCount(DateTime expiresAt) {
    final now = DateTime.now();
    final Duration difference = expiresAt.difference(now);
    final int daysRemaining = difference.inDays;
    if (daysRemaining == 1) {
      return "$daysRemaining Tag";
    } else {
      return "$daysRemaining Tagen";
    }
  }
}
