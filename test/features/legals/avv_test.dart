import 'package:finanzbegleiter/features/legals/domain/avv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("AVV_CopyWith", () {
    test(
        "set downloadURL with copyWith should set downloadURL for resulting object",
        () {
      // Given
      final avv = AVV(
          approvedAt: DateTime.fromMicrosecondsSinceEpoch(100),
          downloadURL: "https://test.de",
          path: "path");
      final expectedResult = AVV(
          approvedAt: DateTime.fromMicrosecondsSinceEpoch(100),
          downloadURL: "https://test-neu.de",
          path: "path");
      // When
      final result = avv.copyWith(downloadURL: "https://test-neu.de");
      // Then
      expect(result, expectedResult);
    });
  });

  group("AVV_props", () {
    test("check if value equality works", () {
      // Given
      final avv1 = AVV(
          approvedAt: DateTime.fromMicrosecondsSinceEpoch(100),
          downloadURL: "https://test.de",
          path: "path");
      final avv2 = AVV(
          approvedAt: DateTime.fromMicrosecondsSinceEpoch(100),
          downloadURL: "https://test.de",
          path: "path");
      // Then
      expect(avv1, avv2);
    });
  });
}
