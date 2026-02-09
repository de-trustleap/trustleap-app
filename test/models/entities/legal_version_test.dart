import 'package:finanzbegleiter/domain/entities/legal_version.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("LegalVersion_Props", () {
    test("check if value equality works", () {
      // Given
      final date = DateTime(2024, 1, 15);
      final version1 = LegalVersion(
        content: "Test Content",
        archivedAt: date,
        version: 1,
      );
      final version2 = LegalVersion(
        content: "Test Content",
        archivedAt: date,
        version: 1,
      );
      // Then
      expect(version1, version2);
    });

    test("check if different content results in inequality", () {
      // Given
      final date = DateTime(2024, 1, 15);
      final version1 = LegalVersion(
        content: "Test Content 1",
        archivedAt: date,
        version: 1,
      );
      final version2 = LegalVersion(
        content: "Test Content 2",
        archivedAt: date,
        version: 1,
      );
      // Then
      expect(version1, isNot(equals(version2)));
    });

    test("check if different version number results in inequality", () {
      // Given
      final date = DateTime(2024, 1, 15);
      final version1 = LegalVersion(
        content: "Test Content",
        archivedAt: date,
        version: 1,
      );
      final version2 = LegalVersion(
        content: "Test Content",
        archivedAt: date,
        version: 2,
      );
      // Then
      expect(version1, isNot(equals(version2)));
    });

    test("check if different archivedAt results in inequality", () {
      // Given
      final version1 = LegalVersion(
        content: "Test Content",
        archivedAt: DateTime(2024, 1, 15),
        version: 1,
      );
      final version2 = LegalVersion(
        content: "Test Content",
        archivedAt: DateTime(2024, 2, 15),
        version: 1,
      );
      // Then
      expect(version1, isNot(equals(version2)));
    });
  });
}
