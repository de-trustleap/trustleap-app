import 'package:finanzbegleiter/features/landing_pages/domain/last_edit.dart';
import 'package:finanzbegleiter/features/landing_pages/infrastructure/last_edit_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("LastEditModel_CopyWith", () {
    test("set fieldName with copyWith should set fieldName for resulting object", () {
      // Given
      final lastEditModel = LastEditModel(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      final expectedResult = LastEditModel(
        fieldName: "notes",
        editedBy: "user123",
        editedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      // When
      final result = lastEditModel.copyWith(fieldName: "notes");
      // Then
      expect(result, expectedResult);
    });

    test("set editedBy with copyWith should set editedBy for resulting object", () {
      // Given
      final lastEditModel = LastEditModel(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      final expectedResult = LastEditModel(
        fieldName: "priority",
        editedBy: "user456",
        editedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      // When
      final result = lastEditModel.copyWith(editedBy: "user456");
      // Then
      expect(result, expectedResult);
    });

    test("set editedAt with copyWith should set editedAt for resulting object", () {
      // Given
      final originalDate = DateTime(2023, 12, 25, 10, 30, 0);
      final newDate = DateTime(2023, 12, 26, 11, 45, 0);
      final lastEditModel = LastEditModel(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: originalDate,
      );
      final expectedResult = LastEditModel(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: newDate,
      );
      // When
      final result = lastEditModel.copyWith(editedAt: newDate);
      // Then
      expect(result, expectedResult);
    });
  });

  group("LastEditModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = LastEditModel(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );

      final expectedResult = {
        "fieldName": "priority",
        "editedBy": "user123",
        "editedAt": "2023-12-25T10:30:00.000",
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("LastEditModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "fieldName": "priority",
        "editedBy": "user123",
        "editedAt": "2023-12-25T10:30:00.000",
      };
      final expectedResult = LastEditModel(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      // When
      final result = LastEditModel.fromMap(map);
      // Then
      expect(expectedResult, result);
    });
  });

  group("LastEditModel_ToDomain", () {
    test("check if conversion from LastEditModel to LastEdit works", () {
      // Given
      final model = LastEditModel(
        fieldName: "notes",
        editedBy: "user456",
        editedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );

      final expectedResult = LastEdit(
        fieldName: "notes",
        editedBy: "user456",
        editedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );

      // When
      final result = model.toDomain();
      // Then
      expect(expectedResult, result);
    });
  });

  group("LastEditModel_FromDomain", () {
    test("check if conversion from LastEdit to LastEditModel works", () {
      // Given
      final lastEdit = LastEdit(
        fieldName: "priority",
        editedBy: "user789",
        editedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      final expectedResult = LastEditModel(
        fieldName: "priority",
        editedBy: "user789",
        editedAt: DateTime(2023, 12, 25, 10, 30, 0),
      );
      // When
      final result = LastEditModel.fromDomain(lastEdit);
      // Then
      expect(result, expectedResult);
    });
  });

  group("LastEditModel_Props", () {
    test("check if value equality works", () {
      // Given
      final date = DateTime(2023, 12, 25, 10, 30, 0);
      final lastEditModel1 = LastEditModel(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: date,
      );
      final lastEditModel2 = LastEditModel(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: date,
      );
      // Then
      expect(lastEditModel1, lastEditModel2);
    });

    test("check if value equality fails with different values", () {
      // Given
      final date = DateTime(2023, 12, 25, 10, 30, 0);
      final lastEditModel1 = LastEditModel(
        fieldName: "priority",
        editedBy: "user123",
        editedAt: date,
      );
      final lastEditModel2 = LastEditModel(
        fieldName: "notes",
        editedBy: "user123",
        editedAt: date,
      );
      // Then
      expect(lastEditModel1, isNot(lastEditModel2));
    });
  });
}