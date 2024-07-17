import 'package:finanzbegleiter/presentation/recommendations_page/leads_validator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'auth_validator_test.mocks.dart';

void main() {
  late LeadsValidator leadsValidator;
  late MockAppLocalizations mockLocalizations;

  setUp(() {
    mockLocalizations = MockAppLocalizations();
    leadsValidator = LeadsValidator(localization: mockLocalizations);
  });

  group("LeadsValidator_validateLeadsName", () {
    test("returns missing name error when input is null", () {
      when(mockLocalizations.recommendations_validation_missing_lead_name)
          .thenReturn("Missing name");

      final result = leadsValidator.validateLeadsName(null);

      expect(result, "Missing name");
    });

    test("returns missing name error when input is empty", () {
      when(mockLocalizations.recommendations_validation_missing_lead_name)
          .thenReturn("Missing name");

      final result = leadsValidator.validateLeadsName("");

      expect(result, "Missing name");
    });

    test("returns null when input is valid", () {
      final result = leadsValidator.validateLeadsName("Max Test");

      expect(result, null);
    });
  });

  group("LeadsValidator_validatePromotersName", () {
    test("returns missing name error when input is null", () {
      when(mockLocalizations.recommendations_validation_missing_promoter_name)
          .thenReturn("Missing name");

      final result = leadsValidator.validatePromotersName(null);

      expect(result, "Missing name");
    });

    test("returns missing name error when input is empty", () {
      when(mockLocalizations.recommendations_validation_missing_promoter_name)
          .thenReturn("Missing name");

      final result = leadsValidator.validatePromotersName("");

      expect(result, "Missing name");
    });

    test("returns null when input is valid", () {
      final result = leadsValidator.validatePromotersName("Max Test");

      expect(result, null);
    });
  });

  group("LeadsValidator_validateReason", () {
    test("returns missing reason error when input is null", () {
      when(mockLocalizations.recommendations_validation_missing_reason)
          .thenReturn("Missing reason");

      final result = leadsValidator.validateReason(null);

      expect(result, "Missing reason");
    });

    test("returns null when input is valid", () {
      final result = leadsValidator.validateReason("Test");

      expect(result, null);
    });
  });
}
