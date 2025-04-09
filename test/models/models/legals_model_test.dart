import 'package:finanzbegleiter/domain/entities/legals.dart';
import 'package:finanzbegleiter/infrastructure/models/legals_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("LegalsModel_CopyWith", () {
    test(
        "set termsAndCondition with copyWith should set termsAndCondition for resulting object",
        () {
      // Given
      final legals = LegalsModel(
          avv: "Test", privacyPolicy: "Test", termsAndCondition: "Test");
      final expectedResult = LegalsModel(
          avv: "Test", privacyPolicy: "Test", termsAndCondition: "Test2");
      // When
      final result = legals.copyWith(termsAndCondition: "Test2");
      // Then
      expect(result, expectedResult);
    });
  });

  group("LegalsModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "avv": "Test",
        "privacyPolicy": "Test",
        "termsAndCondition": "Test"
      };
      final expectedResult = LegalsModel(
          avv: "Test", privacyPolicy: "Test", termsAndCondition: "Test");
      // When
      final result = LegalsModel.fromMap(map);
      // Then
      expect(expectedResult, result);
    });
  });

  group("LegalsModel_ToDomain", () {
    test("check if conversion from LegalsModel to Legals works", () {
      // Given
      final model = LegalsModel(
          avv: "Test", privacyPolicy: "Test", termsAndCondition: "Test");
      final expectedResult =
          Legals(avv: "Test", privacyPolicy: "Test", termsAndCondition: "Test");
      // When
      final result = model.toDomain();
      // Then
      expect(expectedResult, result);
    });
  });

  group("LegalsModel_Props", () {
    test("check if value equality works", () {
      // Given
      final legals1 = LegalsModel(
          avv: "Test", privacyPolicy: "Test", termsAndCondition: "Test");
      final legals2 = LegalsModel(
          avv: "Test", privacyPolicy: "Test", termsAndCondition: "Test");
      // Then
      expect(legals1, legals2);
    });
  });
}
