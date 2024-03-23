import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("CustomUser_CopyWith", () {
    test(
        "set firstName with copyWith should set firstName for resulting object",
        () {
      // Given
      final user = CustomUser(
          id: UniqueID.fromUniqueString("1"), lastName: "Mustermann");
      final expectedResult = CustomUser(
          id: UniqueID.fromUniqueString("1"),
          firstName: "Max",
          lastName: "Mustermann");
      // When
      final result = user.copyWith(firstName: "Max");
      // Then
      expect(expectedResult, result);
    });

    test(
        "set lastName, address and promoters with copyWith should set fields for resulting object",
        () {
      // Given
      final user = CustomUser(
          id: UniqueID.fromUniqueString("1"), firstName: "Max");
      final expectedResult = CustomUser(
          id: UniqueID.fromUniqueString("1"),
          firstName: "Max",
          lastName: "Mustermann",
          address: "Teststreet 5",
          promoters: const ["1"]);
      // When
      final result = user.copyWith(lastName: "Mustermann", address: "Teststreet 5", promoters: ["1"]);
      // Then
      expect(expectedResult, result);
    });
  });
}
