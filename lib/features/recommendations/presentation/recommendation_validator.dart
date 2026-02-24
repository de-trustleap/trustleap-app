import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';

class RecommendationValidator {
  final AppLocalizations localization;

  RecommendationValidator({required this.localization});

  String? validateLeadsName(String? input) {
    if (input == null || input.isEmpty) {
      return localization.recommendations_validation_missing_lead_name;
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

  String? validateReason(String? input) {
    if (input == null) {
      return localization.recommendations_validation_missing_reason;
    } else {
      return null;
    }
  }

  String? validateCampaignName(String? input) {
    if (input == null || input.isEmpty) {
      return localization.recommendations_validation_missing_campaign_name;
    } else {
      return null;
    }
  }

  String? validateCampaignDuration(String? input) {
    if (input == null || input.isEmpty) {
      return localization.recommendations_validation_invalid_campaign_duration;
    }
    final value = int.tryParse(input);
    if (value == null || value < 1 || value > 30) {
      return localization.recommendations_validation_invalid_campaign_duration;
    }
    return null;
  }
}
