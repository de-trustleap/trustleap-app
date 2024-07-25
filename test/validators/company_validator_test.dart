import 'package:finanzbegleiter/presentation/profile_page/widgets/company/company_validator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'auth_validator_test.mocks.dart';

void main() {
  late CompanyValidator companyValidator;
  late MockAppLocalizations mockLocalizations;

  setUp(() {
    mockLocalizations = MockAppLocalizations();
    companyValidator = CompanyValidator(localization: mockLocalizations);
  });

  group("CompanyValidator_validateName", () {
    test("returns missing name error when input is null", () {
      when(mockLocalizations.profile_company_validator_missing_name)
          .thenReturn("Missing name");

      final result = companyValidator.validateName(null);

      expect(result, "Missing name");
    });

    test("returns missing name error when input is empty", () {
      when(mockLocalizations.profile_company_validator_missing_name)
          .thenReturn("Missing name");

      final result = companyValidator.validateName("");

      expect(result, "Missing name");
    });

    test("returns null when input is valid", () {
      final result = companyValidator.validateName("Test");

      expect(result, null);
    });
  });

  group("CompanyValidator_validateIndustry", () {
    test("returns missing industry error when input is null", () {
      when(mockLocalizations.profile_company_validator_missing_industry)
          .thenReturn("Missing industry");

      final result = companyValidator.validateIndustry(null);

      expect(result, "Missing industry");
    });

    test("returns missing industry error when input is empty", () {
      when(mockLocalizations.profile_company_validator_missing_industry)
          .thenReturn("Missing industry");

      final result = companyValidator.validateIndustry("");

      expect(result, "Missing industry");
    });

    test("returns null when input is valid", () {
      final result = companyValidator.validateIndustry("Test");

      expect(result, null);
    });
  });

  group("CompanyValidator_validateAddress", () {
    test("returns missing address error when input is null", () {
      when(mockLocalizations.profile_company_validator_missing_address)
          .thenReturn("Missing address");

      final result = companyValidator.validateAddress(null);

      expect(result, "Missing address");
    });

    test("returns missing address error when input is empty", () {
      when(mockLocalizations.profile_company_validator_missing_address)
          .thenReturn("Missing address");

      final result = companyValidator.validateAddress("");

      expect(result, "Missing address");
    });

    test("returns null when input is valid", () {
      final result = companyValidator.validateAddress("Test");

      expect(result, null);
    });
  });

  group("CompanyValidator_validatePostCode", () {
    test("returns missing postcode error when input is null", () {
      when(mockLocalizations.profile_company_validator_missing_postCode)
          .thenReturn("Missing postcode");

      final result = companyValidator.validatePostCode(null);

      expect(result, "Missing postcode");
    });

    test("returns missing postcode error when input is empty", () {
      when(mockLocalizations.profile_company_validator_missing_postCode)
          .thenReturn("Missing postcode");

      final result = companyValidator.validatePostCode("");

      expect(result, "Missing postcode");
    });

    test("returns invalid postcode error when input is not valid", () {
      when(mockLocalizations.profile_company_validator_invalid_postCode)
          .thenReturn("Invalid postcode");

      final result = companyValidator.validatePostCode("a");

      expect(result, "Invalid postcode");
    });

    test("returns null when input is valid", () {
      final result = companyValidator.validatePostCode("41542");

      expect(result, null);
    });
  });

  group("CompanyValidator_validatePlace", () {
    test("returns missing place error when input is null", () {
      when(mockLocalizations.profile_company_validator_missing_place)
          .thenReturn("Missing place");

      final result = companyValidator.validatePlace(null);

      expect(result, "Missing place");
    });

    test("returns missing place error when input is empty", () {
      when(mockLocalizations.profile_company_validator_missing_place)
          .thenReturn("Missing place");

      final result = companyValidator.validatePlace("");

      expect(result, "Missing place");
    });

    test("returns null when input is valid", () {
      final result = companyValidator.validatePlace("Test");

      expect(result, null);
    });
  });

  group("CompanyValidator_validatePhoneNumber", () {
    test("returns missing phone number error when input is null", () {
      when(mockLocalizations.profile_company_validator_missing_phone)
          .thenReturn("Missing phone");

      final result = companyValidator.validatePhoneNumber(null);

      expect(result, "Missing phone");
    });

    test("returns missing phone number error when input is empty", () {
      when(mockLocalizations.profile_company_validator_missing_phone)
          .thenReturn("Missing phone");

      final result = companyValidator.validatePhoneNumber("");

      expect(result, "Missing phone");
    });

    test(
        "returns invalid phone number error when input is not valid with number",
        () {
      when(mockLocalizations.profile_company_validator_invalid_phone)
          .thenReturn("Invalid phone");

      final result = companyValidator.validatePhoneNumber("55");

      expect(result, "Invalid phone");
    });

    test(
        "returns invalid phone number error when input is not valid with characters",
        () {
      when(mockLocalizations.profile_company_validator_invalid_phone)
          .thenReturn("Invalid phone");

      final result = companyValidator.validatePhoneNumber("aab");

      expect(result, "Invalid phone");
    });

    test("returns null when input is valid", () {
      final result = companyValidator.validatePhoneNumber("0213388556");

      expect(result, null);
    });
  });
}
