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
}
