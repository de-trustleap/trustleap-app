import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/permissions.dart';

void main() {
  group("Permissions", () {
    test("should correctly store permissions map", () {
      // Given
      final permissionsMap = {"deleteCompany": true, "editCompany": false};
      // When
      final permissions = Permissions(permissions: permissionsMap);
      // Then
      expect(permissions.permissions, permissionsMap);
    });

    test("should return true for granted permissions", () {
      // Given
      final permissions = Permissions(permissions: {
        "deleteCompany": true,
        "editCompany": false,
      });

      // Then
      expect(permissions.hasDeleteCompanyPermission(), isTrue);
      expect(permissions.hasEditCompanyPermission(), isFalse);
    });

    test("should return false for missing permissions", () {
      // Given
      final permissions = Permissions(permissions: {
        "editCompany": false,
      });

      // Then
      expect(permissions.hasDeleteCompanyPermission(), isFalse); // Nicht in Map
      expect(permissions.hasEditCompanyPermission(), isFalse);
    });

    test("should be equal when permissions match", () {
      // Given
      final permissions1 = Permissions(permissions: {
        "deleteCompany": true,
        "editCompany": false,
      });

      final permissions2 = Permissions(permissions: {
        "deleteCompany": true,
        "editCompany": false,
      });

      // Then
      expect(permissions1, equals(permissions2));
    });

    test("should not be equal when permissions differ", () {
      // Given
      final permissions1 = Permissions(permissions: {
        "deleteCompany": true,
      });

      final permissions2 = Permissions(permissions: {
        "deleteCompany": false,
      });

      // Then
      expect(permissions1, isNot(equals(permissions2)));
    });
  });
}
