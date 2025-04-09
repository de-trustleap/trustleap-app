import 'package:finanzbegleiter/domain/entities/legals.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Legals_CopyWith", () {
    test(
        "set privacyPolicy with copyWith should set privacyPolicy for resulting object",
        () {
      // Given
      final legals =
          Legals(avv: "Test", privacyPolicy: "Test", termsAndCondition: "Test");
      final expectedResult = Legals(
          avv: "Test", privacyPolicy: "Test-neu", termsAndCondition: "Test");
      // When
      final result = legals.copyWith(privacyPolicy: "Test-neu");
      // Then
      expect(result, expectedResult);
    });
  });

  group("Legals_props", () {
    test("check if value equality works", () {
      // Given
      final legals1 =
          Legals(avv: "Test", privacyPolicy: "Test", termsAndCondition: "Test");
      final legals2 =
          Legals(avv: "Test", privacyPolicy: "Test", termsAndCondition: "Test");
      // Then
      expect(legals1, legals2);
    });
  });
}
