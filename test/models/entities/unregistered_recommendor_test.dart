import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/registered_recommendor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("UnregisteredRecommendor_CopyWith", () {
    test("set email with copyWith should set email for resulting object", () {
      // Given
      final unregisteredRecommendor = UnregisteredRecommendor(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.male,
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          parentUserID: UniqueID.fromUniqueString("2"),
          code: UniqueID.fromUniqueString("1234"));

      final expectedResult = UnregisteredRecommendor(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.male,
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          email: "tester@test.de",
          parentUserID: UniqueID.fromUniqueString("2"),
          code: UniqueID.fromUniqueString("1234"));

      // When
      final result = unregisteredRecommendor.copyWith(email: "tester@test.de");

      // Then
      expect(expectedResult, result);
    });

    test(
        "set email, firstName and parentUserID with copyWith should set the fields for resulting object",
        () {
      // Given
      final unregisteredRecommendor = UnregisteredRecommendor(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.male,
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          code: UniqueID.fromUniqueString("1234"));

      final expectedResult = UnregisteredRecommendor(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.male,
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          email: "tester@test.de",
          parentUserID: UniqueID.fromUniqueString("2"),
          code: UniqueID.fromUniqueString("1234"));

      // When
      final result = unregisteredRecommendor.copyWith(
          email: "tester@test.de",
          firstName: "Max",
          parentUserID: UniqueID.fromUniqueString("2"));

      // Then
      expect(expectedResult, result);
    });
  });

  group("UnregisteredRecommendor_props", () { 
    test("check if value equality works",() {
      // Given
      final user1 = UnregisteredRecommendor(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.male,
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          email: "tester@test.de",
          parentUserID: UniqueID.fromUniqueString("2"),
          code: UniqueID.fromUniqueString("1234"));

      final user2 = UnregisteredRecommendor(
          id: UniqueID.fromUniqueString("1"),
          gender: Gender.male,
          firstName: "Max",
          lastName: "Mustermann",
          birthDate: "23.12.2023",
          email: "tester@test.de",
          parentUserID: UniqueID.fromUniqueString("2"),
          code: UniqueID.fromUniqueString("1234"));
      // Then
      expect(user1, user2);
    });
  });
}
