import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_validator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../features/auth/auth_validator_test.mocks.dart';

void main() {
  late RecommendationValidator recommendationValidator;
  late MockAppLocalizations mockLocalizations;

  setUp(() {
    mockLocalizations = MockAppLocalizations();
    recommendationValidator =
        RecommendationValidator(localization: mockLocalizations);
  });

  group("LeadsValidator_validateLeadsName", () {
    test("returns missing name error when input is null", () {
      when(mockLocalizations.recommendations_validation_missing_lead_name)
          .thenReturn("Missing name");

      final result = recommendationValidator.validateLeadsName(null);

      expect(result, "Missing name");
    });

    test("returns missing name error when input is empty", () {
      when(mockLocalizations.recommendations_validation_missing_lead_name)
          .thenReturn("Missing name");

      final result = recommendationValidator.validateLeadsName("");

      expect(result, "Missing name");
    });

    test("returns null when input is valid", () {
      final result = recommendationValidator.validateLeadsName("Max Test");

      expect(result, null);
    });
  });

  group("LeadsValidator_validatePromotersName", () {
    test("returns missing name error when input is null", () {
      when(mockLocalizations.recommendations_validation_missing_promoter_name)
          .thenReturn("Missing name");

      final result = recommendationValidator.validatePromotersName(null);

      expect(result, "Missing name");
    });

    test("returns missing name error when input is empty", () {
      when(mockLocalizations.recommendations_validation_missing_promoter_name)
          .thenReturn("Missing name");

      final result = recommendationValidator.validatePromotersName("");

      expect(result, "Missing name");
    });

    test("returns null when input is valid", () {
      final result = recommendationValidator.validatePromotersName("Max Test");

      expect(result, null);
    });
  });

  group("LeadsValidator_validateReason", () {
    test("returns missing reason error when input is null", () {
      when(mockLocalizations.recommendations_validation_missing_reason)
          .thenReturn("Missing reason");

      final result = recommendationValidator.validateReason(null);

      expect(result, "Missing reason");
    });

    test("returns null when input is valid", () {
      final result = recommendationValidator.validateReason("Test");

      expect(result, null);
    });
  });
}
