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

  String? validateLandingPageInitialInformation(String? input) {
    if (input == null || input.isEmpty) {
      return localization.landingpage_validate_initial_information;
    } else {
      return null;
    }
  }
}
// TODO: TESTS HINZUFÜGEN