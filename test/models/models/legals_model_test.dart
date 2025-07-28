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
    test("check if map with versioned structure is successfully converted to model", () {
      // Given
      final map = {
        "avvVersions": [
          {"content": "Old AVV", "version": 1, "archivedAt": "2023-01-01"},
          {"content": "Latest AVV", "version": 2, "archivedAt": "2023-02-01"},
        ],
        "privacyPolicyVersions": [
          {"content": "Latest Privacy Policy", "version": 1, "archivedAt": "2023-01-01"},
        ],
        "termsAndConditionsVersions": [
          {"content": "Old Terms", "version": 1, "archivedAt": "2023-01-01"},
          {"content": "Latest Terms", "version": 3, "archivedAt": "2023-03-01"},
          {"content": "Middle Terms", "version": 2, "archivedAt": "2023-02-01"},
        ]
      };
      final expectedResult = LegalsModel(
          avv: "Latest AVV", 
          privacyPolicy: "Latest Privacy Policy", 
          termsAndCondition: "Latest Terms");
      // When
      final result = LegalsModel.fromMap(map);
      // Then
      expect(expectedResult, result);
    });

    test("check if map with empty version arrays returns null values", () {
      // Given
      final map = {
        "avvVersions": [],
        "privacyPolicyVersions": [],
        "termsAndConditionsVersions": []
      };
      final expectedResult = LegalsModel(
          avv: null, 
          privacyPolicy: null, 
          termsAndCondition: null);
      // When
      final result = LegalsModel.fromMap(map);
      // Then
      expect(expectedResult, result);
    });

    test("check if map with null version arrays returns null values", () {
      // Given
      final map = {
        "avvVersions": null,
        "privacyPolicyVersions": null,
        "termsAndConditionsVersions": null
      };
      final expectedResult = LegalsModel(
          avv: null, 
          privacyPolicy: null, 
          termsAndCondition: null);
      // When
      final result = LegalsModel.fromMap(map);
      // Then
      expect(expectedResult, result);
    });

    test("check if map with missing version arrays returns null values", () {
      // Given
      final map = <String, dynamic>{};
      final expectedResult = LegalsModel(
          avv: null, 
          privacyPolicy: null, 
          termsAndCondition: null);
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
