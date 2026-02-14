// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';

class FeedbackValidator {
  final AppLocalizations localization;

  FeedbackValidator({
    required this.localization,
  });

  String? validateTitle(String? input) {
    if (input == null || input.trim().isEmpty) {
      return localization.feedback_title_required;
    }
    if (input.trim().length > 100) {
      return localization.feedback_title_too_long;
    }
    return null;
  }

  String? validateDescription(String? input) {
    if (input == null || input.trim().isEmpty) {
      return localization.feedback_description_required;
    }
    if (input.trim().length > 1000) {
      return localization.feedback_description_too_long;
    }
    return null;
  }

  String? validateEmail(String? input) {
    // Email is optional, but if provided it must be valid
    if (input == null || input.trim().isEmpty) {
      return null;
    }
    if (RegExp(emailRegex).hasMatch(input.trim())) {
      return null;
    } else {
      return localization.auth_validation_invalid_email;
    }
  }
}
