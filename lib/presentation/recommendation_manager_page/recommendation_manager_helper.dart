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
      return "$daysRemaining Tag";
    } else {
      return "$daysRemaining Tagen";
    }
  }

  String? getStringFromStatusLevel(int? statusLevel) {
    if (statusLevel == null) {
      return null;
    }
    switch (statusLevel) {
      case 0:
        return "Empfehlung ausgesprochen";
      case 1:
        return "Link geklickt";
      case 2:
        return "Kontakt aufgenommen";
      case 3:
        return "Empfehlung terminiert";
      case 4:
        return "Abgeschlossen";
      case 5:
        return "Nicht abgeschlossen";
      default:
        return null;
    }
  }
}
