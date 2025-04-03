import 'package:finanzbegleiter/domain/entities/avv.dart';
import 'package:finanzbegleiter/infrastructure/models/avv_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("AVVModel_CopyWith", () {
    test(
        "set downloadURL with copyWith should set downloadURL for resulting object",
        () {
      // Given
      final avv = AVVModel(
          approvedAt: DateTime.fromMillisecondsSinceEpoch(100),
          downloadURL: "https://test.de",
          path: "path");
      final expectedResult = AVVModel(
          approvedAt: DateTime.fromMillisecondsSinceEpoch(100),
          downloadURL: "https://test-neu.de",
          path: "path");
      // When
      final result = avv.copyWith(downloadURL: "https://test-neu.de");
      // Then
      expect(result, expectedResult);
    });
  });

  group("AVVModel_ToMap", () {
    test("check if model is successfully converted to a map", () {
      // Given
      final model = AVVModel(
          approvedAt: null, downloadURL: "https://test.de", path: "path");

      final expectedResult = {
        "approvedAt": null,
        "downloadURL": "https://test.de",
        "pdfPath": "path"
      };
      // When
      final result = model.toMap();
      // Then
      expect(result, expectedResult);
    });
  });

  group("AVVModel_FromMap", () {
    test("check if map is successfully converted to model", () {
      // Given
      final map = {
        "approvedAt": null,
        "downloadURL": "https://test.de",
        "pdfPath": "path"
      };
      final expectedResult = AVVModel(
          approvedAt: null, downloadURL: "https://test.de", path: "path");
      // When
      final result = AVVModel.fromMap(map);
      // Then
      expect(expectedResult, result);
    });
  });

  group("AVVModel_ToDomain", () {
    test("check if conversion from AVVModel to AVV works", () {
      // Given
      final model = AVVModel(
          approvedAt: DateTime.fromMillisecondsSinceEpoch(100),
          downloadURL: "https://test.de",
          path: "path");

      final expectedResult = AVV(
          approvedAt: DateTime.fromMillisecondsSinceEpoch(100),
          downloadURL: "https://test.de",
          path: "path");

      // When
      final result = model.toDomain();
      // Then
      expect(expectedResult, result);
    });
  });

  group("AVVModel_FromDomain", () {
    test("check if conversion from AVV to AVVModel works", () {
      // Given
      final company = AVV(
          approvedAt: DateTime.fromMillisecondsSinceEpoch(100),
          downloadURL: "https://test.de",
          path: "path");
      final expectedResult = AVVModel(
          approvedAt: DateTime.fromMillisecondsSinceEpoch(100),
          downloadURL: "https://test.de",
          path: "path");
      // When
      final result = AVVModel.fromDomain(company);
      // Then
      expect(result, expectedResult);
    });
  });

  group("AVVModel_Props", () {
    test("check if value equality works", () {
      // Given
      final avv1 = AVVModel(
          approvedAt: DateTime.fromMillisecondsSinceEpoch(100),
          downloadURL: "https://test.de",
          path: "path");
      final avv2 = AVVModel(
          approvedAt: DateTime.fromMillisecondsSinceEpoch(100),
          downloadURL: "https://test.de",
          path: "path");
      // Then
      expect(avv1, avv2);
    });
  });
}
