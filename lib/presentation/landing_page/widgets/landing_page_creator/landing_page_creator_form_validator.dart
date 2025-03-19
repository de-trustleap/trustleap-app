// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';

class LandingPageCreatorFormValidator {
  final AppLocalizations localization;

  LandingPageCreatorFormValidator({
    required this.localization,
  });

  String? validateLandingPageName(String? input) {
    if (input == null || input.isEmpty) {
      return localization.landingpage_validate_LandingPageName;
    } else {
      return null;
    }
  }

  String? validateLandingPageText(String? input) {
    if (input == null || input.isEmpty) {
      return localization.landingpage_validate_LandingPageText;
    } else {
      return null;
    }
  }

  String? validateLandingPageContactEmailAddress(String? input) {
    const emailRegex =
        r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";
    if (input == null || input.isEmpty) {
      return localization.auth_validation_missing_email;
    } else if (RegExp(emailRegex).hasMatch(input.trim())) {
      return null;
    } else {
      return localization.auth_failure_invalid_email;
    }
  }

  String? validateLandingPageImpressum(String? input) {
    if (input == null || input.isEmpty) {
      return localization.landingpage_validate_impressum;
    } else {
      return null;
    }
  }

  String? validateLandingPagePrivacyPolicy(String? input) {
    if (input == null || input.isEmpty) {
      return localization.landingpage_validate_privacy_policy;
    } else {
      return null;
    }
  }
}
