import 'package:finanzbegleiter/features/legals/domain/archived_landing_page_legals.dart';
import 'package:finanzbegleiter/features/legals/domain/legal_version.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("ArchivedLandingPageLegals_Props", () {
    test("check if value equality works", () {
      // Given
      final date = DateTime(2024, 1, 15);
      final legals1 = ArchivedLandingPageLegals(
        id: "test-id",
        privacyPolicyVersions: [
          LegalVersion(content: "Privacy", archivedAt: date, version: 1),
        ],
      );
      final legals2 = ArchivedLandingPageLegals(
        id: "test-id",
        privacyPolicyVersions: [
          LegalVersion(content: "Privacy", archivedAt: date, version: 1),
        ],
      );
      // Then
      expect(legals1, legals2);
    });

    test("check if default values are empty lists", () {
      // Given
      final legals = ArchivedLandingPageLegals(id: "test-id");
      // Then
      expect(legals.privacyPolicyVersions, isEmpty);
      expect(legals.initialInformationVersions, isEmpty);
      expect(legals.termsAndConditionsVersions, isEmpty);
    });
  });

  group("ArchivedLandingPageLegals_PrivacyPolicyLastUpdated", () {
    test("returns null when no versions exist", () {
      // Given
      final legals = ArchivedLandingPageLegals(id: "test-id");
      // Then
      expect(legals.privacyPolicyLastUpdated, isNull);
    });

    test("returns date of latest version", () {
      // Given
      final oldDate = DateTime(2024, 1, 15);
      final newDate = DateTime(2024, 2, 20);
      final legals = ArchivedLandingPageLegals(
        id: "test-id",
        privacyPolicyVersions: [
          LegalVersion(content: "Old", archivedAt: oldDate, version: 1),
          LegalVersion(content: "New", archivedAt: newDate, version: 2),
        ],
      );
      // Then
      expect(legals.privacyPolicyLastUpdated, newDate);
    });

    test("returns date of highest version number regardless of order", () {
      // Given
      final oldDate = DateTime(2024, 1, 15);
      final newDate = DateTime(2024, 2, 20);
      final legals = ArchivedLandingPageLegals(
        id: "test-id",
        privacyPolicyVersions: [
          LegalVersion(content: "New", archivedAt: newDate, version: 2),
          LegalVersion(content: "Old", archivedAt: oldDate, version: 1),
        ],
      );
      // Then
      expect(legals.privacyPolicyLastUpdated, newDate);
    });
  });

  group("ArchivedLandingPageLegals_InitialInformationLastUpdated", () {
    test("returns null when no versions exist", () {
      // Given
      final legals = ArchivedLandingPageLegals(id: "test-id");
      // Then
      expect(legals.initialInformationLastUpdated, isNull);
    });

    test("returns date of latest version", () {
      // Given
      final oldDate = DateTime(2024, 1, 15);
      final newDate = DateTime(2024, 2, 20);
      final legals = ArchivedLandingPageLegals(
        id: "test-id",
        initialInformationVersions: [
          LegalVersion(content: "Old", archivedAt: oldDate, version: 1),
          LegalVersion(content: "New", archivedAt: newDate, version: 2),
        ],
      );
      // Then
      expect(legals.initialInformationLastUpdated, newDate);
    });
  });

  group("ArchivedLandingPageLegals_TermsAndConditionsLastUpdated", () {
    test("returns null when no versions exist", () {
      // Given
      final legals = ArchivedLandingPageLegals(id: "test-id");
      // Then
      expect(legals.termsAndConditionsLastUpdated, isNull);
    });

    test("returns date of latest version", () {
      // Given
      final oldDate = DateTime(2024, 1, 15);
      final newDate = DateTime(2024, 2, 20);
      final legals = ArchivedLandingPageLegals(
        id: "test-id",
        termsAndConditionsVersions: [
          LegalVersion(content: "Old", archivedAt: oldDate, version: 1),
          LegalVersion(content: "New", archivedAt: newDate, version: 2),
        ],
      );
      // Then
      expect(legals.termsAndConditionsLastUpdated, newDate);
    });
  });
}
