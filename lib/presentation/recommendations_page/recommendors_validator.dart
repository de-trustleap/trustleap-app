import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';

class RecommendorsValidator {
  final AppLocalizations localization;

  RecommendorsValidator({required this.localization});

  String? validateRecommendorsName(String? input) {
    if (input == null || input.isEmpty) {
      return "Geben Sie bitte einen Namen an";
    } else {
      return null;
    }
  }

  String? validatePromotersName(String? input) {
    if (input == null || input.isEmpty) {
      return "Geben Sie bitte einen Namen an";
    } else {
      return null;
    }
  }

  String? validateReason(RecommendationReason? input) {
    if (input == null || input == RecommendationReason.none) {
      return "Bitte einen Grund angeben";
    } else {
      return null;
    }
  }
}
