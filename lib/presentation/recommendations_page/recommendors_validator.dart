import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';

class RecommendorsValidator {
  final AppLocalizations localization;

  RecommendorsValidator({required this.localization});

  String? validateRecommendorsName(String? input) {
    if (input == null || input.isEmpty) {
      return localization.recommendations_validation_missing_recommendor_name;
    } else {
      return null;
    }
  }

  String? validatePromotersName(String? input) {
    if (input == null || input.isEmpty) {
      return localization.recommendations_validation_missing_promoter_name;
    } else {
      return null;
    }
  }

  String? validateReason(RecommendationReason? input) {
    if (input == null || input == RecommendationReason.none) {
      return localization.recommendations_validation_missing_reason;
    } else {
      return null;
    }
  }
}
