import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_form_validator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'auth_validator_test.mocks.dart';

void main() {
  late LandingPageCreatorFormValidator formValidator;
  late MockAppLocalizations mockLocalizations;

  setUp(() {
    mockLocalizations = MockAppLocalizations();
    formValidator =
        LandingPageCreatorFormValidator(localization: mockLocalizations);
  });

  group("LandingPageCreatorFormValidator_validateLandingPageName", () {
    test("returns missing name error when input is null", () {
      when(mockLocalizations.landingpage_validate_LandingPageName)
          .thenReturn("Missing name");

      final result = formValidator.validateLandingPageName(null);

      expect(result, "Missing name");
    });

    test("returns missing name error when input is empty", () {
      when(mockLocalizations.landingpage_validate_LandingPageName)
          .thenReturn("Missing name");

      final result = formValidator.validateLandingPageName("");

      expect(result, "Missing name");
    });

    test("returns null when input is valid", () {
      final result = formValidator.validateLandingPageName("Test");

      expect(result, null);
    });
  });

  group("LandingPageCreatorFormValidator_validateLandingPageText", () {
    test("returns missing text error when input is null", () {
      when(mockLocalizations.landingpage_validate_LandingPageText)
          .thenReturn("Missing text");

      final result = formValidator.validateLandingPageText(null);

      expect(result, "Missing text");
    });

    test("returns missing text error when input is empty", () {
      when(mockLocalizations.landingpage_validate_LandingPageText)
          .thenReturn("Missing text");

      final result = formValidator.validateLandingPageText("");

      expect(result, "Missing text");
    });

    test("returns null when input is valid", () {
      final result = formValidator.validateLandingPageText("Test");

      expect(result, null);
    });
  });

  group("LandingPageCreatorFormValidator_validateLandingPageImpressum", () {
    test("returns missing text error when input is null", () {
      when(mockLocalizations.landingpage_validate_impressum)
          .thenReturn("Missing impressum");

      final result = formValidator.validateLandingPageImpressum(null);

      expect(result, "Missing impressum");
    });

    test("returns missing text error when input is empty", () {
      when(mockLocalizations.landingpage_validate_impressum)
          .thenReturn("Missing impressum");

      final result = formValidator.validateLandingPageImpressum("");

      expect(result, "Missing impressum");
    });

    test("returns null when input is valid", () {
      final result = formValidator.validateLandingPageImpressum("Test");

      expect(result, null);
    });
  });

  group("LandingPageCreatorFormValidator_validateLandingPagePrivacyPolicy", () {
    test("returns missing text error when input is null", () {
      when(mockLocalizations.landingpage_validate_privacy_policy)
          .thenReturn("Missing privacy policy");

      final result = formValidator.validateLandingPagePrivacyPolicy(null);

      expect(result, "Missing privacy policy");
    });

    test("returns missing text error when input is empty", () {
      when(mockLocalizations.landingpage_validate_privacy_policy)
          .thenReturn("Missing privacy policy");

      final result = formValidator.validateLandingPagePrivacyPolicy("");

      expect(result, "Missing privacy policy");
    });

    test("returns null when input is valid", () {
      final result = formValidator.validateLandingPagePrivacyPolicy("Test");

      expect(result, null);
    });
  });

  group("LandingPageCreatorFormValidator_validateLandingPageInitialInformation",
      () {
    test("returns missing text error when input is null", () {
      when(mockLocalizations.landingpage_validate_initial_information)
          .thenReturn("Missing initial information");

      final result = formValidator.validateLandingPageInitialInformation(null);

      expect(result, "Missing initial information");
    });

    test("returns missing text error when input is empty", () {
      when(mockLocalizations.landingpage_validate_initial_information)
          .thenReturn("Missing initial information");

      final result = formValidator.validateLandingPageInitialInformation("");

      expect(result, "Missing initial information");
    });

    test("returns null when input is valid", () {
      final result =
          formValidator.validateLandingPageInitialInformation("Test");

      expect(result, null);
    });
  });
}
