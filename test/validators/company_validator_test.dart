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

    });

    test("returns missing address error when input is empty", () {

    });

    test("returns null when input is valid", () {

    });
  });
}
