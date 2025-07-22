// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';

class FeedbackValidator {
  final AppLocalizations localization;

  FeedbackValidator({
    required this.localization,
  });

  String? validateTitle(String? input) {
    if (input == null || input.trim().isEmpty) {
      return "Titel ist erforderlich"; // TODO: Add to localization
    }
    if (input.trim().length > 100) {
      return "Titel darf maximal 100 Zeichen lang sein"; // TODO: Add to localization
    }
    return null;
  }

  String? validateDescription(String? input) {
    if (input == null || input.trim().isEmpty) {
      return "Beschreibung ist erforderlich"; // TODO: Add to localization
    }
    if (input.trim().length > 1000) {
      return "Beschreibung darf maximal 1000 Zeichen lang sein"; // TODO: Add to localization
    }
    return null;
  }
}