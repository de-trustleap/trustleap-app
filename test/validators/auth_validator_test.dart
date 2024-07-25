import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/helpers/auth_validator.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_validator_test.mocks.dart';

@GenerateMocks([AppLocalizations])
void main() {
  late AuthValidator authValidator;
  late MockAppLocalizations mockLocalizations;

  setUp(() {
    mockLocalizations = MockAppLocalizations();
    authValidator = AuthValidator(localization: mockLocalizations);
  });

  group("AuthValidator_validateEmail", () {
    test("returns missing email error when input is null", () {
      when(mockLocalizations.auth_validation_missing_email)
          .thenReturn("Email is required.");

      final result = authValidator.validateEmail(null);

      expect(result, "Email is required.");
    });

    test("returns missing email error when input is empty", () {
      when(mockLocalizations.auth_validation_missing_email)
          .thenReturn("Email is required.");

      final result = authValidator.validateEmail("");

      expect(result, "Email is required.");
    });

    test("returns invalid email error when input is invalid", () {
      when(mockLocalizations.auth_validation_invalid_email)
          .thenReturn("Invalid email.");

      final result = authValidator.validateEmail("invalid-email");

      expect(result, "Invalid email.");
    });

    test("returns null when input is valid", () {
      final result = authValidator.validateEmail("test@example.com");

      expect(result, null);
    });
  });

  group("AuthValidator_validatePassword", () {
    test("returns missing password error when input is null", () {
      when(mockLocalizations.auth_validation_missing_password)
          .thenReturn("Password is required.");

      final result = authValidator.validatePassword(null);

      expect(result, "Password is required.");
    });

    test("returns missing password error when input is empty", () {
      when(mockLocalizations.auth_validation_missing_password)
          .thenReturn("Password is required.");

      final result = authValidator.validatePassword("");

      expect(result, "Password is required.");
    });

    test("returns null when input is valid", () {
      final result = authValidator.validatePassword("'validpassword");

      expect(result, null);
    });
  });

  group("AuthValidator_validatePasswordRepeat", () {
    test("returns confirm password error when input is null", () {
      when(mockLocalizations.auth_validation_confirm_password)
          .thenReturn("Please confirm your password.");

      final result = authValidator.validatePasswordRepeat(null, "password");

      expect(result, "Please confirm your password.");
    });

    test("returns matching passwords error when passwords do not match", () {
      when(mockLocalizations.auth_validation_matching_passwords)
          .thenReturn("Passwords do not match.");

      final result =
          authValidator.validatePasswordRepeat("password1", "password2");

      expect(result, "Passwords do not match.");
    });

    test("returns null when passwords match", () {
      final result =
          authValidator.validatePasswordRepeat("password", "password");

      expect(result, null);
    });
  });

  group("AuthValidator_validateFirstName", () {
    test("returns missing first name error when input is null", () {
      when(mockLocalizations.auth_validation_missing_firstname)
          .thenReturn("First name is required.");

      final result = authValidator.validateFirstName(null);

      expect(result, "First name is required.");
    });

    test("returns missing first name error when input is empty", () {
      when(mockLocalizations.auth_validation_missing_firstname)
          .thenReturn("First name is required.");

      final result = authValidator.validateFirstName("");

      expect(result, "First name is required.");
    });

    test("returns long first name error when input is too long", () {
      when(mockLocalizations.auth_validation_long_firstname)
          .thenReturn("First name is too long.");

      final result = authValidator.validateFirstName("a" * 61);

      expect(result, "First name is too long.");
    });

    test("returns null when input is valid", () {
      final result = authValidator.validateFirstName("ValidName");

      expect(result, null);
    });
  });

  group("AuthValidator_validateLastName", () {
    test("returns missing last name error when input is null", () {
      when(mockLocalizations.auth_validation_missing_lastname)
          .thenReturn("Last name is required.");

      final result = authValidator.validateLastName(null);

      expect(result, "Last name is required.");
    });

    test("returns missing last name error when input is empty", () {
      when(mockLocalizations.auth_validation_missing_lastname)
          .thenReturn("Last name is required.");

      final result = authValidator.validateLastName("");

      expect(result, "Last name is required.");
    });

    test("returns long last name error when input is too long", () {
      when(mockLocalizations.auth_validation_long_lastname)
          .thenReturn("Last name is too long.");

      final result = authValidator.validateLastName("a" * 61);

      expect(result, "Last name is too long.");
    });

    test("returns null when input is valid", () {
      final result = authValidator.validateLastName("ValidName");

      expect(result, null);
    });
  });

  group("AuthValidator_validateBirthDate", () {
    test("returns missing birth date error when input is null", () {
      when(mockLocalizations.auth_validation_missing_birthdate)
          .thenReturn("Birthdate is required");

      final result = authValidator.validateBirthDate(null);

      expect(result, "Birthdate is required");
    });

    test("returns missing birth date error when input is empty", () {
      when(mockLocalizations.auth_validation_missing_birthdate)
          .thenReturn("Birthdate is required");

      final result = authValidator.validateBirthDate("");

      expect(result, "Birthdate is required");
    });

    test("return invalid date error when input date is invalid", () {
      when(mockLocalizations.auth_validation_invalid_date)
          .thenReturn("Invalid date");

      final result = authValidator.validateBirthDate("35.12.2022");

      expect(result, "Invalid date");
    });

    test("return invalid birthdate error when age is not 18 or older", () {
      when(mockLocalizations.auth_validation_invalid_birthdate)
          .thenReturn("Invalid birthdate");

      final result = authValidator.validateBirthDate("01.01.2020");

      expect(result, "Invalid birthdate");
    });

    test("returns null when input is valid", () {
      final result = authValidator.validateBirthDate("01.01.2000");

      expect(result, null);
    });
  });

  group("AuthValidator_validatePostCode", () {
    test("returns null when input is null", () {
      final result = authValidator.validatePostcode(null);

      expect(result, null);
    });

    test("returns null when input is empty", () {
      final result = authValidator.validatePostcode("");

      expect(result, null);
    });

    test("returns null when input is a number", () {
      final result = authValidator.validatePostcode("41542");

      expect(result, null);
    });

    test("returns invalid postcode error when input is not a number", () {
      when(mockLocalizations.auth_validation_invalid_postcode)
          .thenReturn("Invalid postcode");

      final result = authValidator.validatePostcode("a");

      expect(result, "Invalid postcode");
    });
  });

  group("AuthValidator_validateGender", () {
    test("returns missing gender error when input is null", () {
      when(mockLocalizations.auth_validation_missing_gender)
          .thenReturn("Missing gender");

      final result = authValidator.validateGender(null);

      expect(result, "Missing gender");
    });

    test("returns missing gender error when input is none", () {
      when(mockLocalizations.auth_validation_missing_gender)
          .thenReturn("Missing gender");

      final result = authValidator.validateGender(Gender.none);

      expect(result, "Missing gender");
    });

    test("returns null when input is a valid gender", () {
      final result = authValidator.validateGender(Gender.male);

      expect(result, null);
    });
  });

  group("AuthValidator_validateCode", () {
    test("returns missing code error when input is null", () {
      when(mockLocalizations.auth_validation_missing_code)
          .thenReturn("Missing code");

      final result = authValidator.validateCode(null);

      expect(result, "Missing code");
    });

    test("returns missing code error when input is empty", () {
      when(mockLocalizations.auth_validation_missing_code)
          .thenReturn("Missing code");

      final result = authValidator.validateCode("");

      expect(result, "Missing code");
    });

    test("returns null when input is input is valid", () {
      final result = authValidator.validateCode("a");

      expect(result, null);
    });
  });
}
