// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/helpers/date_time_formatter.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';

class AuthValidator {
  final AppLocalizations localization;

  AuthValidator({required this.localization});

  String? validateEmail(String? input) {
    const emailRegex =
        r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";

    if (input == null || input.isEmpty) {
      return localization.auth_validation_missing_email;
    } else if (RegExp(emailRegex).hasMatch(input.trim())) {
      return null;
    } else {
      return localization.auth_validation_invalid_email;
    }
  }

  String? validatePassword(String? input) {
    if (input == null || input.isEmpty) {
      return localization.auth_validation_missing_password;
    } else {
      return null;
    }
  }

  String? validatePasswordRepeat(String? input, String? otherPassword) {
    if (input == null || input.isEmpty) {
      return localization.auth_validation_confirm_password;
    } else if (otherPassword != input) {
      return localization.auth_validation_matching_passwords;
    } else {
      return null;
    }
  }

  String? validateFirstName(String? input) {
    if (input == null || input.isEmpty) {
      return localization.auth_validation_missing_firstname;
    } else if (input.length > 60) {
      return localization.auth_validation_long_firstname;
    } else {
      return null;
    }
  }

  String? validateLastName(String? input) {
    if (input == null || input.isEmpty) {
      return localization.auth_validation_missing_lastname;
    } else if (input.length > 60) {
      return localization.auth_validation_long_lastname;
    } else {
      return null;
    }
  }

  String? validateBirthDate(String? input) {
    if (input == null || input.isEmpty) {
      return localization.auth_validation_missing_birthdate;
    } else if (!DateTimeFormatter().stringIsValidDate(input)) {
      return localization.auth_validation_invalid_date;
    } else if (DateTimeFormatter().dateIsParsable(input) &&
        !_isAdult(DateTime.parse(DateTimeFormatter().prepareDateStringForParser(input)))) {
      return localization.auth_validation_invalid_birthdate;
    } else {
      return null;
    }
  }

  String? validatePostcode(String? input) {
    if (input == null || input.isEmpty) {
      return null;
    } else if (isNumeric(input)) {
      return null;
    } else {
      return localization.auth_validation_invalid_postcode;
    }
  }

  String? validateGender(Gender? input) {
    if (input == null || input == Gender.none) {
      return "Geben Sie bitte ihr Geschlecht an";
    } else {
      return null;
    }
  }

  String? validateCode(String? input) {
    if (input == null || input.isEmpty) {
      return "Geben Sie bitte ihren Registrierungscode an";
    } else {
      return null;
    }
  }

  bool _isAdult(DateTime date) {
    final DateTime today = DateTime.now();
    final DateTime adultDate = DateTime(
      date.year + 18,
      date.month,
      date.day,
    );
    return adultDate.isBefore(today);
  }

  bool isNumeric(String s) {
    return int.tryParse(s) != null;
  }
}
