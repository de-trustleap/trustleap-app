import 'package:finanzbegleiter/domain/entities/last_edit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("LastEdit_CopyWith", () {
    test("set fieldName with copyWith should set fieldName for resulting object", () {
      // Given
      final lastEdit = LastEdit(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      final expectedResult = LastEdit(
        fieldName: "notes",
        editedBy: "user123",
        editedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      // When
      final result = lastEdit.copyWith(fieldName: "notes");
      // Then
      expect(result, expectedResult);
    });

    test("set editedBy with copyWith should set editedBy for resulting object", () {
      // Given
      final lastEdit = LastEdit(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      final expectedResult = LastEdit(
        fieldName: "priority",
        editedBy: "user456",
        editedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      // When
      final result = lastEdit.copyWith(editedBy: "user456");
      // Then
      expect(result, expectedResult);
    });

    test("set editedAt with copyWith should set editedAt for resulting object", () {
      // Given
      final originalDate = DateTime(2023, 12, 25, 10, 30, 0);
      final newDate = DateTime(2023, 12, 26, 11, 45, 0);
      final lastEdit = LastEdit(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: originalDate,
      );
      final expectedResult = LastEdit(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: newDate,
      );
      // When
      final result = lastEdit.copyWith(editedAt: newDate);
      // Then
      expect(result, expectedResult);
    });

    test("set multiple fields with copyWith should set all fields for resulting object", () {
      // Given
      final originalDate = DateTime(2023, 12, 25, 10, 30, 0);
      final newDate = DateTime(2023, 12, 26, 11, 45, 0);
      final lastEdit = LastEdit(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: originalDate,
      );
      final expectedResult = LastEdit(
        fieldName: "notes",
        editedBy: "user456",
        editedAt: newDate,
      );
      // When
      final result = lastEdit.copyWith(
        fieldName: "notes",
        editedBy: "user456",
        editedAt: newDate,
      );
      // Then
      expect(result, expectedResult);
    });

    test("copyWith with no parameters should return identical object", () {
      // Given
      final lastEdit = LastEdit(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      // When
      final result = lastEdit.copyWith();
      // Then
      expect(result, lastEdit);
    });
  });

  group("LastEdit_Props", () {
    test("check if value equality works with same values", () {
      // Given
      final date = DateTime(2023, 12, 25, 10, 30, 0);
      final lastEdit1 = LastEdit(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: date,
      );
      final lastEdit2 = LastEdit(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: date,
      );
      // Then
      expect(lastEdit1, lastEdit2);
    });

    test("check if value equality fails with different fieldName", () {
      // Given
      final date = DateTime(2023, 12, 25, 10, 30, 0);
      final lastEdit1 = LastEdit(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: date,
      );
      final lastEdit2 = LastEdit(
        fieldName: "notes",
        editedBy: "user123",
        editedAt: date,
      );
      // Then
      expect(lastEdit1, isNot(lastEdit2));
    });

    test("check if value equality fails with different editedBy", () {
      // Given
      final date = DateTime(2023, 12, 25, 10, 30, 0);
      final lastEdit1 = LastEdit(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: date,
      );
      final lastEdit2 = LastEdit(
        fieldName: "priority",
        editedBy: "user456",
        editedAt: date,
      );
      // Then
      expect(lastEdit1, isNot(lastEdit2));
    });

    test("check if value equality fails with different editedAt", () {
      // Given
      final lastEdit1 = LastEdit(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      final lastEdit2 = LastEdit(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: DateTime(2023, 12, 26, 11, 45, 0),
      );
      // Then
      expect(lastEdit1, isNot(lastEdit2));
    });

    test("check hashCode consistency", () {
      // Given
      final date = DateTime(2023, 12, 25, 10, 30, 0);
      final lastEdit1 = LastEdit(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: date,
      );
      final lastEdit2 = LastEdit(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: date,
      );
      // Then
      expect(lastEdit1.hashCode, lastEdit2.hashCode);
    });

    test("check toString contains all properties", () {
      // Given
      final lastEdit = LastEdit(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      // When
      final result = lastEdit.toString();
      // Then
      expect(result, contains("LastEdit"));
      expect(result, contains("priority"));
      expect(result, contains("user123"));
    });
  });

  group("LastEdit_Constructor", () {
    test("should create LastEdit with all required parameters", () {
      // Given
      final date = DateTime(2023, 12, 25, 10, 30, 0);
      // When
      final lastEdit = LastEdit(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: date,
      );
      // Then
      expect(lastEdit.fieldName, "priority");
      expect(lastEdit.editedBy, "user123");
      expect(lastEdit.editedAt, date);
    });

    test("should handle different field names", () {
      // Given
      final date = DateTime(2023, 12, 25, 10, 30, 0);
      // When
      final priorityEdit = LastEdit(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: date,
      );
      final notesEdit = LastEdit(
        fieldName: "notes",
        editedBy: "user456",
        editedAt: date,
      );
      // Then
      expect(priorityEdit.fieldName, "priority");
      expect(notesEdit.fieldName, "notes");
    });
  });
}