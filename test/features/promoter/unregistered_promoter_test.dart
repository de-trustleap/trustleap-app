import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/promoter/domain/unregistered_promoter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("UnregisteredPromoter_CopyWith", () {
    test("set email with copyWith should set email for resulting object", () {
      // Given
      final unregisteredPromoter = UnregisteredPromoter(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.male,
          firstName: "Max",
          lastName: "Mustermann",
          parentUserID: UniqueID.fromUniqueString("2"),
          code: UniqueID.fromUniqueString("1234"));

      final expectedResult = UnregisteredPromoter(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.male,
          firstName: "Max",
          lastName: "Mustermann",
          email: "tester@test.de",
          parentUserID: UniqueID.fromUniqueString("2"),
          code: UniqueID.fromUniqueString("1234"));

      // When
      final result = unregisteredPromoter.copyWith(email: "tester@test.de");

      // Then
      expect(expectedResult, result);
    });

    test(
        "set email, firstName and parentUserID with copyWith should set the fields for resulting object",
        () {
      // Given
      final unregisteredPromoter = UnregisteredPromoter(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.male,
          lastName: "Mustermann",
          code: UniqueID.fromUniqueString("1234"));

      final expectedResult = UnregisteredPromoter(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.male,
          firstName: "Max",
          lastName: "Mustermann",
          email: "tester@test.de",
          parentUserID: UniqueID.fromUniqueString("2"),
          code: UniqueID.fromUniqueString("1234"));

      // When
      final result = unregisteredPromoter.copyWith(
          email: "tester@test.de",
          firstName: "Max",
          parentUserID: UniqueID.fromUniqueString("2"));

      // Then
      expect(expectedResult, result);
    });
  });

  group("UnregisteredPromoter_props", () {
    test("check if value equality works", () {
      // Given
      final user1 = UnregisteredPromoter(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.male,
          firstName: "Max",
          lastName: "Mustermann",
          email: "tester@test.de",
          parentUserID: UniqueID.fromUniqueString("2"),
          code: UniqueID.fromUniqueString("1234"));

      final user2 = UnregisteredPromoter(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.male,
          firstName: "Max",
          lastName: "Mustermann",
          email: "tester@test.de",
          parentUserID: UniqueID.fromUniqueString("2"),
          code: UniqueID.fromUniqueString("1234"));
      // Then
      expect(user1, user2);
    });
  });
}
