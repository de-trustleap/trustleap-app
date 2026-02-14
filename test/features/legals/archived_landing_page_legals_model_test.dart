import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finanzbegleiter/features/legals/domain/archived_landing_page_legals.dart';
import 'package:finanzbegleiter/features/legals/domain/legal_version.dart';
import 'package:finanzbegleiter/features/legals/infrastructure/archived_landing_page_legals_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("ArchivedLandingPageLegalsModel_FromMap", () {
    test("check if map with versioned structure is successfully converted to model", () {
      // Given
      final date1 = DateTime(2024, 1, 15);
      final date2 = DateTime(2024, 2, 20);
      final map = {
        "id": "test-id",
        "privacyPolicyVersions": [
          {
            "content": "Privacy v1",
            "archivedAt": Timestamp.fromDate(date1),
            "version": 1
          },
          {
            "content": "Privacy v2",
            "archivedAt": Timestamp.fromDate(date2),
            "version": 2
          },
        ],
        "initialInformationVersions": [
          {
            "content": "Initial Info v1",
            "archivedAt": Timestamp.fromDate(date1),
            "version": 1
          },
        ],
        "termsAndConditionsVersions": [
          {
            "content": "Terms v1",
            "archivedAt": Timestamp.fromDate(date1),
            "version": 1
          },
        ],
      };
      final expectedResult = ArchivedLandingPageLegalsModel(
        id: "test-id",
        privacyPolicyVersions: [
          LegalVersion(content: "Privacy v1", archivedAt: date1, version: 1),
          LegalVersion(content: "Privacy v2", archivedAt: date2, version: 2),
        ],
        initialInformationVersions: [
          LegalVersion(content: "Initial Info v1", archivedAt: date1, version: 1),
        ],
        termsAndConditionsVersions: [
          LegalVersion(content: "Terms v1", archivedAt: date1, version: 1),
        ],
      );
      // When
      final result = ArchivedLandingPageLegalsModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });

    test("check if map with empty version arrays returns empty lists", () {
      // Given
      final map = {
        "id": "test-id",
        "privacyPolicyVersions": [],
        "initialInformationVersions": [],
        "termsAndConditionsVersions": [],
      };
      final expectedResult = ArchivedLandingPageLegalsModel(
        id: "test-id",
        privacyPolicyVersions: [],
        initialInformationVersions: [],
        termsAndConditionsVersions: [],
      );
      // When
      final result = ArchivedLandingPageLegalsModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });

    test("check if map with null version arrays returns empty lists", () {
      // Given
      final map = {
        "id": "test-id",
        "privacyPolicyVersions": null,
        "initialInformationVersions": null,
        "termsAndConditionsVersions": null,
      };
      final expectedResult = ArchivedLandingPageLegalsModel(
        id: "test-id",
        privacyPolicyVersions: [],
        initialInformationVersions: [],
        termsAndConditionsVersions: [],
      );
      // When
      final result = ArchivedLandingPageLegalsModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });

    test("check if map with missing version arrays returns empty lists", () {
      // Given
      final map = {"id": "test-id"};
      final expectedResult = ArchivedLandingPageLegalsModel(
        id: "test-id",
        privacyPolicyVersions: [],
        initialInformationVersions: [],
        termsAndConditionsVersions: [],
      );
      // When
      final result = ArchivedLandingPageLegalsModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });

    test("check if map with missing id returns empty string", () {
      // Given
      final map = <String, dynamic>{};
      final expectedResult = ArchivedLandingPageLegalsModel(
        id: "",
        privacyPolicyVersions: [],
        initialInformationVersions: [],
        termsAndConditionsVersions: [],
      );
      // When
      final result = ArchivedLandingPageLegalsModel.fromMap(map);
      // Then
      expect(result, expectedResult);
    });
  });

  group("ArchivedLandingPageLegalsModel_ToDomain", () {
    test("check if conversion from model to domain works", () {
      // Given
      final date = DateTime(2024, 1, 15);
      final model = ArchivedLandingPageLegalsModel(
        id: "test-id",
        privacyPolicyVersions: [
          LegalVersion(content: "Privacy", archivedAt: date, version: 1),
        ],
        initialInformationVersions: [
          LegalVersion(content: "Initial Info", archivedAt: date, version: 1),
        ],
        termsAndConditionsVersions: [
          LegalVersion(content: "Terms", archivedAt: date, version: 1),
        ],
      );
      final expectedResult = ArchivedLandingPageLegals(
        id: "test-id",
        privacyPolicyVersions: [
          LegalVersion(content: "Privacy", archivedAt: date, version: 1),
        ],
        initialInformationVersions: [
          LegalVersion(content: "Initial Info", archivedAt: date, version: 1),
        ],
        termsAndConditionsVersions: [
          LegalVersion(content: "Terms", archivedAt: date, version: 1),
        ],
      );
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });

    test("check if conversion with empty lists works", () {
      // Given
      final model = ArchivedLandingPageLegalsModel(id: "test-id");
      final expectedResult = ArchivedLandingPageLegals(id: "test-id");
      // When
      final result = model.toDomain();
      // Then
      expect(result, expectedResult);
    });
  });

  group("ArchivedLandingPageLegalsModel_Props", () {
    test("check if value equality works", () {
      // Given
      final date = DateTime(2024, 1, 15);
      final model1 = ArchivedLandingPageLegalsModel(
        id: "test-id",
        privacyPolicyVersions: [
          LegalVersion(content: "Privacy", archivedAt: date, version: 1),
        ],
      );
      final model2 = ArchivedLandingPageLegalsModel(
        id: "test-id",
        privacyPolicyVersions: [
          LegalVersion(content: "Privacy", archivedAt: date, version: 1),
        ],
      );
      // Then
      expect(model1, model2);
    });

    test("check if different id results in inequality", () {
      // Given
      final model1 = ArchivedLandingPageLegalsModel(id: "test-id-1");
      final model2 = ArchivedLandingPageLegalsModel(id: "test-id-2");
      // Then
      expect(model1, isNot(equals(model2)));
    });

    test("check if different versions results in inequality", () {
      // Given
      final date = DateTime(2024, 1, 15);
      final model1 = ArchivedLandingPageLegalsModel(
        id: "test-id",
        privacyPolicyVersions: [
          LegalVersion(content: "Privacy v1", archivedAt: date, version: 1),
        ],
      );
      final model2 = ArchivedLandingPageLegalsModel(
        id: "test-id",
        privacyPolicyVersions: [
          LegalVersion(content: "Privacy v2", archivedAt: date, version: 2),
        ],
      );
      // Then
      expect(model1, isNot(equals(model2)));
    });
  });
}
