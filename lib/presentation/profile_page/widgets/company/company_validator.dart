// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';

class CompanyValidator {
  final AppLocalizations localization;

  CompanyValidator({
    required this.localization,
  });

  String? validateName(String? input) {
    if (input == null || input.isEmpty) {
      return localization.profile_company_validator_missing_name;
    } else {
      return null;
    }
  }

  String? validateIndustry(String? input) {
    if (input == null || input.isEmpty) {
      return localization.profile_company_validator_missing_industry;
    } else {
      return null;
    }
  }

  String? validateAddress(String? input) {
    if (input == null || input.isEmpty) {
      return localization.profile_company_validator_missing_address;
    } else {
      return null;
    }
  }

  String? validatePostCode(String? input) {
    if (input == null || input.isEmpty) {
      return localization.profile_company_validator_missing_postCode;
    } else if (_isNumeric(input)) {
      return null;
    } else {
      return localization.profile_company_validator_invalid_postCode;
    }
  }

  String? validatePlace(String? input) {
    if (input == null || input.isEmpty) {
      return localization.profile_company_validator_missing_place;
    } else {
      return null;
    }
  }

  String? validatePhoneNumber(String? input) {
    const phoneNumberRegex = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    if (input == null || input.isEmpty) {
      return localization.profile_company_validator_missing_phone;
    } else if (RegExp(phoneNumberRegex).hasMatch(input.trim())) {
      return null;
    } else {
      return localization.profile_company_validator_invalid_phone;
    }
  }

  bool _isNumeric(String s) {
    return int.tryParse(s) != null;
  }
}
